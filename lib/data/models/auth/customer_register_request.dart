import 'package:equatable/equatable.dart';

class CustomerRegisterRequest extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  const CustomerRegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'password': password, // sent exactly as entered without trimming or modification
      'confirmPassword': confirmPassword, // sent exactly as entered
      'acceptTerms': acceptTerms, // boolean, not string
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        acceptTerms,
      ];
}

