import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RestaurantItemModel extends Equatable {
  final String name;
  final String imagePath;
  final String rating;
  final String cuisine;
  final String distance;
  final String? perkText;
  final IconData? perkIcon;
  final String? badgeText;
  final String? imageOfferBadge;

  const RestaurantItemModel({
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.cuisine,
    required this.distance,
    this.perkText,
    this.perkIcon,
    this.badgeText,
    this.imageOfferBadge,
  });

  @override
  List<Object?> get props => [
        name,
        imagePath,
        rating,
        cuisine,
        distance,
        perkText,
        perkIcon,
        badgeText,
        imageOfferBadge,
      ];
}
