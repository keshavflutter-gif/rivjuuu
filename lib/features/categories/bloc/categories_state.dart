import 'package:equatable/equatable.dart';
import '../models/category_tile_model.dart';

class CategoriesState extends Equatable {
  final List<CategoryTileModel> categories;
  final bool isLoading;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
  });

  CategoriesState copyWith({
    List<CategoryTileModel>? categories,
    bool? isLoading,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading];
}

