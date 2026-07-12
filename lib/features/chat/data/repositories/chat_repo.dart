import 'package:dartz/dartz.dart';

import '../../../auth/data/models/user_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
  Future<Either<String, String>> startConversation({
    required UserModel friendUser,
    required UserModel currentUser,
  });

  Stream<List<ConversationModel>> getConversations();

  Future<Either<String, void>> sendMessage({
    required String conversationId,
    required String text,
  });

  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  });
}
