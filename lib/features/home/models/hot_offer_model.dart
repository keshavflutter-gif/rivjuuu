import 'package:equatable/equatable.dart';

class HotOfferModel extends Equatable {
  final String discount;
  final String label;
  final String category;
  final String title;
  final String condition;
  final String restaurant;
  final String distance;
  final bool isDark;

  const HotOfferModel({
    required this.discount,
    required this.label,
    required this.category,
    required this.title,
    required this.condition,
    required this.restaurant,
    required this.distance,
    this.isDark = false,
  });

  @override
  List<Object?> get props => [
        discount,
        label,
        category,
        title,
        condition,
        restaurant,
        distance,
        isDark,
      ];
}

