import 'package:equatable/equatable.dart';

/// Strongly typed request model for the Customer/User Login API.
///
/// Sends:
/// ```json
/// {
///   "email": "user@example.com",
///   "password": "password"
/// }
/// ```
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  /// Converts request model to JSON.
  ///
  /// - Email is trimmed.
  /// - Password is sent EXACTLY as entered without trimming or alteration.
  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'password': password,
    };
  }

  @override
  List<Object?> get props => [email, password];
}

