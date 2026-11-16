import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeEvent {
  const HomeLoaded();
}

class HomeNavChanged extends HomeEvent {
  final int navIndex;

  const HomeNavChanged(this.navIndex);

  @override
  List<Object?> get props => [navIndex];
}

class HomeFavoriteToggled extends HomeEvent {
  final String restaurantId;

  const HomeFavoriteToggled(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

class HomeGiveawayJoinToggled extends HomeEvent {
  final String giveawayId;

  const HomeGiveawayJoinToggled(this.giveawayId);

  @override
  List<Object?> get props => [giveawayId];
}

