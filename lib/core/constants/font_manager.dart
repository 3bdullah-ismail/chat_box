import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontConstants {
  static String get fontFamily => GoogleFonts.inter().fontFamily ?? 'Inter';

  static String get codeFontFamily =>
      GoogleFonts.jetBrainsMono().fontFamily ?? 'JetBrains Mono';
}

class FontWeightManager {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w600;
}

class FontSize {
  static const double s11 = 11.0;
  static const double s13 = 13.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
  static const double s36 = 36.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;
}

class FontLetterSpacing {
  static const double s64Spacing = -1.92;
  static const double s32Spacing = -0.8;
  static const double s48Spacing = -1.44;
  static const double s36Spacing = -1.08;
  static const double s28Spacing = -0.84;
  static const double s22Spacing = -0.5;
  static const double s11Spacing = 0.88;
}
