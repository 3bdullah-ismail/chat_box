import 'package:injectable/injectable.dart';

import '../datasource/auth_remote_data_source.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource authDataSource;

  AuthRepoImpl({required this.authDataSource});

  @override
  Future<String> signupWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  }) {
    return authDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      username: username,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return authDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> saveUser({
    required String uid,
    required String email,
    required String name,
    required String username,
  }) {
    return authDataSource.saveUser(
      UserModel(
        id: uid,
        name: name,
        email: email,
        username: username,
        isProfileCompleted: true,
      ),
    );
  }

  // @override
  // Future<Map<String, dynamic>> getUser(String uid) async {
  //   final user = await authDataSource.getUser(uid);
  //   return user.toJson();
  // }

  @override
  Future<String> signInWithGoogle() {
    return authDataSource.signInWithGoogle();
  }

  @override
  Future<String> signOut() {
    return authDataSource.signOut();
  }

  @override
  Future<String> verificationEmail() {
    return authDataSource.verificationEmail();
  }

  @override
  Future<String> resetPassword(String email) {
    return authDataSource.resetPassword(email: email);
  }
}
