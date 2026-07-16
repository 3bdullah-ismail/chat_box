import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/color_manager.dart';
import '../constants/font_manager.dart';
import '../constants/styles_manager.dart';

class SocialSignInButton extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback? onTap;

  const SocialSignInButton({
    super.key,
    required this.asset,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r8.r),
      child: Container(
        padding: REdgeInsets.symmetric(vertical: AppPadding.p12),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.r8.r),
          border: Border.all(color: ColorManager.lightGray),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset),
            SizedBox(width: AppSize.s8.w),
            Text(
              label,
              style: getMediumStyle(
                color: ColorManager.nearBlack,
                fontSize: FontSize.s14,
              ).copyWith(fontWeight: FontWeightManager.medium),
            ),
          ],
        ),
      ),
    );
  }
}
