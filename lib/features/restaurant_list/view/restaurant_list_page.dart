import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/restaurant_list_bloc.dart';
import 'restaurant_list_view.dart';

class RestaurantListPage extends StatelessWidget {
  final String title;

  const RestaurantListPage({
    super.key,
    this.title = 'Italian restaurants',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantListBloc(title: title),
      child: const RestaurantListView(),
    );
  }
}
