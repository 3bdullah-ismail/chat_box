import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;
  final double iconSize;

  const CustomEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.iconSize = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: (iconSize * 1.6).w,
              height: (iconSize * 1.6).h,
              decoration: BoxDecoration(
                color: ColorManager.lightGray.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize.sp, color: ColorManager.gray),
            ),
            SizedBox(height: AppSize.s20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: AppSize.s8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.gray,
                fontSize: FontSize.s14.sp,
              ),
            ),
            if (action != null) ...[SizedBox(height: AppSize.s24.h), action!],
          ],
        ),
      ),
    );
  }
}
