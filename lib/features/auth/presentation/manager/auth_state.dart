part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {}

final class SignUpError extends AuthState {
  final String errorMessage;

  SignUpError({required this.errorMessage});
}

final class SignInLoading extends AuthState {}

final class SignInSuccess extends AuthState {}

final class SignInError extends AuthState {
  final String errorMessage;

  SignInError({required this.errorMessage});
}

final class VerificationEmailLoading extends AuthState {}

final class VerificationEmailSuccess extends AuthState {
  final String message;

  VerificationEmailSuccess({required this.message});
}

final class VerificationEmailError extends AuthState {
  final String errorMessage;

  VerificationEmailError({required this.errorMessage});
}

final class SignOutLoading extends AuthState {}

final class SignOutSuccess extends AuthState {
  final String message;

  SignOutSuccess({required this.message});
}

final class SignOutError extends AuthState {
  final String errorMessage;

  SignOutError({required this.errorMessage});
}

final class ResetPasswordLoading extends AuthState {}

final class ResetPasswordSuccess extends AuthState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

final class ResetPasswordError extends AuthState {
  final String errorMessage;

  ResetPasswordError({required this.errorMessage});
}
