import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email cannot be empty.';
    if (!EmailValidator.validate(email)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter password';

    final regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
    );
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 chars\n and contain upper, lower,\n number & special char';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username cannot be empty.';
    if (value.length < 3) return 'Username must be at least 3 characters.';
    return null;
  }
}
