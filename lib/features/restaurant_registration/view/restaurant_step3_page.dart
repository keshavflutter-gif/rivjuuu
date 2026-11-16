import 'package:flutter/material.dart';
import '../models/restaurant_registration_data.dart';
import 'restaurant_signup_flow_page.dart';

class RestaurantStep3Page extends StatelessWidget {
  final RestaurantRegistrationData? data;

  const RestaurantStep3Page({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return RestaurantSignupFlowPage(
      initialStep: 2,
      initialData: data,
    );
  }
}
