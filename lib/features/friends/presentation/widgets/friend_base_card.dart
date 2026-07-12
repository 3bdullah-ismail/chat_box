import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 6.h),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        border: Border.all(color: ColorManager.borderGray),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        color: ColorManager.nearBlack,
                        fontSize: 16.sp,
                      ).copyWith(fontWeight: FontWeightManager.bold),
                    ),
                    if (subtitle != null) ...[SizedBox(height: 2.h), subtitle!],
                  ],
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
            ],
          ),
          if (bottom != null) ...[SizedBox(height: 16.h), bottom!],
        ],
      ),
    );
  }
}
