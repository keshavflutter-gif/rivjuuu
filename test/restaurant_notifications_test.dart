import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_notifications_page.dart';

void main() {
  testWidgets(
      'RestaurantNotificationsPage renders matching notifications.html reference design',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: RestaurantNotificationsPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top Bar
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Mark all read'), findsOneWidget);

    // 2. Sections
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('THIS WEEK'), findsOneWidget);

    // 3. Notifications from notifications.html
    expect(find.text('18 coupons redeemed today'), findsOneWidget);
    expect(find.text('Your busiest Tuesday this month.'), findsOneWidget);
    expect(find.text('21:00'), findsOneWidget);

    expect(find.text('Giveaway ends tomorrow'), findsOneWidget);
    expect(
      find.text(
          'Win dinner for two has 1,248 entries. Draw winners after 14 Oct.'),
      findsOneWidget,
    );
    expect(find.text('10:00'), findsOneWidget);

    expect(find.text('Reward redeemed'), findsOneWidget);
    expect(find.text('Bence T. used Free espresso (150 points).'), findsOneWidget);
    expect(find.text('Mon'), findsWidgets);

    expect(find.text('Subscription renewed'), findsOneWidget);
    expect(
        find.text('Growth plan renewed until 14 Nov 2026.'), findsOneWidget);

    expect(find.text('Coupon ends soon'), findsOneWidget);
    expect(
        find.text('20% off your whole bill ends on 31 Oct.'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);

    expect(find.text('Your restaurant is approved'), findsOneWidget);
    expect(find.text('Welcome to Rivjuuu, Trattoria Nonna Rosa.'), findsOneWidget);
    expect(find.text('1 Oct'), findsOneWidget);

    // 4. Tap "Mark all read"
    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();

    expect(find.text('All notifications marked as read'), findsOneWidget);
  });
}

