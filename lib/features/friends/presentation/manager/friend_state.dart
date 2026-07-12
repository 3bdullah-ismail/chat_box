part of 'friend_cubit.dart';

@immutable
sealed class FriendState {}

final class FriendInitial extends FriendState {}

class GetUserLoading extends FriendState {}

class GetUserLoaded extends FriendState {
  final List<UserModel> allUsers;
  final List<UserModel> filteredUsers;

  GetUserLoaded({required this.allUsers, required this.filteredUsers});
}

class GetUserError extends FriendState {
  final String message;

  GetUserError(this.message);
}

final class SendFriendRequestLoading extends FriendState {}

final class SendFriendRequestSuccess extends FriendState {}

final class SendFriendRequestError extends FriendState {
  final String message;

  SendFriendRequestError(this.message);
}

class GetFriendRequestLoading extends FriendState {}

class GetFriendRequestLoaded extends FriendState {
  final List<FriendRequestModel> receivedRequests;
  final List<FriendRequestModel> sentRequests;

  GetFriendRequestLoaded({
    required this.receivedRequests,
    required this.sentRequests,
  });
}

class GetFriendRequestError extends FriendState {
  final String message;

  GetFriendRequestError(this.message);
}

final class AcceptFriendRequestLoading extends FriendState {}

final class AcceptFriendRequestSuccess extends FriendState {}

final class AcceptFriendRequestError extends FriendState {
  final String message;

  AcceptFriendRequestError(this.message);
}

class GetFriendsLoading extends FriendState {}

class GetFriendsLoaded extends FriendState {
  final List<UserModel> friends;

  GetFriendsLoaded(this.friends);
}

class GetFriendsError extends FriendState {
  final String message;

  GetFriendsError(this.message);
}
