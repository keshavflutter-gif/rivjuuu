import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category_tile_model.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  static const List<CategoryTileModel> defaultCategories = [
    CategoryTileModel(
      id: 'pizza',
      title: 'Pizza',
      placeCount: 42,
      imagePath: 'assets/pizza.jpg',
    ),
    CategoryTileModel(
      id: 'burgers',
      title: 'Burgers',
      placeCount: 31,
      imagePath: 'assets/burger.jpg',
    ),
    CategoryTileModel(
      id: 'italian',
      title: 'Italian',
      placeCount: 18,
      imagePath: 'assets/pasta.jpg',
    ),
    CategoryTileModel(
      id: 'asian',
      title: 'Asian',
      placeCount: 27,
      imagePath: 'assets/ramen.jpg',
    ),
    CategoryTileModel(
      id: 'hungarian',
      title: 'Hungarian',
      placeCount: 24,
      imagePath: 'assets/ribs.jpg',
    ),
    CategoryTileModel(
      id: 'indian',
      title: 'Indian',
      placeCount: 12,
      imagePath: 'assets/indian.jpg',
    ),
    CategoryTileModel(
      id: 'desserts',
      title: 'Desserts',
      placeCount: 20,
      imagePath: 'assets/dessert.jpg',
    ),
    CategoryTileModel(
      id: 'coffee',
      title: 'Coffee',
      placeCount: 35,
      imagePath: 'assets/coffee.jpg',
    ),
    CategoryTileModel(
      id: 'healthy',
      title: 'Healthy',
      placeCount: 16,
      imagePath: 'assets/healthy.jpg',
    ),
    CategoryTileModel(
      id: 'grill',
      title: 'Grill',
      placeCount: 14,
      imagePath: 'assets/grill.jpg',
    ),
  ];

  CategoriesBloc() : super(const CategoriesState(categories: defaultCategories)) {
    on<CategoriesStarted>(_onStarted);
  }

  void _onStarted(CategoriesStarted event, Emitter<CategoriesState> emit) {
    emit(state.copyWith(categories: defaultCategories));
  }
}

