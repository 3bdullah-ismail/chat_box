import 'package:chat_app/core/utils/chat_utils.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart'; // تأكد من مسار UserModel الخاص بك
import 'package:chat_app/features/chat/data/models/conversation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../models/message_model.dart';
import 'chat_data_source.dart';

@Injectable(as: ChatDataSource)
class ChatRemoteDataSourceImpl implements ChatDataSource {
  final FirebaseDatabase _database;
  final FirebaseAuth _firebaseAuth;

  ChatRemoteDataSourceImpl({
    required FirebaseDatabase database,
    required FirebaseAuth firebaseAuth,
  }) : _database = database,
       _firebaseAuth = firebaseAuth;

  String get _currentUserId => _firebaseAuth.currentUser!.uid;

  @override
  Future<String> createConversation({
    required UserModel friendUser,
    required UserModel currentUser,
  }) async {
    try {
      final conversationId = ChatUtils.getConversationId(
        _currentUserId,
        friendUser.id,
      );

      final ref = _database.ref("conversations/$conversationId");

      final snapshot = await ref.get();

      if (!snapshot.exists) {
        await ref.set({
          "id": conversationId,
          "participants": {_currentUserId: true, friendUser.id: true},
          "userNames": {
            _currentUserId: currentUser.name,
            friendUser.id: friendUser.name,
          },
          "userImages": {
            _currentUserId: currentUser.username,
            friendUser.id: friendUser.username,
          },
          "lastMessage": "",
          "lastMessageTime": DateTime.now().millisecondsSinceEpoch,
          "createdAt": ServerValue.timestamp,
        });
      }

      return conversationId;
    } catch (e) {
      throw Exception("فشل في إنشاء أو جلب غرفة المحادثة: ${e.toString()}");
    }
  }

  @override
  Stream<List<ConversationModel>> getConversations() {
    try {
      return _database
          .ref("conversations")
          .orderByChild("participants/$_currentUserId")
          .equalTo(true)
          .onValue
          .map((event) {
            final Map<dynamic, dynamic>? conversationsMap =
                event.snapshot.value as Map<dynamic, dynamic>?;
            if (conversationsMap == null) return [];

            final List<ConversationModel> conversations = [];
            conversationsMap.forEach((key, value) {
              final Map<String, dynamic> conversationData =
                  Map<String, dynamic>.from(value as Map);
              conversations.add(
                ConversationModel.fromJson(conversationData, key.toString()),
              );
            });

            conversations.sort(
              (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
            );
            return conversations;
          });
    } catch (e) {
      throw Exception("فشل في قراءة قايمة المحادثات: ${e.toString()}");
    }
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;

      final messageRef = _database.ref("messages/$conversationId").push();
      final messageData = {
        "senderId": _currentUserId,
        "text": text,
        "timestamp": currentTime,
        "isSeen": false,
      };
      final conversationUpdateData = {
        "lastMessage": text,
        "lastMessageTime": currentTime,
      };
      await messageRef.set(messageData);
      await _database
          .ref("conversations/$conversationId")
          .update(conversationUpdateData);
    } catch (e) {
      throw Exception("فشل في إرسال الرسالة: ${e.toString()}");
    }
  }

  @override
  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  }) {
    try {
      final messagesRef = _database.ref("messages/$conversationId");
      return messagesRef.onValue.map((event) {
        final Map<dynamic, dynamic>? messagesMap =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (messagesMap == null) return [];

        final List<MessageModel> messages = [];

        messagesMap.forEach((key, value) {
          final Map<String, dynamic> messageData = Map<String, dynamic>.from(
            value as Map,
          );
          messages.add(MessageModel.fromJson(messageData, key.toString()));
        });
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return messages;
      });
    } catch (e) {
      throw Exception("فشل في الاستماع للرسائل: ${e.toString()}");
    }
  }
}
