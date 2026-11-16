class ApiEndpoints {
  ApiEndpoints._();

  /// Backend Base URL
  static const String baseUrl = 'http://server.keshavinfotechdemo2.com:4020';

  /// Customer Registration Endpoint
  static const String registerCustomer = '/auth/register/customer';

  /// Login Endpoint
  static const String login = '/auth/login';

  /// Logout Endpoint
  static const String logout = '/auth/logout';

  /// Helper to get full URLs
  static String get fullRegisterCustomerUrl => '$baseUrl$registerCustomer';
  static String get fullLoginUrl => '$baseUrl$login';
  static String get fullLogoutUrl => '$baseUrl$logout';

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}

