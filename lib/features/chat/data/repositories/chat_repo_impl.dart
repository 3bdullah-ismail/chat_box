import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/chat_data_source.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
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
    required String text,
  }) async {
    try {
      await _chatDataSource.sendMessage(
        conversationId: conversationId,
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
}
