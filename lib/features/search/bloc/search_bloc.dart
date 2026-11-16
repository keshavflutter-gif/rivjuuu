import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_assets.dart';
import '../../restaurant_list/models/restaurant_item_model.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const List<RestaurantItemModel> _allRestaurants = [
    RestaurantItemModel(
      name: 'Pizzeria Forno',
      imagePath: AppAssets.pizza,
      rating: '8.8',
      cuisine: 'Pizza',
      distance: '1.5 km',
      perkText: '2 coupons',
      perkIcon: Icons.confirmation_number_outlined,
      imageOfferBadge: '-15%',
    ),
    RestaurantItemModel(
      name: 'Trattoria Nonna Rosa',
      imagePath: AppAssets.pasta,
      rating: '8.9',
      cuisine: 'Italian',
      distance: '1.2 km',
      perkText: '3 coupons',
      perkIcon: Icons.confirmation_number_outlined,
    ),
    RestaurantItemModel(
      name: 'Napoli Corner',
      imagePath: AppAssets.pizza2,
      rating: '8.2',
      cuisine: 'Pizza',
      distance: '2.0 km',
      badgeText: 'Highlighted',
    ),
    RestaurantItemModel(
      name: 'Pasta & Pizza Lab',
      imagePath: AppAssets.penne,
      rating: '7.9',
      cuisine: 'Italian',
      distance: '2.6 km',
    ),
    RestaurantItemModel(
      name: 'Dolce Vita Bistro',
      imagePath: AppAssets.tiramisu,
      rating: '8.5',
      cuisine: 'Italian',
      distance: '3.3 km',
      perkText: 'Free dessert',
      perkIcon: Icons.card_giftcard_rounded,
    ),
    RestaurantItemModel(
      name: 'Kōya Sushi & Ramen',
      imagePath: AppAssets.sushi,
      rating: '9.2',
      cuisine: 'Asian',
      distance: '2.4 km',
      perkText: '3 coupons',
      perkIcon: Icons.confirmation_number_outlined,
    ),
    RestaurantItemModel(
      name: 'Café Mókus',
      imagePath: AppAssets.coffee,
      rating: '9.0',
      cuisine: 'Café',
      distance: '400 m',
      perkText: 'Free dessert',
      perkIcon: Icons.card_giftcard_rounded,
    ),
    RestaurantItemModel(
      name: 'Bamba Burger Bar',
      imagePath: AppAssets.burger,
      rating: '8.4',
      cuisine: 'Burgers',
      distance: '650 m',
      imageOfferBadge: '1+1',
    ),
    RestaurantItemModel(
      name: 'Masala House',
      imagePath: AppAssets.indian,
      rating: '8.7',
      cuisine: 'Indian',
      distance: '1.8 km',
      perkText: '2 coupons',
    ),
  ];

  SearchBloc() : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<SearchRecentSelected>(_onRecentSelected);
    on<SearchRecentRemoved>(_onRecentRemoved);
    on<SearchAllRecentCleared>(_onAllRecentCleared);
    on<SearchCleared>(_onCleared);
  }

  List<RestaurantItemModel> _filterCatalog(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    return _allRestaurants.where((r) {
      final nameMatches = r.name.toLowerCase().contains(q);
      final cuisineMatches = r.cuisine.toLowerCase().contains(q);
      final isItalianPizza =
          (q == 'pizza' || q == 'pasta') && r.cuisine == 'Italian';
      final isBrunch = q == 'brunch' &&
          (r.cuisine == 'Café' || r.name.contains('Bistro'));
      return nameMatches || cuisineMatches || isItalianPizza || isBrunch;
    }).toList();
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final query = event.query;
    if (query.trim().isEmpty) {
      emit(state.copyWith(
        query: '',
        status: SearchViewStatus.initial,
        searchResults: const [],
      ));
      return;
    }

    final results = _filterCatalog(query);
    emit(state.copyWith(
      query: query,
      status: results.isNotEmpty
          ? SearchViewStatus.results
          : SearchViewStatus.noResults,
      searchResults: results,
    ));
  }

  void _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) {
    final trimmed = event.query.trim();
    if (trimmed.isEmpty) return;

    final currentList = List<String>.from(state.recentSearches);
    if (!currentList.contains(trimmed)) {
      currentList.insert(0, trimmed);
    }

    final results = _filterCatalog(trimmed);
    emit(state.copyWith(
      query: trimmed,
      status: results.isNotEmpty
          ? SearchViewStatus.results
          : SearchViewStatus.noResults,
      recentSearches: currentList,
      searchResults: results,
    ));
  }

  void _onRecentSelected(
      SearchRecentSelected event, Emitter<SearchState> emit) {
    final query = event.query.trim();
    final currentList = List<String>.from(state.recentSearches);
    if (!currentList.contains(query)) {
      currentList.insert(0, query);
    }

    final results = _filterCatalog(query);
    emit(state.copyWith(
      query: query,
      status: results.isNotEmpty
          ? SearchViewStatus.results
          : SearchViewStatus.noResults,
      recentSearches: currentList,
      searchResults: results,
    ));
  }

  void _onRecentRemoved(SearchRecentRemoved event, Emitter<SearchState> emit) {
    final currentList = List<String>.from(state.recentSearches);
    if (event.index >= 0 && event.index < currentList.length) {
      currentList.removeAt(event.index);
    }
    emit(state.copyWith(recentSearches: currentList));
  }

  void _onAllRecentCleared(
    SearchAllRecentCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(recentSearches: const []));
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      query: '',
      status: SearchViewStatus.initial,
      searchResults: const [],
    ));
  }
}
