import 'package:equatable/equatable.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRewardsEvent extends RewardsEvent {
  const LoadRewardsEvent();
}

class SelectRestaurantLoyaltyEvent extends RewardsEvent {
  final String restaurantId;

  const SelectRestaurantLoyaltyEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

class RedeemRewardEvent extends RewardsEvent {
  final String restaurantId;
  final String rewardId;

  const RedeemRewardEvent({
    required this.restaurantId,
    required this.rewardId,
  });

  @override
  List<Object?> get props => [restaurantId, rewardId];
}

