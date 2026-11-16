import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String title;
  final String imagePath;

  const CategoryModel({
    required this.title,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, imagePath];
}

