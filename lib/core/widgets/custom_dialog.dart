import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

class CustomAwesomeDialog {
  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? btnOkOnPress,
    Color? btnOkColor,
  }) {
    _show(
      context: context,
      dialogType: DialogType.error,
      title: title ?? LocaleKeys.core_dialog_error.tr(),
      desc: message,
      btnOkOnPress: btnOkOnPress ?? () {},
      btnOkColor: btnOkColor,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? btnOkOnPress,
    Color? btnOkColor,
  }) {
    _show(
      context: context,
      dialogType: DialogType.success,
      title: title ?? LocaleKeys.core_dialog_success.tr(),
      desc: message,
      btnOkOnPress: btnOkOnPress ?? () {},
      btnOkColor: btnOkColor,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? btnOkOnPress,
    VoidCallback? btnCancelOnPress,
    Color? btnOkColor,
  }) {
    _show(
      context: context,
      dialogType: DialogType.warning,
      title: title ?? LocaleKeys.core_dialog_warning.tr(),
      desc: message,
      btnOkOnPress: btnOkOnPress ?? () {},
      btnCancelOnPress: btnCancelOnPress,
      btnOkColor: btnOkColor,
    );
  }

  static void _show({
    required BuildContext context,
    required DialogType dialogType,
    required String title,
    required String desc,
    required VoidCallback btnOkOnPress,
    VoidCallback? btnCancelOnPress,
    Color? btnOkColor,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: btnCancelOnPress,
      btnOkColor: btnOkColor,
    ).show();
  }
}
