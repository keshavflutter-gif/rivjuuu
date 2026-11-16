import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../bloc/restaurant_detail_event.dart';
import 'restaurant_tabbed_view.dart';

class RestaurantTabbedPage extends StatelessWidget {
  final int initialTabIndex;
  final String restaurantName;

  const RestaurantTabbedPage({
    super.key,
    this.initialTabIndex = 1,
    this.restaurantName = 'Trattoria Nonna Rosa',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantDetailBloc(initialTabIndex: initialTabIndex)
        ..add(RestaurantDetailLoaded(
          restaurantName: restaurantName,
          initialTabIndex: initialTabIndex,
        )),
      child: const RestaurantTabbedView(),
    );
  }
}

