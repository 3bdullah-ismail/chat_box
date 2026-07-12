import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: FontConstants.fontFamily,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
  );
}

TextStyle getRegularStyle({
  double fontSize = FontSize.s11,
  required Color color,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    color,
    letterSpacing: letterSpacing,
  );
}

TextStyle getMediumStyle({
  double fontSize = FontSize.s11,
  required Color color,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.medium,
    color,
    letterSpacing: letterSpacing,
  );
}

// bold style

TextStyle getBoldStyle({
  double fontSize = FontSize.s11,
  required Color color,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    color,
    letterSpacing: letterSpacing,
  );
}

TextStyle getTextWithLine() {
  return const TextStyle(
    color: ColorManager.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    decorationColor: ColorManager.black,
  );
}
