import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import 'loyalty_detail_view.dart';

class LoyaltyDetailPage extends StatelessWidget {
  final String? restaurantId;

  const LoyaltyDetailPage({
    super.key,
    this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = RewardsBloc()..add(const LoadRewardsEvent());
        if (restaurantId != null) {
          bloc.add(SelectRestaurantLoyaltyEvent(restaurantId!));
        }
        return bloc;
      },
      child: const LoyaltyDetailView(),
    );
  }
}

