import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

class LocalizedMessages {
  LocalizedMessages._();

  static String get(BuildContext context, String? message) {
    if (message == null || message.trim().isEmpty) return '';
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));

    final trimmed = message.trim();
    // Normalize by lowercasing and stripping trailing punctuation
    final normalized = trimmed
        .replaceAll(RegExp(r'[\.\!\?]+$'), '')
        .trim()
        .toLowerCase();

    // 1. Dynamic prefixes
    if (normalized.startsWith('location pinned:')) {
      final label = trimmed.substring(16).trim();
      return l10n.locationPinned(label);
    }
    if (normalized.startsWith('uploaded:')) {
      final file = trimmed.substring(9).trim();
      return l10n.fileUploaded(file);
    }
    if (normalized.startsWith('support email:') ||
        normalized == 'support email: support@rivjuuu.com') {
      return l10n.supportEmailInfo;
    }

    // 2. Field-level validation messages
    switch (normalized) {
      case 'full name is required':
        return l10n.fullNameRequired;
      case 'please enter a valid full name':
        return l10n.fullNameInvalid;
      case 'owner or contact name is required':
        return l10n.ownerNameRequired;
      case 'email address is required':
      case 'email is required':
        return l10n.emailRequired;
      case 'please enter a valid email address':
        return l10n.emailInvalid;
      case 'password is required':
        return l10n.passwordRequired;
      case 'password must be at least 8 characters':
        return l10n.passwordTooShort;
      case 'password cannot be empty or only whitespace':
        return l10n.passwordEmptyOrWhitespace;
      case 'please confirm your password':
        return l10n.confirmPasswordRequired;
      case 'passwords do not match':
      case 'new passwords do not match':
        return l10n.passwordsDoNotMatch;

      case 'password changed successfully':
        return l10n.passwordChangedSuccess;

      case 'please fill in all password fields':
        return l10n.fillAllPasswordFields;
      case 'restaurant name is required':
        return l10n.restaurantNameRequired;
      case 'please enter a valid restaurant name':
        return l10n.restaurantNameInvalid;
      case 'please select a category':
        return l10n.categoryRequired;
      case 'address is required':
        return l10n.addressRequired;
      case 'business detail is required':
      case 'business registration or tax number is required':
        return l10n.businessDetailRequired;
      case 'please upload a supporting document':
        return l10n.documentRequired;
      case 'you must agree to the terms and conditions and privacy policy':
        return l10n.termsRequired;

      // 3. Authentication & API status messages
      case 'an account with this email already exists':
      case 'an account with this email address already exists':
      case 'email already exists':
      case 'email already in use':
      case 'user already exists':
      case 'user with this email already exists':
        return l10n.emailAlreadyExists;

      case 'restaurant application submitted successfully and is pending approval':
      case 'restaurant application submitted successfully':
      case 'application submitted successfully':
        return l10n.restaurantAppSubmittedPending;

      case 'customer account created successfully':
      case 'account created successfully':
      case 'registration successful':
        return l10n.registrationSuccess;

      case 'login successful':
        return l10n.loginSuccess;

      case 'invalid email or password':
      case 'invalid credentials':
        return l10n.invalidCredentials;

      case 'logged out successfully':
        return l10n.logoutSuccess;

      case 'session expired. please log in again':
      case 'session expired':
        return l10n.sessionExpired;

      case 'submission failed. please try again':
      case 'submission failed':
      case 'registration failed':
      case 'registration failed. please check your details':
        return l10n.submissionFailed;

      case 'invalid request. please check your details':
      case 'invalid request':
        return l10n.invalidRequest;

      case 'unauthorized. please login again':
      case 'unauthorized':
        return l10n.unauthorized;

      case 'access denied. you do not have permission':
      case 'access denied':
        return l10n.accessDenied;

      case 'requested service not found':
      case 'service not found':
      case 'not found':
        return l10n.serviceNotFound;

      case 'validation failed. please check your input':
      case 'validation failed':
        return l10n.validationFailed;

      case 'network unavailable. please check your internet connection':
      case 'network unavailable':
        return l10n.networkUnavailable;

      case 'tap again to exit':
      case 'press back again to exit':
        return l10n.tapAgainToExit;

      case 'connection timed out. please try again':
      case 'connection timed out. please check your internet connection':
      case 'connection timed out':
        return l10n.connectionTimeout;

      case 'server error occurred. please try again later':
      case 'an unexpected server error occurred':
      case 'server error':
        return l10n.serverError;

      case 'an error occurred. please try again':
      case 'an error occurred':
      case 'generic error':
        return l10n.genericError;

      case 'profile updated':
        return l10n.profileUpdated;

      default:
        // Partial fallback checks for variations
        if (normalized.contains('email already exists') ||
            normalized.contains('email already in use') ||
            normalized.contains('account with this email')) {
          return l10n.emailAlreadyExists;
        }
        if (normalized.contains('network unavailable')) {
          return l10n.networkUnavailable;
        }
        if (normalized.contains('connection timed out')) {
          return l10n.connectionTimeout;
        }
        if (normalized.contains('server error')) {
          return l10n.serverError;
        }
        return message;
    }
  }
}
