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
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String bio,
    required String address,
  }) async {
    emit(UpdateProfileLoading());
    try {
      await profileRepo.updateProfile(
        uid: uid,
        data: {'name': name, 'bio': bio, 'address': address},
      );
      emit(UpdateProfileSuccess());
      await getUserProfile(uid);
    } catch (e) {
      emit(UpdateProfileError(errorMessage: e.toString()));
    }
  }
}
