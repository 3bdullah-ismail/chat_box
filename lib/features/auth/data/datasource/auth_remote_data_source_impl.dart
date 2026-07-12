import 'package:chat_app/core/error/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore fireStore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.fireStore,
    required this.googleSignIn,
  });

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          'User registration succeeded but user object is null.',
        );
      }
      await saveUser(
        UserModel(
          id: user.uid,
          name: name,
          email: email,
          username: username,
          isProfileCompleted: true,
        ),
      );
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const AuthException(
          'Password is too weak. Please choose a stronger one.',
        );
      } else if (e.code == 'email-already-in-use') {
        throw const AuthException('An account with this email already exists.');
      }
      throw const AuthException('Authentication failed. Please try again.');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw const ServerException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          throw const AuthException('Incorrect email or password.');
        case 'too-many-requests':
          throw const AuthException(
            'Too many attempts. Please try again later.',
          );
        case 'network-request-failed':
          throw const ServerException('Check your internet connection.');
        case 'invalid-email':
          throw const AuthException('The email address is not valid.');
        default:
          throw const AuthException('Authentication failed. Please try again.');
      }
    } catch (e) {
      throw const ServerException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await fireStore.collection('users').doc(user.id).set(user.toJson());
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const AuthException('Google sign in failed. User is null.');
      }

      final userDoc = await fireStore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await saveUser(
          UserModel(
            id: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            username: user.email?.split('@')[0] ?? 'google_user',
            isProfileCompleted: true,
          ),
        );
      }

      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthException(
          'An account already exists with a different credential.',
        );
      }
      throw AuthException(
        'Google authentication failed: ${e.message ?? e.code}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(
        'An unexpected error occurred during Google sign in: $e',
      );
    }
  }

  @override
  Future<String> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      return 'Signed out successfully';
    } catch (e) {
      throw const ServerException('Failed to sign out properly.');
    }
  }

  // @override
  // Future<UserModel> getUser(String uid) async {
  //   try {
  //     final doc = await fireStore.collection('users').doc(uid).get();
  //
  //     if (!doc.exists || doc.data() == null) {
  //       throw const ServerException('User not found');
  //     }
  //
  //     return UserModel.fromFirestore(doc);
  //   } catch (e) {
  //     if (e is ServerException || e is AuthException) rethrow;
  //     throw const ServerException(
  //       'Failed to fetch user data. Please try again.',
  //     );
  //   }
  // }

  @override
  Future<String> verificationEmail() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found.');
      }

      if (user.emailVerified) {
        return 'Email is already verified.';
      }

      await user.sendEmailVerification();
      return 'Verification email sent successfully.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const ServerException('Check your internet connection.');
      }
      throw const AuthException('Failed to send verification email.');
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw const ServerException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<String> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent successfully.';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const AuthException('No user found with this email.');
        case 'invalid-email':
          throw const AuthException('The email address is not valid.');
        case 'network-request-failed':
          throw const ServerException('Check your internet connection.');
        default:
          throw const AuthException('Failed to send password reset email.');
      }
    } catch (e) {
      throw const ServerException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }
}
