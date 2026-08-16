import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty)
      return LocaleKeys.core_validation_emailEmpty.tr();
    if (!EmailValidator.validate(email)) {
      return LocaleKeys.core_validation_emailInvalid.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return LocaleKeys.core_validation_passwordEmpty.tr();

    final regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
    );
    if (!regex.hasMatch(value)) {
      return LocaleKeys.core_validation_passwordInvalid.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty)
      return LocaleKeys.core_validation_confirmPasswordEmpty.tr();
    if (value != password)
      return LocaleKeys.core_validation_passwordsNotMatch.tr();
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty)
      return LocaleKeys.core_validation_usernameEmpty.tr();
    if (value.length < 3)
      return LocaleKeys.core_validation_usernameInvalid.tr();
    return null;
  }
}
