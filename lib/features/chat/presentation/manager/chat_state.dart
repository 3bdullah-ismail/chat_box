part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final String conversationId;
  final UserModel friendUser;

  ChatSuccess({required this.conversationId, required this.friendUser});
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});
}

class GetConversationsLoading extends ChatState {}

class GetConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;

  GetConversationsLoaded({required this.conversations});
}

class GetConversationsError extends ChatState {
  final String message;

  GetConversationsError({required this.message});
}
