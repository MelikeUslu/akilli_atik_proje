import '../constants/app_strings.dart';

abstract final class InputValidators {
  static final RegExp _emailPattern = RegExp(
    r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return AppStrings.emptyEmail;
    }

    if (!_emailPattern.hasMatch(email)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return AppStrings.emptyPassword;
    }

    if (password.length < 6) {
      return AppStrings.shortPassword;
    }

    return null;
  }

  static bool isEmailValid(String value) {
    final email = value.trim();

    return email.isNotEmpty && _emailPattern.hasMatch(email);
  }

  static bool isPasswordValid(String value) {
    return value.length >= 6;
  }

  static bool isLoginFormValid({
    required String email,
    required String password,
  }) {
    return isEmailValid(email) && isPasswordValid(password);
  }
}
