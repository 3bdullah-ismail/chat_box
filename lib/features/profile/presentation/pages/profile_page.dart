import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/widgets/custom_avatar.dart';
import 'package:silora/core/widgets/custom_dialog.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/core/widgets/loading.dart';
import 'package:silora/core/widgets/session_expired_widget.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';
import 'package:silora/features/profile/presentation/manager/profile_cubit.dart';

import '../../../../core/utils/extension.dart';
import '../widgets/language_spacer.dart';
import '../widgets/notifications_card.dart';
import '../widgets/presonal_info_card.dart';
import '../widgets/profile_skeleton_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  void _refreshProfile() => context.read<ProfileCubit>().getUserProfile(_uid);

  void _showSignOutConfirmation(BuildContext context) {
    CustomAwesomeDialog.showWarning(
      context: context,
      title: LocaleKeys.profile_profilePage_signOutBtn.tr(),
      message: LocaleKeys.profile_profilePage_signOutConfirmationMsg.tr(),
      btnOkOnPress: () {
        context.read<AuthCubit>().signOut();
      },
      btnCancelOnPress: () {},
      btnOkColor: ColorManager.danger,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild when the locale changes
    context.locale;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignOutLoading) Loading.show(context);
        if (state is SignOutSuccess) {
          Loading.hide(context);
          context.go(AppRouteNames.signIn);
        }
        if (state is SignOutError) {
          Loading.hide(context);
          CustomAwesomeDialog.showError(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: ColorManager.blue,
            onRefresh: () async => _refreshProfile(),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading || state is ProfileInitial) {
                  return const ProfileSkeletonView();
                }
                if (state is ProfileSessionExpired) {
                  return const SessionExpiredWidget();
                }
                if (state is ProfileError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p24.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              color: ColorManager.danger,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: AppSize.s16.h),
                          ElevatedButton(
                            onPressed: _refreshProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p32.w,
                                vertical: AppPadding.p12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r12,
                                ),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.profile_profilePage_retryBtn.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is ProfileSuccess) {
                  var user = state.user;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p24.w,
                      vertical: AppPadding.p20.h,
                    ),
                    child: Column(
                      children: [
                        CustomAvatar(
                          title: user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : "?",
                          avatarSize: 96.r,
                        ),
                        SizedBox(height: AppSize.s12.h),
                        Text(
                          user.name.toCapitalized(),
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s24.sp,
                          ),
                        ),
                        SizedBox(height: AppSize.s4.h),
                        Text(
                          '@${user.username}',
                          style: getRegularStyle(
                            color: ColorManager.gray,
                            fontSize: FontSize.s14.sp,
                          ),
                        ),

                        if (user.bio != null && user.bio!.isNotEmpty) ...[
                          SizedBox(height: AppSize.s12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p16.w,
                            ),
                            child: Text(
                              user.bio!,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                color: ColorManager.nearBlack,
                                fontSize: FontSize.s14.sp,
                              ).copyWith(height: 1.3),
                            ),
                          ),
                        ],
                        SizedBox(height: AppSize.s24.h),

                        PersonalInfoCard(
                          user: user,
                          onEditReturn: _refreshProfile,
                        ),
                        SizedBox(height: AppSize.s16.h),
                        NotificationsCard(),
                        SizedBox(height: AppSize.s16.h),
                        const LanguageSpacer(),
                        SizedBox(height: AppSize.s32.h),

                        CustomElevatedButton(
                          label: LocaleKeys.profile_profilePage_signOutBtn.tr(),
                          onTap: () => _showSignOutConfirmation(context),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
