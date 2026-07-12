import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/auth_repo.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  static AuthCubit get(context) => BlocProvider.of(context);

  // ─── Private helper ────────────────────────────────────────────────────────
  /// Emits [loading], runs [action], then emits the success/error state.
  Future<void> _run<T>({
    required AuthState loading,
    required Future<T> Function() action,
    required AuthState Function(T result) onSuccess,
    required AuthState Function(String message) onError,
    void Function(Object error, StackTrace stack)? onLog,
  }) async {
    emit(loading);
    try {
      final result = await action();
      emit(onSuccess(result));
    } catch (e, st) {
      onLog?.call(e, st);
      emit(onError(e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword() => _run(
    loading: SignUpLoading(),
    action: () => authRepo.signupWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: nameController.text.trim(),
      username: usernameController.text.trim(),
    ),
    onSuccess: (_) => SignUpSuccess(),
    onError: (msg) => SignUpError(errorMessage: msg),
  );

  Future<void> verificationEmail() => _run(
    loading: VerificationEmailLoading(),
    action: () async {
      final message = await authRepo.verificationEmail();
      await authRepo.signOut();
      return message;
    },
    onSuccess: (msg) => VerificationEmailSuccess(message: msg),
    onError: (msg) => VerificationEmailError(errorMessage: msg),
  );

  Future<void> signInWithEmailAndPassword() => _run(
    loading: SignInLoading(),
    action: () => authRepo.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    ),
    onSuccess: (_) => SignInSuccess(),
    onError: (msg) => SignInError(errorMessage: msg),
  );

  Future<void> signInWithGoogle() => _run(
    loading: SignInLoading(),
    action: () => authRepo.signInWithGoogle(),
    onSuccess: (_) => SignInSuccess(),
    onError: (msg) => SignInError(errorMessage: msg),
    onLog: (e, st) {
      debugPrint('Google Sign-In Error: $e');
      debugPrint('Google Sign-In StackTrace: $st');
    },
  );

  Future<void> signOut() => _run(
    loading: SignOutLoading(),
    action: () => authRepo.signOut(),
    onSuccess: (msg) => SignOutSuccess(message: msg),
    onError: (msg) => SignOutError(errorMessage: msg),
  );

  Future<void> resetPassword() => _run(
    loading: ResetPasswordLoading(),
    action: () => authRepo.resetPassword(emailController.text.trim()),
    onSuccess: (msg) => ResetPasswordSuccess(message: msg),
    onError: (msg) => ResetPasswordError(errorMessage: msg),
  );

  @override
  Future<void> close() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
