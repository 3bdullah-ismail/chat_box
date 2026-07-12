import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/di/injection_container.dart';
import 'package:chat_app/core/routes/app_routes_names.dart';
import 'package:chat_app/core/widgets/custom_circle_avatar.dart';
import 'package:chat_app/core/widgets/loading.dart';
import 'package:chat_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onSignOutError(BuildContext context, String errorMessage) {
    if (!context.mounted) return;
    Loading.hide(context);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: errorMessage,
      btnOkOnPress: () {},
    ).show();
  }

  void _showSignOutConfirmation(BuildContext context, AuthCubit authCubit) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Sign Out',
      desc: 'Are you sure you want to sign out?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        authCubit.signOut();
      },
      btnOkColor: ColorManager.danger,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User Name';
    final email = user?.email ?? 'No email associated';
    final photoUrl = user?.photoURL;

    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, state) =>
            state is SignOutLoading ||
            state is SignOutSuccess ||
            state is SignOutError,
        listener: (context, state) {
          if (state is SignOutLoading) {
            Loading.show(context);
          } else if (state is SignOutSuccess) {
            Loading.hide(context);
            context.go(AppRouteNames.signIn);
          } else if (state is SignOutError) {
            _onSignOutError(context, state.errorMessage);
          }
        },
        child: Builder(
          builder: (context) {
            final authCubit = context.read<AuthCubit>();
            return Scaffold(
              backgroundColor: ColorManager.surfaceBlue,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    children: [
                      // Header
                      Text(
                        'Profile',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s24.sp,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // User Info Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            photoUrl != null && photoUrl.startsWith('http')
                                ? CustomCircleAvatar(
                                    imagePath: photoUrl,
                                    radius: 50.r,
                                  )
                                : CircleAvatar(
                                    radius: 50.r,
                                    backgroundColor: ColorManager.lightBlue,
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 50.r,
                                      color: ColorManager.blue,
                                    ),
                                  ),
                            SizedBox(height: 16.h),
                            Text(
                              displayName,
                              style: getBoldStyle(
                                color: ColorManager.nearBlack,
                                fontSize: FontSize.s20.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              email,
                              style: getMediumStyle(
                                color: ColorManager.gray,
                                fontSize: FontSize.s14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                              icon: Icons.person_outline_rounded,
                              title: 'Account Settings',
                              onTap: () {},
                            ),
                            const Divider(
                              height: 1,
                              color: ColorManager.surfaceGray,
                            ),
                            _buildListTile(
                              icon: Icons.notifications_none_rounded,
                              title: 'Notifications',
                              onTap: () {},
                            ),
                            const Divider(
                              height: 1,
                              color: ColorManager.surfaceGray,
                            ),
                            _buildListTile(
                              icon: Icons.lock_outline_rounded,
                              title: 'Privacy & Security',
                              onTap: () {},
                            ),
                            const Divider(
                              height: 1,
                              color: ColorManager.surfaceGray,
                            ),
                            _buildListTile(
                              icon: Icons.logout_rounded,
                              title: 'Sign Out',
                              isDanger: true,
                              onTap: () =>
                                  _showSignOutConfirmation(context, authCubit),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final color = isDanger ? ColorManager.danger : ColorManager.nearBlack;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDanger
              ? ColorManager.danger.withValues(alpha: 0.1)
              : ColorManager.surfaceBlue,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDanger ? ColorManager.danger : ColorManager.black,
          size: 22.sp,
        ),
      ),
      title: Text(
        title,
        style: getBoldStyle(color: color, fontSize: FontSize.s16.sp),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDanger
            ? ColorManager.danger.withValues(alpha: 0.5)
            : ColorManager.gray,
        size: 24.sp,
      ),
      onTap: onTap,
    );
  }
}
