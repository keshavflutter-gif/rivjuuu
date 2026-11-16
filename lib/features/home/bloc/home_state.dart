import 'package:equatable/equatable.dart';
import '../models/category_model.dart';
import '../models/restaurant_model.dart';
import '../models/hot_offer_model.dart';
import '../models/giveaway_model.dart';

class HomeState extends Equatable {
  final int currentNavIndex;
  final List<CategoryModel> categories;
  final List<RestaurantModel> nearbyRestaurants;
  final List<HotOfferModel> hotOffers;
  final List<RestaurantModel> recommendedRestaurants;
  final List<GiveawayModel> giveaways;

  const HomeState({
    this.currentNavIndex = 0,
    this.categories = const [],
    this.nearbyRestaurants = const [],
    this.hotOffers = const [],
    this.recommendedRestaurants = const [],
    this.giveaways = const [],
  });

  HomeState copyWith({
    int? currentNavIndex,
    List<CategoryModel>? categories,
    List<RestaurantModel>? nearbyRestaurants,
    List<HotOfferModel>? hotOffers,
    List<RestaurantModel>? recommendedRestaurants,
    List<GiveawayModel>? giveaways,
  }) {
    return HomeState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      categories: categories ?? this.categories,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      hotOffers: hotOffers ?? this.hotOffers,
      recommendedRestaurants:
          recommendedRestaurants ?? this.recommendedRestaurants,
      giveaways: giveaways ?? this.giveaways,
    );
  }

  @override
  List<Object?> get props => [
        currentNavIndex,
        categories,
        nearbyRestaurants,
        hotOffers,
        recommendedRestaurants,
        giveaways,
      ];
}

