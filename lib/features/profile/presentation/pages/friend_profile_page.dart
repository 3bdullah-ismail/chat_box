import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/widgets/custom_avatar.dart';

import '../../../../core/utils/extension.dart';
import '../../../auth/data/models/user_model.dart';

class FriendProfilePage extends StatelessWidget {
  final UserModel user;

  const FriendProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                title: user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
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
              if (user.username.isNotEmpty) ...[
                SizedBox(height: AppSize.s4.h),
                Text(
                  '@${user.username}',
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: FontSize.s14.sp,
                  ),
                ),
              ],
              if (user.bio != null && user.bio!.isNotEmpty) ...[
                SizedBox(height: AppSize.s12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
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
              FriendInfoCard(user: user),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendInfoCard extends StatelessWidget {
  final UserModel user;

  const FriendInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p16.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: ColorManager.borderGray, width: AppSize.s1.w),
        boxShadow: [
          BoxShadow(
            color: ColorManager.gray.withValues(alpha: .04),
            blurRadius: AppSize.s10.r,
            offset: const Offset(0, AppSize.s2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.profile_personalInfo_title.tr(),
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16.sp,
            ),
          ),
          Divider(color: ColorManager.borderGray, height: AppSize.s20.h),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: (user.address != null && user.address!.isNotEmpty)
                ? user.address!
                : LocaleKeys.profile_personalInfo_addressNotProvided.tr(),
          ),
          SizedBox(height: AppSize.s12.h),
          _InfoRow(
            icon: Icons.link_rounded,
            text: user.email.isNotEmpty
                ? user.email
                : LocaleKeys.profile_personalInfo_addressNotProvided.tr(),
            isLink: user.email.isNotEmpty,
          ),
          SizedBox(height: AppSize.s12.h),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            text: user.joinedAt != null
                ? '${LocaleKeys.profile_personalInfo_joinedPrefix.tr()}${DateFormat.yMMMM().format(user.joinedAt!)}'
                : LocaleKeys.profile_personalInfo_joinedRecently.tr(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLink;

  const _InfoRow({required this.icon, required this.text, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorManager.gray, size: AppSize.s18.sp),
        SizedBox(width: AppSize.s12.w),
        Expanded(
          child: Text(
            text,
            style: getRegularStyle(
              color: isLink ? ColorManager.blue : ColorManager.nearBlack,
              fontSize: FontSize.s14.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
