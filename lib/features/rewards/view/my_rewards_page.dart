import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import 'my_rewards_view.dart';

class MyRewardsPage extends StatelessWidget {
  const MyRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardsBloc()..add(const LoadRewardsEvent()),
      child: const MyRewardsView(),
    );
  }
}

