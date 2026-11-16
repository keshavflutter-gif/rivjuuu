import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

class LogoutSuccess extends LogoutState {
  final String message;

  const LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutFailure extends LogoutState {
  final String message;
  final int? statusCode;
  final bool sessionCleared;

  const LogoutFailure({
    required this.message,
    this.statusCode,
    this.sessionCleared = false,
  });

  @override
  List<Object?> get props => [message, statusCode, sessionCleared];
}

