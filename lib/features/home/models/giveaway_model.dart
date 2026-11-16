import 'package:equatable/equatable.dart';

class GiveawayModel extends Equatable {
  final String id;
  final String restaurant;
  final String title;
  final String meta;
  final String imagePath;
  final bool isJoined;

  const GiveawayModel({
    required this.id,
    required this.restaurant,
    required this.title,
    required this.meta,
    required this.imagePath,
    this.isJoined = false,
  });

  GiveawayModel copyWith({
    String? id,
    String? restaurant,
    String? title,
    String? meta,
    String? imagePath,
    bool? isJoined,
  }) {
    return GiveawayModel(
      id: id ?? this.id,
      restaurant: restaurant ?? this.restaurant,
      title: title ?? this.title,
      meta: meta ?? this.meta,
      imagePath: imagePath ?? this.imagePath,
      isJoined: isJoined ?? this.isJoined,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurant,
        title,
        meta,
        imagePath,
        isJoined,
      ];
}

