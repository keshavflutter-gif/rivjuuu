import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_assets.dart';
import '../models/restaurant_item_model.dart';
import 'restaurant_list_event.dart';
import 'restaurant_list_state.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  RestaurantListBloc({String title = 'Italian restaurants'})
      : super(RestaurantListState(title: title)) {
    on<RestaurantListLoaded>(_onLoaded);
    on<RestaurantListFilterSelected>(_onFilterSelected);
    on<RestaurantListNavChanged>(_onNavChanged);

    add(RestaurantListLoaded(title: title));
  }

  void _onLoaded(
    RestaurantListLoaded event,
    Emitter<RestaurantListState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
      totalCount: 18,
      restaurants: const [
        RestaurantItemModel(
          name: 'Trattoria Nonna Rosa',
          imagePath: AppAssets.pasta,
          rating: '8.9',
          cuisine: 'Italian',
          distance: '1.2 km',
          perkText: '3 coupons available',
          perkIcon: LucideIcons.ticket,
        ),
        RestaurantItemModel(
          name: 'Pizzeria Forno',
          imagePath: AppAssets.pizza,
          rating: '8.8',
          cuisine: 'Pizza',
          distance: '1.5 km',
          badgeText: 'Highlighted',
        ),
        RestaurantItemModel(
          name: 'Pasta & Pizza Lab',
          imagePath: AppAssets.penne,
          rating: '7.9',
          cuisine: 'Italian',
          distance: '2.6 km',
          perkText: '1 coupon available',
          perkIcon: LucideIcons.ticket,
        ),
        RestaurantItemModel(
          name: 'Napoli Corner',
          imagePath: AppAssets.pizza2,
          rating: '8.2',
          cuisine: 'Pizza',
          distance: '2.0 km',
        ),
        RestaurantItemModel(
          name: 'Dolce Vita Bistro',
          imagePath: AppAssets.tiramisu,
          rating: '8.5',
          cuisine: 'Italian',
          distance: '3.3 km',
          perkText: 'Free dessert',
          perkIcon: LucideIcons.gift,
        ),
      ],
    ));
  }

  void _onFilterSelected(
    RestaurantListFilterSelected event,
    Emitter<RestaurantListState> emit,
  ) {
    emit(state.copyWith(selectedFilterIndex: event.filterIndex));
  }

  void _onNavChanged(
    RestaurantListNavChanged event,
    Emitter<RestaurantListState> emit,
  ) {
    emit(state.copyWith(currentNavIndex: event.navIndex));
  }
}

