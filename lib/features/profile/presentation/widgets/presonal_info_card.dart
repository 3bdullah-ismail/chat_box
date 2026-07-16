import 'package:silora/core/constants/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/constants/values_manager.dart';
import '../../../../core/routes/app_routes_names.dart';

class PersonalInfoCard extends StatelessWidget {
  final dynamic user;

  const PersonalInfoCard({super.key, required this.user});

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
                'Personal Info',
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s16.sp,
                ),
              ),
              IconButton(
                onPressed: () =>
                    context.push(AppRouteNames.editProfile, extra: user),
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
            text: user.address ?? 'Not provided',
          ),
          SizedBox(height: AppSize.s12.h),
          _InfoRow(icon: Icons.link_rounded, text: user.email, isLink: true),
          SizedBox(height: AppSize.s12.h),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            text: user.joinedAt != null
                ? 'Joined ${DateFormat.yMMMM().format(user.joinedAt!)}'
                : 'Joined recently',
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
