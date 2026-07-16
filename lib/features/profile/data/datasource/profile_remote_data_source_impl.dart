import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/user_model.dart';
import 'profile_remote_data_source.dart';

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final FirebaseFirestore fireStore;

  ProfileRemoteDataSourceImpl({required this.fireStore});

  @override
  Future<UserModel> getUserProfile(String uid) async {
    try {
      final doc = await fireStore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        throw const ServerException('User profile not found');
      }

      return UserModel.fromFirestore(doc);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(
        'Failed to fetch user profile. Please try again.',
      );
    }
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await fireStore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw const ServerException(
        'Failed to update profile. Please try again.',
      );
    }
  }
}
