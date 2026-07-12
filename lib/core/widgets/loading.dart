import 'package:flutter/material.dart';

import 'package:chat_app/core/constants/color_manager.dart';

class Loading {
  static bool _isLoading = false;

  static show(BuildContext context) {
    _isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: CircularProgressIndicator(color: ColorManager.black),
          ),
        );
      },
    );
  }

  static hide(BuildContext context) {
    if (_isLoading) {
      Navigator.pop(context);
      _isLoading = false;
    }
  }
}
