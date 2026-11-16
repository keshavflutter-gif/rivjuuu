import 'package:equatable/equatable.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class LogoutRequested extends LogoutEvent {
  final String deviceToken;

  const LogoutRequested({this.deviceToken = ''});

  @override
  List<Object?> get props => [deviceToken];
}

