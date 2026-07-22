import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/constants/values_manager.dart';
import '../../../../core/routes/app_routes_names.dart';

class PersonalInfoCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onEditReturn;

  const PersonalInfoCard({super.key, required this.user, required this.onEditReturn});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.profile_personalInfo_title.tr(),
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s16.sp,
                ),
              ),
              IconButton(
                onPressed: () async {
                    await context.push(AppRouteNames.editProfile, extra: user);
                    onEditReturn();
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.edit_outlined,
                  color: ColorManager.blue,
                  size: AppSize.s22.sp,
                ),
              ),
            ],
          ),
          Divider(color: ColorManager.borderGray, height: AppSize.s20.h),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: (user.address != null && user.address.isNotEmpty)
                ? user.address
                : LocaleKeys.profile_personalInfo_addressNotProvided.tr(),
          ),
          SizedBox(height: AppSize.s12.h),
          _InfoRow(
            icon: Icons.link_rounded, 
            text: (user.email != null && user.email.isNotEmpty) 
                ? user.email 
                : LocaleKeys.profile_personalInfo_addressNotProvided.tr(), 
            isLink: (user.email != null && user.email.isNotEmpty)
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
