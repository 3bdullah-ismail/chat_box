import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';

import 'package:silora/core/constants/color_manager.dart';

class CustomTextBtn extends StatelessWidget {
  const CustomTextBtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = FontSize.s16,
    this.fontWeight = FontWeightManager.semiBold,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? ColorManager.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p8,
          vertical: AppPadding.p4,
        ),
      ),
      child: Text(
        text,
        style: getTextStyle(fontSize, fontWeight, color ?? ColorManager.white),
      ),
    );
  }
}
