import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/font_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/constants/values_manager.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading.dart';
import '../../../auth/data/models/user_model.dart';
import '../manager/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        uid: widget.user.id,
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        address: _addressController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (_, current) =>
          current is UpdateProfileLoading ||
          current is UpdateProfileSuccess ||
          current is UpdateProfileError,
      listener: (context, state) {
        if (state is UpdateProfileLoading) {
          Loading.show(context);
        } else if (state is UpdateProfileSuccess) {
          Loading.hide(context);
          context.pop();
        } else if (state is UpdateProfileError) {
          Loading.hide(context);
          CustomAwesomeDialog.showError(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s20.sp,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: ColorManager.black,
              size: AppSize.s20.sp,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p24.w,
              vertical: AppPadding.p16.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    style: getMediumStyle(
                      color: ColorManager.nearBlack,
                      fontSize: FontSize.s14.sp,
                    ),
                  ),
                  SizedBox(height: AppSize.s8.h),
                  CustomTextField(
                    controller: _nameController,
                    text: 'Enter your name',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: ColorManager.lightGray,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.s20.h),
                  Text(
                    'Bio',
                    style: getMediumStyle(
                      color: ColorManager.nearBlack,
                      fontSize: FontSize.s14.sp,
                    ),
                  ),
                  SizedBox(height: AppSize.s8.h),
                  CustomTextField(
                    controller: _bioController,
                    text: 'Tell us about yourself',
                    prefixIcon: const Icon(
                      Icons.info_outline,
                      color: ColorManager.lightGray,
                    ),
                  ),
                  SizedBox(height: AppSize.s20.h),
                  Text(
                    'Address',
                    style: getMediumStyle(
                      color: ColorManager.nearBlack,
                      fontSize: FontSize.s14.sp,
                    ),
                  ),
                  SizedBox(height: AppSize.s8.h),
                  CustomTextField(
                    controller: _addressController,
                    text: 'E.g. Cairo, Egypt',
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: ColorManager.lightGray,
                    ),
                  ),
                  SizedBox(height: AppSize.s40.h),
                  CustomElevatedButton(label: 'Save Changes', onTap: _onSave),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
