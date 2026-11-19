import 'package:equatable/equatable.dart';
import '../../restaurant_registration/models/restaurant_registration_data.dart';

enum SplashStatus {
  initial,
  loading,
  completed,
  authenticated,
  authenticatedRestaurant,
  authenticatedRestaurantPending,
  authenticatedRestaurantRejected,
  unauthenticated,
  unauthenticatedWithLanguage,
}

class SplashState extends Equatable {
  final SplashStatus status;
  final RestaurantRegistrationData? restaurantData;

  const SplashState({
    this.status = SplashStatus.initial,
    this.restaurantData,
  });

  SplashState copyWith({
    SplashStatus? status,
    RestaurantRegistrationData? restaurantData,
  }) {
    return SplashState(
      status: status ?? this.status,
      restaurantData: restaurantData ?? this.restaurantData,
    );
  }

  @override
  List<Object?> get props => [status, restaurantData];
}
