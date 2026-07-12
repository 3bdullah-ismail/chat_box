import 'package:chat_app/core/constants/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/font_manager.dart';
import '../constants/styles_manager.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: ColorManager.white,
    fontFamily: FontConstants.fontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ColorManager.black,
      onPrimary: ColorManager.white,
      secondary: ColorManager.black,
      onSecondary: ColorManager.white,
      error: ColorManager.error,
      onError: ColorManager.white,
      surface: ColorManager.white,
      onSurface: ColorManager.nearBlack,
      outline: ColorManager.borderGray,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorManager.white,
      foregroundColor: ColorManager.nearBlack,
      elevation: 0,
      iconTheme: const IconThemeData(color: ColorManager.nearBlack),
      titleTextStyle: getBoldStyle(
        color: ColorManager.nearBlack,
        fontSize: FontSize.s20,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.white,
      selectedItemColor: ColorManager.black,
      unselectedItemColor: ColorManager.gray,
      selectedIconTheme: const IconThemeData(color: ColorManager.black),
      unselectedIconTheme: const IconThemeData(color: ColorManager.gray),
      selectedLabelStyle: getBoldStyle(
        color: ColorManager.nearBlack,
        fontSize: 12,
      ),
      unselectedLabelStyle: getBoldStyle(
        color: ColorManager.nearBlack,
        fontSize: 12,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: ColorManager.surfaceGray,
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      color: ColorManager.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ColorManager.borderGray),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ColorManager.white,
      titleTextStyle: getBoldStyle(
        color: ColorManager.nearBlack,
        fontSize: FontSize.s20,
      ),
      contentTextStyle: getRegularStyle(
        color: ColorManager.gray,
        fontSize: FontSize.s16,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorManager.black,
      contentTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s14,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorManager.black,
      foregroundColor: ColorManager.white,
    ),
    iconTheme: const IconThemeData(color: ColorManager.nearBlack),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorManager.black,
      selectionColor: ColorManager.lightBlue,
      selectionHandleColor: ColorManager.black,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorManager.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: getBoldStyle(color: ColorManager.gray, fontSize: FontSize.s16),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: ColorManager.borderGray,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: ColorManager.borderGray,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorManager.nearBlack, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorManager.error, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorManager.error, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
  );
}
