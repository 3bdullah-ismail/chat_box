abstract class AuthRepo {
  Future<String> signupWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> saveUser({
    required String uid,
    required String email,
    required String name,
    required String username,
  });

  Future<String> resetPassword(String email);

  Future<String> signOut();

  Future<String> verificationEmail();

  Future<String> signInWithGoogle();
}
