import 'package:equatable/equatable.dart';

class CategoryTileModel extends Equatable {
  final String id;
  final String title;
  final int placeCount;
  final String imagePath;

  const CategoryTileModel({
    required this.id,
    required this.title,
    required this.placeCount,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, title, placeCount, imagePath];
}

