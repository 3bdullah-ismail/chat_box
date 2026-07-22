part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserModel user;

  ProfileSuccess({required this.user});
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}

final class UpdateProfileLoading extends ProfileState {}

final class UpdateProfileSuccess extends ProfileState {}

final class UpdateProfileError extends ProfileState {
  final String errorMessage;

  UpdateProfileError({required this.errorMessage});
}

final class ProfileSessionExpired extends ProfileState {}
