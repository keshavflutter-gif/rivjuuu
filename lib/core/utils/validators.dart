import '../constants/app_messages.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  /// Validates customer Full Name:
  /// - Required
  /// - Cannot be empty
  /// - Checks trimmed value
  /// - Must contain at least 2 characters of meaningful name
  static String? validateFullName(String? value) {
    if (value == null) {
      return AppMessages.fullNameRequired;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return AppMessages.fullNameRequired;
    }
    if (trimmed.length < 2) {
      return AppMessages.fullNameInvalid;
    }
    return null;
  }

  /// Validates customer Email address:
  /// - Required
  /// - Valid email pattern
  /// - Trimmed check
  static String? validateEmail(String? value) {
    if (value == null) {
      return AppMessages.emailRequired;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return AppMessages.emailRequired;
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return AppMessages.emailInvalid;
    }
    return null;
  }

  /// Validates customer Password:
  /// - Required
  /// - Minimum 8 characters
  /// - IMPORTANT: Do NOT trim the password itself.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppMessages.passwordRequired;
    }
    if (value.length < 8) {
      return AppMessages.passwordTooShort;
    }
    return null;
  }

  /// Validates Login Password:
  /// - Required (cannot be empty)
  /// - Must not contain only whitespace
  /// - IMPORTANT: Do NOT modify actual password using trim before sending to API.
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppMessages.passwordRequired;
    }
    if (value.trim().isEmpty) {
      return AppMessages.passwordEmptyOrWhitespace;
    }
    return null;
  }

  /// Validates customer Confirm Password:
  /// - Required
  /// - Must match password exactly
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppMessages.confirmPasswordRequired;
    }
    if (confirmPassword != password) {
      return AppMessages.passwordsDoNotMatch;
    }
    return null;
  }

  /// Validates Terms and Conditions:
  /// - Must be boolean true
  static String? validateTerms(bool? acceptTerms) {
    if (acceptTerms != true) {
      return AppMessages.termsRequired;
    }
    return null;
  }
}
