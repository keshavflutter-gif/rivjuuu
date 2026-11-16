import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/rewards_models.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  RewardsBloc() : super(_initialState()) {
    on<LoadRewardsEvent>(_onLoadRewards);
    on<SelectRestaurantLoyaltyEvent>(_onSelectRestaurantLoyalty);
    on<RedeemRewardEvent>(_onRedeemReward);
  }

  static RewardsState _initialState() {
    final available = [
      const RestaurantLoyaltyCardModel(
        id: 'koya',
        name: 'Kōya Sushi & Ramen',
        logoText: 'KS',
        activeAgo: 'Active 2 days ago',
        points: 1050,
        targetPoints: 1000,
        progress: 1.0,
        footerText: 'Free miso ramen is ready',
        isReady: true,
        imagePath: 'assets/sushi.jpg',
      ),
    ];

    final collecting = [
      const RestaurantLoyaltyCardModel(
        id: 'trattoria',
        name: 'Trattoria Nonna Rosa',
        logoText: 'NR',
        activeAgo: 'Active today',
        points: 320,
        targetPoints: 400,
        progress: 0.80,
        footerText: '80 more for your next reward',
        imagePath: 'assets/pasta.jpg',
      ),
      const RestaurantLoyaltyCardModel(
        id: 'bamba',
        name: 'Bamba Burger Bar',
        logoText: 'BB',
        activeAgo: 'Active 5 days ago',
        points: 140,
        targetPoints: 300,
        progress: 0.47,
        footerText: '160 more for your next reward',
        imagePath: 'assets/burger.jpg',
      ),
      const RestaurantLoyaltyCardModel(
        id: 'mokus',
        name: 'Café Mókus',
        logoText: 'CM',
        activeAgo: 'Active 1 week ago',
        points: 60,
        targetPoints: 150,
        progress: 0.40,
        footerText: '90 more for your next reward',
        imagePath: 'assets/coffee.jpg',
      ),
    ];

    final trattoriaDetail = const LoyaltyDetailModel(
      id: 'trattoria',
      restaurantName: 'Trattoria Nonna Rosa',
      logoText: 'NR',
      points: 320,
      maxPoints: 400,
      pointsToNext: 80,
      nextRewardTitle: 'Free dessert',
      rewards: [
        LoyaltyRewardItemModel(
          id: 'r1',
          title: 'Free espresso',
          points: 150,
          subtitle: '150 points · You can use this',
          imagePath: 'assets/coffee.jpg',
          isLocked: false,
        ),
        LoyaltyRewardItemModel(
          id: 'r2',
          title: 'Free dessert',
          points: 400,
          subtitle: '400 points · 80 more to go',
          imagePath: 'assets/tiramisu.jpg',
          isLocked: true,
        ),
        LoyaltyRewardItemModel(
          id: 'r3',
          title: '10% bonus on your bill',
          points: 700,
          subtitle: '700 points · 380 more to go',
          imagePath: 'assets/table.jpg',
          isLocked: true,
        ),
      ],
      activities: [
        LoyaltyActivityItemModel(
          title: 'Earned · 20% off coupon',
          date: '8 Oct 2026',
          deltaText: '+40',
          isPositive: true,
        ),
        LoyaltyActivityItemModel(
          title: 'Redeemed · Free espresso',
          date: '2 Oct 2026',
          deltaText: '−150',
          isPositive: false,
        ),
        LoyaltyActivityItemModel(
          title: 'Earned · Free tiramisu coupon',
          date: '24 Sep 2026',
          deltaText: '+25',
          isPositive: true,
        ),
        LoyaltyActivityItemModel(
          title: 'Earned · First visit coupon',
          date: '12 Sep 2026',
          deltaText: '+40',
          isPositive: true,
        ),
      ],
    );

    return RewardsState(
      availableRewards: available,
      collectingRewards: collecting,
      activeLoyaltyDetail: trattoriaDetail,
    );
  }

  void _onLoadRewards(
    LoadRewardsEvent event,
    Emitter<RewardsState> emit,
  ) {
    emit(_initialState());
  }

  void _onSelectRestaurantLoyalty(
    SelectRestaurantLoyaltyEvent event,
    Emitter<RewardsState> emit,
  ) {
    if (event.restaurantId == 'trattoria') {
      // Keep or refresh trattoria
      return;
    }

    if (event.restaurantId == 'koya') {
      emit(
        state.copyWith(
          activeLoyaltyDetail: const LoyaltyDetailModel(
            id: 'koya',
            restaurantName: 'Kōya Sushi & Ramen',
            logoText: 'KS',
            points: 1050,
            maxPoints: 1000,
            pointsToNext: 0,
            nextRewardTitle: 'Free miso ramen',
            rewards: [
              LoyaltyRewardItemModel(
                id: 'k1',
                title: 'Free miso ramen',
                points: 1000,
                subtitle: '1,000 points · You can use this',
                imagePath: 'assets/ramen.jpg',
                isLocked: false,
              ),
              LoyaltyRewardItemModel(
                id: 'k2',
                title: 'Sake set',
                points: 1500,
                subtitle: '1,500 points · 450 more to go',
                imagePath: 'assets/sushi.jpg',
                isLocked: true,
              ),
            ],
            activities: [
              LoyaltyActivityItemModel(
                title: 'Earned · Dinner for two',
                date: '5 Nov 2026',
                deltaText: '+150',
                isPositive: true,
              ),
              LoyaltyActivityItemModel(
                title: 'Earned · Ramen combo',
                date: '28 Oct 2026',
                deltaText: '+80',
                isPositive: true,
              ),
            ],
          ),
        ),
      );
    }
  }

  void _onRedeemReward(
    RedeemRewardEvent event,
    Emitter<RewardsState> emit,
  ) {
    final currentDetail = state.activeLoyaltyDetail;
    if (currentDetail == null) return;

    final targetReward = currentDetail.rewards.firstWhere(
      (r) => r.id == event.rewardId,
      orElse: () => currentDetail.rewards.first,
    );

    final newPoints = (currentDetail.points - targetReward.points).clamp(0, 99999);
    final newPointsToNext = (currentDetail.maxPoints - newPoints).clamp(0, currentDetail.maxPoints);

    final updatedRewards = currentDetail.rewards.map((r) {
      final isLocked = newPoints < r.points;
      final subtitle = isLocked
          ? '${r.points} points · ${r.points - newPoints} more to go'
          : '${r.points} points · You can use this';
      return r.copyWith(isLocked: isLocked, subtitle: subtitle);
    }).toList();

    final updatedActivities = [
      LoyaltyActivityItemModel(
        title: 'Redeemed · ${targetReward.title}',
        date: 'Today',
        deltaText: '−${targetReward.points}',
        isPositive: false,
      ),
      ...currentDetail.activities,
    ];

    final updatedDetail = currentDetail.copyWith(
      points: newPoints,
      pointsToNext: newPointsToNext,
      rewards: updatedRewards,
      activities: updatedActivities,
    );

    // Also update collecting card if matching
    final updatedCollecting = state.collectingRewards.map((card) {
      if (card.id == currentDetail.id) {
        final progress = (newPoints / card.targetPoints).clamp(0.0, 1.0);
        return card.copyWith(
          points: newPoints,
          progress: progress,
          footerText: '$newPointsToNext more for your next reward',
        );
      }
      return card;
    }).toList();

    emit(
      state.copyWith(
        activeLoyaltyDetail: updatedDetail,
        collectingRewards: updatedCollecting,
        lastRedemption: RedeemedRewardSummary(
          restaurantName: currentDetail.restaurantName,
          rewardTitle: targetReward.title,
          pointsUsed: targetReward.points,
          pointsLeft: newPoints,
        ),
      ),
    );
  }
}

