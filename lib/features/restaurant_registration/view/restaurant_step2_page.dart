import 'package:flutter/material.dart';
import '../models/restaurant_registration_data.dart';
import 'restaurant_signup_flow_page.dart';

class RestaurantStep2Page extends StatelessWidget {
  final RestaurantRegistrationData? data;

  const RestaurantStep2Page({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return RestaurantSignupFlowPage(
      initialStep: 1,
      initialData: data,
    );
  }
}
