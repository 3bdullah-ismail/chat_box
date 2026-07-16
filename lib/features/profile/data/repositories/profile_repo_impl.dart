import 'package:injectable/injectable.dart';

import '../../../auth/data/models/user_model.dart';
import '../datasource/profile_remote_data_source.dart';
import 'profile_repo.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImpl extends ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepoImpl({required this.profileRemoteDataSource});

  @override
  Future<UserModel> getUserProfile(String uid) {
    return profileRemoteDataSource.getUserProfile(uid);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return profileRemoteDataSource.updateProfile(uid: uid, data: data);
  }
}
