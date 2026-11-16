import 'package:equatable/equatable.dart';
import '../models/rewards_models.dart';

class RewardsState extends Equatable {
  final List<RestaurantLoyaltyCardModel> availableRewards;
  final List<RestaurantLoyaltyCardModel> collectingRewards;
  final LoyaltyDetailModel? activeLoyaltyDetail;
  final RedeemedRewardSummary? lastRedemption;

  const RewardsState({
    required this.availableRewards,
    required this.collectingRewards,
    this.activeLoyaltyDetail,
    this.lastRedemption,
  });

  RewardsState copyWith({
    List<RestaurantLoyaltyCardModel>? availableRewards,
    List<RestaurantLoyaltyCardModel>? collectingRewards,
    LoyaltyDetailModel? activeLoyaltyDetail,
    RedeemedRewardSummary? lastRedemption,
  }) {
    return RewardsState(
      availableRewards: availableRewards ?? this.availableRewards,
      collectingRewards: collectingRewards ?? this.collectingRewards,
      activeLoyaltyDetail: activeLoyaltyDetail ?? this.activeLoyaltyDetail,
      lastRedemption: lastRedemption ?? this.lastRedemption,
    );
  }

  @override
  List<Object?> get props => [
        availableRewards,
        collectingRewards,
        activeLoyaltyDetail,
        lastRedemption,
      ];
}

