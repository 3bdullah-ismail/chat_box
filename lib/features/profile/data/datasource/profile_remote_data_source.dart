import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile(String uid);

  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  });
}
