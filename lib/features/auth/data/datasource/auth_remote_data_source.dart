import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> resetPassword({required String email});

  Future<String> signOut();

  Future<String> verificationEmail();

  Future<String> signInWithGoogle();

  Future<void> saveUser(UserModel user);
  //
  // Future<UserModel> getUser(String uid);
}
