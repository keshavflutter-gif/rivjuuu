import 'package:equatable/equatable.dart';
import '../../../../data/models/auth/login_response.dart';

abstract class LoginState extends Equatable {
  final String email;
  final String password;
  final bool obscurePassword;
  final Map<String, String>? fieldErrors;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [email, password, obscurePassword, fieldErrors];
}

class LoginInitial extends LoginState {
  const LoginInitial({
    super.email,
    super.password,
    super.obscurePassword,
    super.fieldErrors,
  });
}

class LoginLoading extends LoginState {
  const LoginLoading({
    super.email,
    super.password,
    super.obscurePassword,
    super.fieldErrors,
  });
}

class LoginSuccess extends LoginState {
  final LoginResponse response;

  const LoginSuccess({
    required this.response,
    super.email,
    super.password,
    super.obscurePassword,
  });

  @override
  List<Object?> get props => [...super.props, response];
}

class LoginFailure extends LoginState {
  final String message;
  final int? statusCode;

  const LoginFailure({
    required this.message,
    this.statusCode,
    super.email,
    super.password,
    super.obscurePassword,
    super.fieldErrors,
  });

  @override
  List<Object?> get props => [...super.props, message, statusCode];
}
