import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_assets.dart';
import '../models/category_model.dart';
import '../models/restaurant_model.dart';
import '../models/hot_offer_model.dart';
import '../models/giveaway_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeLoaded>(_onHomeLoaded);
    on<HomeNavChanged>(_onHomeNavChanged);
    on<HomeFavoriteToggled>(_onHomeFavoriteToggled);
    on<HomeGiveawayJoinToggled>(_onHomeGiveawayJoinToggled);

    add(const HomeLoaded());
  }

  void _onHomeLoaded(HomeLoaded event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      categories: const [
        CategoryModel(title: 'Pizza', imagePath: AppAssets.pizza),
        CategoryModel(title: 'Burgers', imagePath: AppAssets.burger),
        CategoryModel(title: 'Asian', imagePath: AppAssets.sushi),
        CategoryModel(title: 'Indian', imagePath: AppAssets.indian),
        CategoryModel(title: 'Desserts', imagePath: AppAssets.dessert),
        CategoryModel(title: 'Café', imagePath: AppAssets.coffee),
      ],
      nearbyRestaurants: const [
        RestaurantModel(
          id: 'nearby-1',
          name: 'Trattoria Nonna Rosa',
          imagePath: AppAssets.pasta,
          badgeText: '20% OFF',
          rating: '8.9',
          cuisine: 'Italian',
          distance: '1.2 km',
        ),
        RestaurantModel(
          id: 'nearby-2',
          name: 'Bamba Burger Bar',
          imagePath: AppAssets.burger,
          badgeText: '1+1',
          rating: '8.4',
          cuisine: 'Burgers',
          distance: '650 m',
        ),
        RestaurantModel(
          id: 'nearby-3',
          name: 'Café Mókus',
          imagePath: AppAssets.coffee,
          rating: '9.0',
          cuisine: 'Café',
          distance: '400 m',
        ),
      ],
      hotOffers: const [
        HotOfferModel(
          discount: '20%',
          label: 'OFF',
          category: 'Discount',
          title: '20% off your bill',
          condition: 'Min. spend 5,000 HUF',
          restaurant: 'Trattoria Nonna Rosa',
          distance: '1.2 km',
        ),
        HotOfferModel(
          discount: '1+1',
          label: 'BURGER',
          category: 'Buy one, get one',
          title: 'Second burger free',
          condition: 'Classic menu only',
          restaurant: 'Bamba Burger Bar',
          distance: '650 m',
        ),
        HotOfferModel(
          discount: '',
          label: 'HAPPY HOUR',
          category: 'Happy hour',
          title: 'Two cocktails for one',
          condition: 'Mon–Fri, 16:00–18:00',
          restaurant: 'Smoke & Fire Grill',
          distance: '3.1 km',
          isDark: true,
        ),
        HotOfferModel(
          discount: '',
          label: 'FREE',
          category: 'Gift item',
          title: 'Free dessert',
          condition: 'With any main course',
          restaurant: 'Café Mókus',
          distance: '400 m',
        ),
      ],
      recommendedRestaurants: const [
        RestaurantModel(
          id: 'rec-1',
          name: 'Kōya Sushi & Ramen',
          imagePath: AppAssets.sushi,
          badgeText: 'Featured',
          isFavorite: true,
          rating: '9.2',
          cuisine: 'Asian',
          distance: '2.4 km',
          perkText: '3 coupons · Loyalty rewards',
        ),
        RestaurantModel(
          id: 'rec-2',
          name: 'Masala House',
          imagePath: AppAssets.indian,
          badgeText: 'FREE DESSERT',
          rating: '8.7',
          cuisine: 'Indian',
          distance: '1.8 km',
          perkText: '2 coupons',
        ),
      ],
      giveaways: const [
        GiveawayModel(
          id: 'gw-1',
          restaurant: 'Trattoria Nonna Rosa',
          title: 'Win dinner for two',
          meta: 'Closes 14 Oct',
          imagePath: AppAssets.table,
          isJoined: false,
        ),
        GiveawayModel(
          id: 'gw-2',
          restaurant: 'Café Mókus',
          title: 'Free dessert every day this week',
          meta: 'Closes 9 Oct',
          imagePath: AppAssets.tiramisu,
          isJoined: true,
        ),
      ],
    ));
  }

  void _onHomeNavChanged(HomeNavChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentNavIndex: event.navIndex));
  }

  void _onHomeFavoriteToggled(
    HomeFavoriteToggled event,
    Emitter<HomeState> emit,
  ) {
    final updatedNearby = state.nearbyRestaurants.map((r) {
      if (r.id == event.restaurantId) {
        return r.copyWith(isFavorite: !r.isFavorite);
      }
      return r;
    }).toList();

    final updatedRec = state.recommendedRestaurants.map((r) {
      if (r.id == event.restaurantId) {
        return r.copyWith(isFavorite: !r.isFavorite);
      }
      return r;
    }).toList();

    emit(state.copyWith(
      nearbyRestaurants: updatedNearby,
      recommendedRestaurants: updatedRec,
    ));
  }

  void _onHomeGiveawayJoinToggled(
    HomeGiveawayJoinToggled event,
    Emitter<HomeState> emit,
  ) {
    final updatedGw = state.giveaways.map((gw) {
      if (gw.id == event.giveawayId) {
        return gw.copyWith(isJoined: !gw.isJoined);
      }
      return gw;
    }).toList();

    emit(state.copyWith(giveaways: updatedGw));
  }
}

