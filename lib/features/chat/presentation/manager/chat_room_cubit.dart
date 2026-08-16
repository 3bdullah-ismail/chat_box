import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../profile/data/repositories/profile_repo.dart';
import '../../data/models/message_model.dart';
import '../../data/models/presence_model.dart';
import '../../data/repositories/chat_repo.dart';

part 'chat_room_state.dart';

@injectable
class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepository _chatRepository;
  final ProfileRepo _profileRepo;
  StreamSubscription? _messagesSubscription;
  String? _conversationId;

  ChatRoomCubit({
    required ChatRepository chatRepository,
    required ProfileRepo profileRepo,
  }) : _chatRepository = chatRepository,
       _profileRepo = profileRepo,
       super(ChatRoomInitial());

  Future<UserModel?> getFriendProfile(String friendId) async {
    try {
      return await _profileRepo.getUserProfile(friendId);
    } catch (e) {
      return null;
    }
  }

  void listenToMessages({required String conversationId}) {
    _conversationId = conversationId;
    emit(GetMessagesLoading());

    _messagesSubscription?.cancel();

    _messagesSubscription = _chatRepository
        .getMessagesStream(conversationId: conversationId)
        .listen(
          (messagesList) {
            emit(GetMessagesLoaded(messages: messagesList));
            markAsSeen(conversationId: conversationId);
          },
          onError: (error) {
            String msg = error.toString();
            if (msg.contains('permission-denied')) {
              emit(ChatRoomSessionExpired());
            } else {
              emit(GetMessagesError(message: msg));
            }
          },
        );
  }

  Future<void> sendNewMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final result = await _chatRepository.sendMessage(
      conversationId: conversationId,
      receiverId: receiverId,
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

  Future<void> markAsSeen({required String conversationId}) async {
    await _chatRepository.markMessagesAsSeen(conversationId: conversationId);
  }

  Stream<PresenceModel> getUserPresence(String userId) {
    return _chatRepository.getUserPresence(userId);
  }

  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
  }) async {
    await _chatRepository.setTyping(
      conversationId: conversationId,
      isTyping: isTyping,
    );
  }

  Stream<bool> getTypingStatus({
    required String conversationId,
    required String friendId,
  }) {
    return _chatRepository.getTypingStatus(
      conversationId: conversationId,
      friendId: friendId,
    );
  }

  Future<void> deleteForEveryone({
    required String conversationId,
    required String messageId,
  }) async {
    await _chatRepository.deleteForEveryone(
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  Future<void> deleteForMe({
    required String conversationId,
    required String messageId,
  }) async {
    await _chatRepository.deleteForMe(
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    if (_conversationId != null) {
      _chatRepository.setTyping(
        conversationId: _conversationId!,
        isTyping: false,
      );
    }
    return super.close();
  }
}
