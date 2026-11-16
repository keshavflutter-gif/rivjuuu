import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

class LoginSubmitted extends LoginEvent {
  final String? email;
  final String? password;

  const LoginSubmitted({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginSessionChecked extends LoginEvent {
  const LoginSessionChecked();
}

class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}
