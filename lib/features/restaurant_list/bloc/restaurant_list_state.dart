import 'package:equatable/equatable.dart';
import '../models/restaurant_item_model.dart';

class RestaurantListState extends Equatable {
  final String title;
  final int selectedFilterIndex;
  final int currentNavIndex;
  final List<RestaurantItemModel> restaurants;
  final int totalCount;

  const RestaurantListState({
    this.title = 'Italian restaurants',
    this.selectedFilterIndex = 1,
    this.currentNavIndex = 1,
    this.restaurants = const [],
    this.totalCount = 18,
  });

  RestaurantListState copyWith({
    String? title,
    int? selectedFilterIndex,
    int? currentNavIndex,
    List<RestaurantItemModel>? restaurants,
    int? totalCount,
  }) {
    return RestaurantListState(
      title: title ?? this.title,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      restaurants: restaurants ?? this.restaurants,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [
        title,
        selectedFilterIndex,
        currentNavIndex,
        restaurants,
        totalCount,
      ];
}

