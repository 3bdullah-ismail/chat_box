import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../data/models/conversation_model.dart';
import '../../data/repositories/chat_repo.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _conversationsSubscription;

  ChatCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatInitial());

  Future<void> startChat({required UserModel friendUser}) async {
    emit(ChatLoading());
    try {
      final myId = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myId)
          .get();
      final currentUser = UserModel.fromFirestore(doc);

      final result = await _chatRepository.startConversation(
        friendUser: friendUser,
        currentUser: currentUser,
      );
      result.fold(
        (failureMessage) => emit(ChatError(message: failureMessage)),
        (conversationId) => emit(ChatSuccess(conversationId: conversationId)),
      );
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final result = await _chatRepository.sendMessage(
      conversationId: conversationId,
      text: text,
    );
    result.fold(
      (failureMessage) => emit(ChatError(message: failureMessage)),
      (_) => null,
    );
  }

  void fetchMyConversations() {
    emit(GetConversationsLoading());
    _conversationsSubscription?.cancel();
    _conversationsSubscription = _chatRepository.getConversations().listen(
      (conversationsList) {
        emit(GetConversationsLoaded(conversations: conversationsList));
      },
      onError: (error) {
        emit(GetConversationsError(message: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
