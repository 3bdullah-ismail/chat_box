import '../../../auth/data/models/user_model.dart';
import '../models/friend_request_model.dart';

abstract class FriendDataSource {
  Future<List<UserModel>> getUsers();

  Future<void> sendFriendRequest(String receiverId);

  Future<List<FriendRequestModel>> getFriendRequests();

  Future<List<FriendRequestModel>> getSentFriendRequests();

  Future<void> acceptFriendRequest(FriendRequestModel request);

  Future<List<UserModel>> getFriends();
}
