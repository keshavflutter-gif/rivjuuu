import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/map_pin_model.dart';

class MapState extends Equatable {
  final List<MapPinModel> pins;
  final String selectedPinId;
  final Offset userLocation;

  const MapState({
    this.pins = const [],
    this.selectedPinId = 'nr',
    this.userLocation = const Offset(132, 470),
  });

  MapPinModel get selectedPin {
    return pins.firstWhere(
      (pin) => pin.id == selectedPinId,
      orElse: () => pins.isNotEmpty
          ? pins.first
          : const MapPinModel(
              id: 'nr',
              name: 'Trattoria Nonna Rosa',
              rating: '8.9',
              cuisine: 'Italian',
              distance: '1.2 km',
              openStatus: 'until 23:00',
              couponCount: 3,
              imagePath: 'assets/pasta.jpg',
              dx: 210,
              dy: 448,
            ),
    );
  }

  MapState copyWith({
    List<MapPinModel>? pins,
    String? selectedPinId,
    Offset? userLocation,
  }) {
    return MapState(
      pins: pins ?? this.pins,
      selectedPinId: selectedPinId ?? this.selectedPinId,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  @override
  List<Object?> get props => [pins, selectedPinId, userLocation];
}

