import 'package:equatable/equatable.dart';

abstract class RestaurantDetailEvent extends Equatable {
  const RestaurantDetailEvent();

  @override
  List<Object?> get props => [];
}

class RestaurantDetailLoaded extends RestaurantDetailEvent {
  final String restaurantName;
  final int initialTabIndex;

  const RestaurantDetailLoaded({
    this.restaurantName = 'Trattoria Nonna Rosa',
    this.initialTabIndex = 0,
  });

  @override
  List<Object?> get props => [restaurantName, initialTabIndex];
}

class RestaurantDetailTabChanged extends RestaurantDetailEvent {
  final int tabIndex;

  const RestaurantDetailTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class RestaurantDetailFavoriteToggled extends RestaurantDetailEvent {
  const RestaurantDetailFavoriteToggled();
}

class RestaurantDetailMenuSegmentChanged extends RestaurantDetailEvent {
  final int segmentIndex; // 0: Menu items, 1: Menu photos

  const RestaurantDetailMenuSegmentChanged(this.segmentIndex);

  @override
  List<Object?> get props => [segmentIndex];
}

class RestaurantDetailReviewFilterChanged extends RestaurantDetailEvent {
  final int filterIndex; // 0: Recent, 1: Highest rated

  const RestaurantDetailReviewFilterChanged(this.filterIndex);

  @override
  List<Object?> get props => [filterIndex];
}

class RestaurantDetailGiveawayJoined extends RestaurantDetailEvent {
  final String giveawayId;

  const RestaurantDetailGiveawayJoined(this.giveawayId);

  @override
  List<Object?> get props => [giveawayId];
}

