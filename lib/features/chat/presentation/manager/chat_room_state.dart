part of 'chat_room_cubit.dart';

@immutable
abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class GetMessagesLoading extends ChatRoomState {}

class GetMessagesLoaded extends ChatRoomState {
  final List<MessageModel> messages;

  GetMessagesLoaded({required this.messages});
}

class GetMessagesError extends ChatRoomState {
  final String message;

  GetMessagesError({required this.message});
}

class SendMessageLoading extends ChatRoomState {}

class SendMessageSuccess extends ChatRoomState {}

class SendMessageError extends ChatRoomState {
  final String message;

  SendMessageError({required this.message});
}

class ChatRoomSessionExpired extends ChatRoomState {}
