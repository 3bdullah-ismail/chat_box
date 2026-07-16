import 'package:injectable/injectable.dart';

import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/data/datasources/friend_data_source.dart';
import 'package:silora/features/friends/data/models/friend_request_model.dart';
import 'package:silora/features/friends/data/repositories/friend_repo.dart';

@LazySingleton(as: FriendRepository)
class FriendRepositoryImp implements FriendRepository {
  final FriendDataSource friendDataSource;

  FriendRepositoryImp({required this.friendDataSource});

  @override
  Future<List<UserModel>> getUsers() => friendDataSource.getUsers();

  @override
  Future<void> sendFriendRequest(String receiverId) =>
      friendDataSource.sendFriendRequest(receiverId);

  @override
  Future<List<FriendRequestModel>> getFriendRequests() =>
      friendDataSource.getFriendRequests();

  @override
  Future<List<FriendRequestModel>> getSentFriendRequests() =>
      friendDataSource.getSentFriendRequests();

  @override
  Future<void> acceptFriendRequest(FriendRequestModel request) =>
      friendDataSource.acceptFriendRequest(request);

  @override
  Future<List<UserModel>> getFriends() => friendDataSource.getFriends();
}
