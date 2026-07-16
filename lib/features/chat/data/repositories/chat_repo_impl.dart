import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/chat_data_source.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/presence_model.dart';
import 'chat_repo.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl({required ChatDataSource chatDataSource})
    : _chatDataSource = chatDataSource;

  @override
  Future<Either<String, String>> startConversation({
    required UserModel friendUser,
    required UserModel currentUser,
  }) async {
    try {
      final conversationId = await _chatDataSource.createConversation(
        friendUser: friendUser,
        currentUser: currentUser,
      );
      return Right(conversationId);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Stream<List<ConversationModel>> getConversations() {
    return _chatDataSource.getConversations();
  }

  @override
  Future<Either<String, void>> sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) async {
    try {
      await _chatDataSource.sendMessage(
        conversationId: conversationId,
        receiverId: receiverId,
        text: text,
      );
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  }) {
    return _chatDataSource.getMessagesStream(conversationId: conversationId);
  }

  @override
  Future<Either<String, void>> markMessagesAsSeen({
    required String conversationId,
  }) async {
    try {
      await _chatDataSource.markMessagesAsSeen(conversationId: conversationId);
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<void> initPresence() async {
    await _chatDataSource.initPresence();
  }

  @override
  Stream<PresenceModel> getUserPresence(String userId) {
    return _chatDataSource.getUserPresence(userId);
  }

  @override
  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
  }) async {
    await _chatDataSource.setTyping(
      conversationId: conversationId,
      isTyping: isTyping,
    );
  }

  @override
  Stream<bool> getTypingStatus({
    required String conversationId,
    required String friendId,
  }) {
    return _chatDataSource.getTypingStatus(
      conversationId: conversationId,
      friendId: friendId,
    );
  }

  @override
  Future<Either<String, void>> deleteForEveryone({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      await _chatDataSource.deleteForEveryone(
        conversationId: conversationId,
        messageId: messageId,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteForMe({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      await _chatDataSource.deleteForMe(
        conversationId: conversationId,
        messageId: messageId,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
