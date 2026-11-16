import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_detail_event.dart';
import 'restaurant_detail_state.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantDetailBloc
    extends Bloc<RestaurantDetailEvent, RestaurantDetailState> {
  RestaurantDetailBloc({int initialTabIndex = 0})
      : super(RestaurantDetailState.initial(initialTabIndex: initialTabIndex)) {
    on<RestaurantDetailLoaded>(_onLoaded);
    on<RestaurantDetailTabChanged>(_onTabChanged);
    on<RestaurantDetailFavoriteToggled>(_onFavoriteToggled);
    on<RestaurantDetailMenuSegmentChanged>(_onMenuSegmentChanged);
    on<RestaurantDetailReviewFilterChanged>(_onReviewFilterChanged);
    on<RestaurantDetailGiveawayJoined>(_onGiveawayJoined);
  }

  void _onLoaded(
    RestaurantDetailLoaded event,
    Emitter<RestaurantDetailState> emit,
  ) {
    emit(state.copyWith(
      selectedTabIndex: event.initialTabIndex,
    ));
  }

  void _onTabChanged(
    RestaurantDetailTabChanged event,
    Emitter<RestaurantDetailState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }

  void _onFavoriteToggled(
    RestaurantDetailFavoriteToggled event,
    Emitter<RestaurantDetailState> emit,
  ) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onMenuSegmentChanged(
    RestaurantDetailMenuSegmentChanged event,
    Emitter<RestaurantDetailState> emit,
  ) {
    emit(state.copyWith(menuSegmentIndex: event.segmentIndex));
  }

  void _onReviewFilterChanged(
    RestaurantDetailReviewFilterChanged event,
    Emitter<RestaurantDetailState> emit,
  ) {
    List<ReviewModel> sortedReviews = List.from(state.reviews);
    if (event.filterIndex == 1) {
      // Highest rated
      sortedReviews.sort((a, b) => b.score.compareTo(a.score));
    } else {
      // Recent (original order)
      sortedReviews = RestaurantDetailState.initial().reviews;
    }
    emit(state.copyWith(
      reviewFilterIndex: event.filterIndex,
      reviews: sortedReviews,
    ));
  }

  void _onGiveawayJoined(
    RestaurantDetailGiveawayJoined event,
    Emitter<RestaurantDetailState> emit,
  ) {
    final updatedGiveaways = state.giveaways.map((g) {
      if (g.id == event.giveawayId) {
        return g.copyWith(
          status: GiveawayStatus.joined,
          actionText: null,
        );
      }
      return g;
    }).toList();

    emit(state.copyWith(giveaways: updatedGiveaways));
  }
}

