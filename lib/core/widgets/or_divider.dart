import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_manager.dart';
import '../constants/font_manager.dart';
import '../constants/styles_manager.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: ColorManager.gray, thickness: AppSize.s1),
        ),
        Padding(
          padding: REdgeInsets.symmetric(horizontal: AppPadding.p8),
          child: Text(
            text,
            style: getBoldStyle(
              color: ColorManager.gray,
              fontSize: FontSize.s11,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: ColorManager.gray, thickness: AppSize.s1),
        ),
      ],
    );
  }
}
