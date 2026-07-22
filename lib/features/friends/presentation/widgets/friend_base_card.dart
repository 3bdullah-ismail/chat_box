import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/extension.dart';

class FriendBaseCard extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final String? imageUrl;
  final String? fallbackLetter;
  final Widget? avatarChild;
  final double avatarSize;
  final Widget? trailing;
  final Widget? bottom;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;

  const FriendBaseCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.fallbackLetter,
    this.avatarChild,
    this.avatarSize = 48.0,
    this.trailing,
    this.bottom,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(vertical: AppSize.s6.h),
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: AppSize.s16.w,
              vertical: AppSize.s12.h,
            ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.r12),
          border: Border.all(color: ColorManager.borderGray),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withValues(alpha: 0.04),
              blurRadius: AppSize.s12,
              offset: const Offset(0, AppSize.s4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomAvatar(
                  title: title,
                  imageUrl: imageUrl,
                  fallbackLetter: fallbackLetter,
                  avatarChild: avatarChild,
                  avatarSize: avatarSize,
                ),
                SizedBox(width: AppSize.s12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title.toCapitalized(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          color: ColorManager.nearBlack,
                          fontSize: FontSize.s16.sp,
                        ).copyWith(fontWeight: FontWeightManager.bold),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSize.s2.h),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: AppSize.s8.w),
                  trailing!,
                ],
              ],
            ),
            if (bottom != null) ...[SizedBox(height: AppSize.s16.h), bottom!],
          ],
        ),
      ),
    );
  }
}
