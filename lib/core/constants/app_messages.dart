class AppMessages {
  AppMessages._();

  // Field validation messages
  static const String fullNameRequired = 'Full name is required';
  static const String fullNameInvalid = 'Please enter a valid full name';

  static const String emailRequired = 'Email address is required';
  static const String emailInvalid = 'Please enter a valid email address';

  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordEmptyOrWhitespace = 'Password cannot be empty or only whitespace';

  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  static const String termsRequired = 'You must agree to the Terms and Conditions and Privacy Policy';

  // Network and server messages
  static const String networkUnavailable = 'Network unavailable. Please check your internet connection.';
  static const String connectionTimeout = 'Connection timed out. Please try again.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String genericError = 'An error occurred. Please try again.';
  static const String registrationSuccess = 'Customer account created successfully';
  static const String loginSuccess = 'Login successful';
  static const String invalidCredentials = 'Invalid email or password';
  static const String unsupportedRole = 'Access restricted: this portal is for customer accounts only.';
  static const String unexpectedError = 'An unexpected response was received from the server.';
  static const String sessionExpired = 'Session expired. Please log in again.';
  static const String logoutSuccess = 'Logged out successfully';
}

