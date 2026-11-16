import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/restaurant_list/view/restaurant_list_page.dart';

void main() {
  testWidgets(
      'RestaurantListPage renders matching restaurant-list.html and reference image',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantListPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top bar: Back, Title, Map
    expect(find.text('Italian restaurants'), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowLeft), findsOneWidget);
    expect(find.byIcon(LucideIcons.map), findsOneWidget);

    // 2. Filter chips
    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // badge count
    expect(find.text('Has coupons'), findsOneWidget);
    expect(find.text('Open now', skipOffstage: false), findsOneWidget);

    // 3. Count line
    expect(find.text('18 restaurants'), findsOneWidget);

    // 4. Restaurant items matching restaurant-list.html
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('8.9'), findsOneWidget);
    expect(find.text('1.2 km'), findsOneWidget);
    expect(find.text('3 coupons available'), findsOneWidget);

    expect(find.text('Pizzeria Forno'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
    expect(find.text('1.5 km'), findsOneWidget);
    expect(find.text('Highlighted'), findsOneWidget);

    expect(find.text('Pasta & Pizza Lab'), findsOneWidget);
    expect(find.text('7.9'), findsOneWidget);
    expect(find.text('2.6 km'), findsOneWidget);
    expect(find.text('1 coupon available'), findsOneWidget);

    expect(find.text('Napoli Corner'), findsOneWidget);
    expect(find.text('8.2'), findsOneWidget);
    expect(find.text('2.0 km'), findsOneWidget);

    expect(find.text('Dolce Vita Bistro'), findsOneWidget);
    expect(find.text('8.5'), findsOneWidget);
    expect(find.text('3.3 km'), findsOneWidget);
    expect(find.text('Free dessert'), findsOneWidget);

    // 5. Bottom Navigation Bar matching screenshot
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 6. Tap filter chip
    await tester.tap(find.text('Distance'));
    await tester.pumpAndSettle();
  });
}
