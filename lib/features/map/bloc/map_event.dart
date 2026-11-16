import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapStarted extends MapEvent {
  final String? initialSelectedName;

  const MapStarted({this.initialSelectedName});

  @override
  List<Object?> get props => [initialSelectedName];
}

class MapPinSelected extends MapEvent {
  final String pinId;

  const MapPinSelected(this.pinId);

  @override
  List<Object?> get props => [pinId];
}

class MapMyLocationTapped extends MapEvent {
  const MapMyLocationTapped();
}

