import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/restaurant_detail/view/restaurant_detail_page.dart';
import 'package:rivjuuu/features/restaurant_detail/view/restaurant_tabbed_page.dart';
import 'package:rivjuuu/features/restaurant_detail/widgets/restaurant_tabs_bar_widget.dart';
import 'package:rivjuuu/features/restaurant_detail/widgets/restaurant_mini_head_widget.dart';

void main() {
  testWidgets('RestaurantDetailPage renders properly and opens tabs & sheets',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantDetailPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Header info (Image 2 / restaurant.html)
    expect(find.text('Trattoria Nonna Rosa'), findsWidgets);
    expect(find.text('NR'), findsOneWidget);
    expect(find.text('8.9'), findsWidgets);
    expect(find.text('(214 reviews)'), findsOneWidget);
    expect(find.text('Italian'), findsWidgets);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('until 23:00'), findsOneWidget);
    expect(find.text('View coupons (3)'), findsOneWidget);

    // 2. Verify 5 Tabs
    expect(find.byType(RestaurantTabsBarWidget), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Coupons'), findsOneWidget);
    expect(find.text('Loyalty'), findsOneWidget);
    expect(find.text('Giveaways'), findsOneWidget);
    expect(find.text('Reviews'), findsOneWidget);

    // 3. Tab 0: Menu overview by default (Menu photos & Popular dishes)
    expect(find.text('Menu photos'), findsOneWidget);
    expect(find.text('Popular dishes'), findsOneWidget);
    expect(find.text('Cacio e pepe'), findsOneWidget);
    expect(find.text('Tiramisu della Nonna'), findsOneWidget);

    // 4. Tap "View coupons (3)" -> navigates to Coupons screen (Image 3)
    await tester.tap(find.text('View coupons (3)'));
    await tester.pumpAndSettle();

    expect(find.byType(RestaurantMiniHeadWidget), findsOneWidget);
    expect(find.text('20% off your whole bill'), findsOneWidget);
    expect(find.text('Free tiramisu with any main'), findsOneWidget);
    expect(find.text('Second Margherita free'), findsOneWidget);
    expect(find.text('Past coupons'), findsOneWidget);
    expect(find.text('Truffle week'), findsOneWidget);

    // Pop back to Restaurant Overview
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pumpAndSettle();

    // 5. Open More info sheet
    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();

    expect(find.text('About Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('Fő utca 12, Hungary'), findsOneWidget);
    expect(find.text('Show on map'), findsOneWidget);

    // Close modal sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('About Trattoria Nonna Rosa'), findsNothing);
  });

  testWidgets(
      'RestaurantTabbedPage renders Image 3 (Coupons), Image 4 (Loyalty), Image 5 (Giveaways)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantTabbedPage(initialTabIndex: 1),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Coupons (Image 3)
    expect(find.byType(RestaurantMiniHeadWidget), findsOneWidget);
    expect(find.text('20% off your whole bill'), findsOneWidget);
    expect(find.text('Free tiramisu with any main'), findsOneWidget);

    // 2. Switch to Loyalty (Image 4)
    await tester.tap(find.text('Loyalty'));
    await tester.pumpAndSettle();

    expect(find.text('320'), findsOneWidget);
    expect(find.text('points'), findsOneWidget);
    expect(find.text('Available rewards'), findsOneWidget);
    expect(find.text('Free espresso'), findsOneWidget);
    expect(find.text('Points activity'), findsOneWidget);

    // 3. Switch to Giveaways (Image 5)
    await tester.ensureVisible(find.text('Giveaways'));
    await tester.tap(find.text('Giveaways'));
    await tester.pumpAndSettle();

    expect(find.text('Win dinner for two'), findsOneWidget);
    expect(find.text('Dessert of the day, every day this week'), findsOneWidget);
    expect(find.text('Pizza night for four'), findsOneWidget);
    expect(find.text('Join giveaway'), findsOneWidget);
  });

  testWidgets('RestaurantTabbedPage renders Full Menu (restaurant-menu.html)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantTabbedPage(initialTabIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RestaurantMiniHeadWidget), findsOneWidget);
    expect(find.text('Menu items'), findsOneWidget);
    expect(find.text('Starters'), findsOneWidget);
    expect(find.text('Burrata & tomatoes'), findsOneWidget);
    expect(find.text('Main dishes'), findsOneWidget);
    expect(find.text('Desserts'), findsOneWidget);
    expect(find.text('Drinks'), findsOneWidget);
  });

  testWidgets('RestaurantDetailPage renders with zero overflow on small screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantDetailPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trattoria Nonna Rosa'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
