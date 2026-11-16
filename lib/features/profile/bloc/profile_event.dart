import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded();
}

class ProfileNameUpdated extends ProfileEvent {
  final String newName;

  const ProfileNameUpdated(this.newName);

  @override
  List<Object?> get props => [newName];
}

