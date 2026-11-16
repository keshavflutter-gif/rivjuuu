import 'package:equatable/equatable.dart';

class MapPinModel extends Equatable {
  final String id;
  final String name;
  final String rating;
  final String cuisine;
  final String distance;
  final String openStatus;
  final int couponCount;
  final String imagePath;
  final double dx;
  final double dy;

  const MapPinModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.cuisine,
    required this.distance,
    required this.openStatus,
    required this.couponCount,
    required this.imagePath,
    required this.dx,
    required this.dy,
  });

  MapPinModel copyWith({
    String? id,
    String? name,
    String? rating,
    String? cuisine,
    String? distance,
    String? openStatus,
    int? couponCount,
    String? imagePath,
    double? dx,
    double? dy,
  }) {
    return MapPinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      cuisine: cuisine ?? this.cuisine,
      distance: distance ?? this.distance,
      openStatus: openStatus ?? this.openStatus,
      couponCount: couponCount ?? this.couponCount,
      imagePath: imagePath ?? this.imagePath,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        cuisine,
        distance,
        openStatus,
        couponCount,
        imagePath,
        dx,
        dy,
      ];
}

