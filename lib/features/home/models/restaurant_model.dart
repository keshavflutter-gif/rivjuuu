import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final String rating;
  final String cuisine;
  final String distance;
  final String? badgeText;
  final bool isFavorite;
  final String? perkText;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.cuisine,
    required this.distance,
    this.badgeText,
    this.isFavorite = false,
    this.perkText,
  });

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? rating,
    String? cuisine,
    String? distance,
    String? badgeText,
    bool? isFavorite,
    String? perkText,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      cuisine: cuisine ?? this.cuisine,
      distance: distance ?? this.distance,
      badgeText: badgeText ?? this.badgeText,
      isFavorite: isFavorite ?? this.isFavorite,
      perkText: perkText ?? this.perkText,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imagePath,
        rating,
        cuisine,
        distance,
        badgeText,
        isFavorite,
        perkText,
      ];
}

