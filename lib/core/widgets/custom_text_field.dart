import 'package:silora/core/constants/color_manager.dart';
import 'package:flutter/material.dart';

import '../constants/font_manager.dart';
import '../constants/styles_manager.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.text,
    this.isPass = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  final Widget? prefixIcon;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final String? text;
  final bool isPass;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPass;
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: getRegularStyle(color: ColorManager.black, fontSize: FontSize.s16),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _isObscure,
      onChanged: widget.onChanged,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: widget.text,
        hintStyle: getMediumStyle(
          color: ColorManager.lightGray,
          fontSize: FontSize.s16,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPass
            ? IconButton(
                tooltip: _isObscure ? 'Show password' : 'Hide password',
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: ColorManager.gray,
                ),
                onPressed: _toggleObscure,
              )
            : null,
      ),
    );
  }
}
