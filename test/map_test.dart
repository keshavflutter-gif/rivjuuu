import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/map/view/map_page.dart';
import 'package:rivjuuu/features/restaurant_detail/view/restaurant_detail_page.dart';

void main() {
  testWidgets('MapPage renders vector map, pins, top bar, and bottom card matching map.html',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: MapPage(initialSelectedName: 'Trattoria Nonna Rosa'),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top Bar
    expect(find.text('Search this area'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);

    // 2. Verify Selected Restaurant Card at Bottom
    expect(find.text('Trattoria Nonna Rosa'), findsWidgets);
    expect(find.text('8.9'), findsWidgets);
    expect(find.text('Italian'), findsWidgets);
    expect(find.text('1.2 km'), findsWidgets);
    expect(find.text('Open'), findsWidgets);
    expect(find.text('until 23:00'), findsWidgets);
    expect(find.text('3 coupons available'), findsWidgets);
    expect(find.text('View restaurant'), findsOneWidget);

    // 3. Tap 'View restaurant' -> navigates to RestaurantDetailPage
    await tester.tap(find.text('View restaurant'));
    await tester.pumpAndSettle();

    expect(find.byType(RestaurantDetailPage), findsOneWidget);

    // Pop back to Map
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
    await tester.pumpAndSettle();

    // 4. Verify Floating Locate Button and tap it
    expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.my_location_rounded));
    await tester.pump();
    expect(find.text('Centered to your location'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Show on map from RestaurantInfoSheet navigates directly to MapPage',
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

    // Tap More info to open bottom sheet
    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();

    expect(find.text('Show on map'), findsOneWidget);

    // Tap Show on map
    await tester.tap(find.text('Show on map'));
    await tester.pumpAndSettle();

    // Map screen should now be visible with Trattoria Nonna Rosa selected
    expect(find.byType(MapPage), findsOneWidget);
    expect(find.text('Search this area'), findsOneWidget);
    expect(find.text('View restaurant'), findsOneWidget);
  });
}
