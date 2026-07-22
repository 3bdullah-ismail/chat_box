import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/data/models/friend_request_model.dart';
import 'package:silora/features/friends/data/repositories/friend_repo.dart';

part 'friend_state.dart';

@injectable
class FriendCubit extends Cubit<FriendState> {
  final FriendRepository friendRepository;

  FriendCubit({required this.friendRepository}) : super(FriendInitial());

  List<UserModel> _allUsers = [];
  List<FriendRequestModel> _receivedRequests = [];
  List<FriendRequestModel> _sentRequests = [];
  List<UserModel> friends = [];

  List<FriendRequestModel> get receivedRequests => _receivedRequests;
  List<FriendRequestModel> get sentRequests => _sentRequests;

  Future<void> getUsers() async {
    emit(GetUserLoading());
    try {
      _allUsers = await friendRepository.getUsers();
      emit(GetUserLoaded(allUsers: _allUsers, filteredUsers: _allUsers));
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        emit(FriendSessionExpired());
      } else {
        emit(GetUserError('Failed to load users'));
      }
    }
  }

  Future<void> sendFriendRequest(String receiverId) async {
    final previousState = state;
    emit(SendFriendRequestLoading());
    try {
      await friendRepository.sendFriendRequest(receiverId);
      emit(SendFriendRequestSuccess());

      if (previousState is GetUserLoaded) {
        final updatedFiltered = previousState.filteredUsers
            .where((user) => user.id != receiverId)
            .toList();
        emit(
          GetUserLoaded(allUsers: _allUsers, filteredUsers: updatedFiltered),
        );
      }
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('permission-denied')) {
        msg = 'Session expired. Please sign out and sign in again.';
      }
      emit(SendFriendRequestError(msg));
      if (previousState is GetUserLoaded) emit(previousState);
    }
  }

  Future<void> getFriendRequests() async {
    emit(GetFriendRequestLoading());
    try {
      _receivedRequests = await friendRepository.getFriendRequests();
      _sentRequests = await friendRepository.getSentFriendRequests();

      emit(
        GetFriendRequestLoaded(
          receivedRequests: _receivedRequests,
          sentRequests: _sentRequests,
        ),
      );
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        emit(FriendSessionExpired());
      } else {
        emit(GetFriendRequestError('Failed to load friend requests'));
      }
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(GetUserLoaded(allUsers: _allUsers, filteredUsers: _allUsers));
      return;
    }

    final filtered = _allUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.username.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    emit(GetUserLoaded(allUsers: _allUsers, filteredUsers: filtered));
  }

  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    emit(AcceptFriendRequestLoading());
    try {
      await friendRepository.acceptFriendRequest(request);
      emit(AcceptFriendRequestSuccess());
      getFriendRequests();
      getFriends();
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('permission-denied')) {
        msg = 'Session expired. Please sign out and sign in again.';
      }
      emit(AcceptFriendRequestError(msg));
    }
  }

  Future<void> getFriends() async {
    emit(GetFriendsLoading());
    try {
      friends = await friendRepository.getFriends();
      emit(GetFriendsLoaded(friends));
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        emit(FriendSessionExpired());
      } else {
        emit(GetFriendsError('Failed to load friends'));
      }
    }
  }
}
