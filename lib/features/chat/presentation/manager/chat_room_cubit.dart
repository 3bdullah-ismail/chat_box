import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repo.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _messagesSubscription;

  ChatRoomCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatRoomInitial());

  void listenToMessages({required String conversationId}) {
    emit(GetMessagesLoading());

    _messagesSubscription?.cancel();

    _messagesSubscription = _chatRepository
        .getMessagesStream(conversationId: conversationId)
        .listen(
          (messagesList) {
            emit(GetMessagesLoaded(messages: messagesList));
          },
          onError: (error) {
            emit(GetMessagesError(message: error.toString()));
          },
        );
  }

  Future<void> sendNewMessage({
    required String conversationId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final result = await _chatRepository.sendMessage(
      conversationId: conversationId,
      text: text.trim(),
    );

    result.fold(
      (failureMessage) {
        emit(SendMessageError(message: failureMessage));
      },
      (_) {
        emit(SendMessageSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
