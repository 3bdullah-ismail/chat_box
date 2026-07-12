import '../../../auth/data/models/user_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatDataSource {
  Future<String> createConversation({
    required UserModel friendUser,
    required UserModel currentUser,
  });

  Stream<List<ConversationModel>> getConversations();

  Future<void> sendMessage({
    required String conversationId,
    required String text,
  });

  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  });
}
