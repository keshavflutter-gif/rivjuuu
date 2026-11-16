import 'package:equatable/equatable.dart';
import '../../restaurant_list/models/restaurant_item_model.dart';

enum SearchViewStatus {
  initial, // Showing Recent searches, Popular categories, Suggested
  results, // Showing matching restaurants
  noResults, // Showing empty state with "Browse categories"
}

class SearchState extends Equatable {
  final String query;
  final SearchViewStatus status;
  final List<String> recentSearches;
  final List<String> popularCategories;
  final List<RestaurantItemModel> searchResults;

  const SearchState({
    this.query = '',
    this.status = SearchViewStatus.initial,
    this.recentSearches = const [
      'Pizza',
      'Trattoria Nonna Rosa',
      'Brunch',
    ],
    this.popularCategories = const [
      'Pizza',
      'Burgers',
      'Asian',
      'Brunch',
      'Desserts',
      'Coffee',
    ],
    this.searchResults = const [],
  });

  SearchState copyWith({
    String? query,
    SearchViewStatus? status,
    List<String>? recentSearches,
    List<String>? popularCategories,
    List<RestaurantItemModel>? searchResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      recentSearches: recentSearches ?? this.recentSearches,
      popularCategories: popularCategories ?? this.popularCategories,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object?> get props => [
        query,
        status,
        recentSearches,
        popularCategories,
        searchResults,
      ];
}
