import 'package:equatable/equatable.dart';

abstract class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();

  @override
  List<Object?> get props => [];
}

class RestaurantListLoaded extends RestaurantListEvent {
  final String title;

  const RestaurantListLoaded({this.title = 'Italian restaurants'});

  @override
  List<Object?> get props => [title];
}

class RestaurantListFilterSelected extends RestaurantListEvent {
  final int filterIndex;

  const RestaurantListFilterSelected(this.filterIndex);

  @override
  List<Object?> get props => [filterIndex];
}

class RestaurantListNavChanged extends RestaurantListEvent {
  final int navIndex;

  const RestaurantListNavChanged(this.navIndex);

  @override
  List<Object?> get props => [navIndex];
}

