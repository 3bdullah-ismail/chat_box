import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:silora/core/utils/chat_utils.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/chat/data/models/conversation_model.dart';
import 'package:silora/features/chat/data/models/message_model.dart';

import '../models/presence_model.dart';
import 'chat_data_source.dart';

@LazySingleton(as: ChatDataSource)
class ChatRemoteDataSourceImpl implements ChatDataSource {
  final FirebaseDatabase database;
  final FirebaseAuth firebaseAuth;

  ChatRemoteDataSourceImpl({
    required this.database,
    required this.firebaseAuth,
  });

  String get currentUserId => firebaseAuth.currentUser!.uid;

  @override
  Future<String> createConversation({
    required UserModel currentUser,
    required UserModel friendUser,
  }) async {
    final conversationId = ChatUtils.getConversationId(
      currentUser.id,
      friendUser.id,
    );

    final ref = database.ref("conversations/$conversationId");
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        "id": conversationId,
        "participants": {currentUser.id: true, friendUser.id: true},
        "userNames": {
          currentUser.id: currentUser.name,
          friendUser.id: friendUser.name,
        },
        "userImages": {currentUser.id: "", friendUser.id: ""},
        "lastMessage": "",
        "lastMessageSenderId": "",
        "lastMessageTime": 0,
        "unreadCount": {currentUser.id: 0, friendUser.id: 0},
        "createdAt": ServerValue.timestamp,
      });
    }

    return conversationId;
  }

  @override
  Stream<List<ConversationModel>> getConversations() {
    return database
        .ref("conversations")
        .orderByChild("participants/$currentUserId")
        .equalTo(true)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;

          if (data == null) return [];

          final conversations = data.entries.map((entry) {
            final json = Map<String, dynamic>.from(entry.value as Map);
            return ConversationModel.fromJson(json, entry.key.toString());
          }).toList();

          conversations.sort(
            (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
          );

          return conversations;
        });
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) async {
    final messageText = text.trim();
    if (messageText.isEmpty) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final messageRef = database.ref("messages/$conversationId").push();

    await Future.wait([
      messageRef.set({
        "senderId": currentUserId,
        "receiverId": receiverId,
        "text": messageText,
        "timestamp": now,
        "isSeen": false,
        "isDeletedForEveryone": false,
        "deletedForUsers": [],
      }),
      database.ref("conversations/$conversationId").update({
        "lastMessage": messageText,
        "lastMessageSenderId": currentUserId,
        "lastMessageTime": now,

        "unreadCount/$receiverId": ServerValue.increment(1),
      }),
    ]);
  }

  @override
  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  }) {
    return database.ref("messages/$conversationId").onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      final messages = data.entries.map((entry) {
        return MessageModel.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
          entry.key.toString(),
        );
      }).toList();

      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return messages;
    });
  }

  @override
  Future<void> markMessagesAsSeen({required String conversationId}) async {
    final messagesRef = database.ref("messages/$conversationId");
    final snapshot = await messagesRef
        .orderByChild("receiverId")
        .equalTo(currentUserId)
        .get();

    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final Map<String, dynamic> updates = {};

      for (final entry in data.entries) {
        final message = Map<String, dynamic>.from(entry.value);

        if (message["isSeen"] == false) {
          updates["${entry.key}/isSeen"] = true;
        }
      }

      await Future.wait([
        if (updates.isNotEmpty) messagesRef.update(updates),
        database
            .ref("conversations/$conversationId/unreadCount/$currentUserId")
            .set(0),
      ]);
    } else {
      await database
          .ref("conversations/$conversationId/unreadCount/$currentUserId")
          .set(0);
    }
  }

  @override
  Future<void> initPresence() async {
    final connectedRef = database.ref(".info/connected");
    final statusRef = database.ref("status/$currentUserId");

    connectedRef.onValue.listen((event) async {
      try {
        final connected = event.snapshot.value as bool? ?? false;

        if (!connected) return;

        await statusRef.onDisconnect().set({
          "online": false,
          "lastSeen": ServerValue.timestamp,
        });

        await statusRef.set({
          "online": true,
          "lastSeen": ServerValue.timestamp,
        });
      } catch (_) {}
    });
  }

  @override
  Stream<PresenceModel> getUserPresence(String userId) {
    return database.ref("status/$userId").onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        return const PresenceModel(online: false, lastSeen: 0);
      }

      return PresenceModel.fromJson(data);
    });
  }

  @override
  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
  }) async {
    try {
      final ref = database.ref("typing/$conversationId/$currentUserId");
      if (isTyping) {
        await ref.onDisconnect().set(false);
      } else {
        await ref.onDisconnect().cancel();
      }
      await ref.set(isTyping);
    } catch (_) {}
  }

  @override
  Stream<bool> getTypingStatus({
    required String conversationId,
    required String friendId,
  }) {
    return database
        .ref("typing/$conversationId/$friendId")
        .onValue
        .map((event) => event.snapshot.value as bool? ?? false);
  }

  @override
  Future<void> deleteForEveryone({
    required String conversationId,
    required String messageId,
  }) async {
    await database.ref("messages/$conversationId/$messageId").update({
      "text": "This message was deleted",
      "isDeletedForEveryone": true,
    });
  }

  @override
  Future<void> deleteForMe({
    required String conversationId,
    required String messageId,
  }) async {
    final ref = database.ref("messages/$conversationId/$messageId");

    final snapshot = await ref.get();

    if (!snapshot.exists) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    final deletedForUsers = List<String>.from(data["deletedForUsers"] ?? []);

    if (!deletedForUsers.contains(currentUserId)) {
      deletedForUsers.add(currentUserId);
    }

    await ref.update({"deletedForUsers": deletedForUsers});
  }
}
