import '../../../auth/data/models/user_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/presence_model.dart';

abstract class ChatDataSource {
  Future<String> createConversation({
    required UserModel friendUser,
    required UserModel currentUser,
  });

  Stream<List<ConversationModel>> getConversations();

  Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  });

  Stream<List<MessageModel>> getMessagesStream({
    required String conversationId,
  });

  Future<void> markMessagesAsSeen({required String conversationId});

  Future<void> initPresence();

  Stream<PresenceModel> getUserPresence(String userId);

  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
  });

  Stream<bool> getTypingStatus({
    required String conversationId,
    required String friendId,
  });

  Future<void> deleteForEveryone({
    required String conversationId,
    required String messageId,
  });

  Future<void> deleteForMe({
    required String conversationId,
    required String messageId,
  });
}
