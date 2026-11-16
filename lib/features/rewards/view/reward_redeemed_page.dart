import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import 'reward_redeemed_view.dart';

class RewardRedeemedPage extends StatelessWidget {
  const RewardRedeemedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardsBloc()..add(const LoadRewardsEvent()),
      child: const RewardRedeemedView(),
    );
  }
}

