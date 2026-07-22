import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../data/repositories/profile_repo.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getUserProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepo.getUserProfile(uid);
      emit(ProfileSuccess(user: user));
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('permission-denied') || msg.contains('User profile not found')) {
        emit(ProfileSessionExpired());
      } else {
        emit(ProfileError(errorMessage: msg));
      }
    }
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String username,
    required String bio,
    required String address,
  }) async {
    emit(UpdateProfileLoading());
    try {
      await profileRepo.updateProfile(
        uid: uid,
        data: {'name': name, 'username': username, 'bio': bio, 'address': address},
      );
      emit(UpdateProfileSuccess());
      await getUserProfile(uid);
    } catch (e) {
      emit(UpdateProfileError(errorMessage: e.toString()));
    }
  }
}
