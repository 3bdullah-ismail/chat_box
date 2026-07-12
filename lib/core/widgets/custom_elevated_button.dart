import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String label;
  final Color? backgroundColor;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const CustomElevatedButton({
    super.key,
    this.prefixIcon,
    this.textStyle,
    this.backgroundColor,
    this.suffixIcon,
    this.width,
    this.height,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorManager.black,
          foregroundColor: ColorManager.white,

          padding: height != null
              ? EdgeInsets.symmetric(horizontal: 12.w)
              : EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: (width == null || height == null)
              ? MainAxisSize.max
              : MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],
            Text(
              label,
              style:
                  textStyle ??
                  getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s16,
                  ),
            ),
            if (suffixIcon != null) ...[SizedBox(width: 8.w), suffixIcon!],
          ],
        ),
      ),
    );
  }
}
