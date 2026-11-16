import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/categories/view/categories_page.dart';
import 'package:rivjuuu/features/home/view/home_page.dart';
import 'package:rivjuuu/features/restaurant_list/view/restaurant_list_page.dart';
import 'package:rivjuuu/features/search/view/search_page.dart';

void main() {
  testWidgets('CategoriesPage renders all 10 categories matching categories.html',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: CategoriesPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top Bar Title & Search Icon
    expect(find.text('Categories'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // 2. Verify All 10 categories from categories.html
    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('42 places'), findsOneWidget);

    expect(find.text('Burgers'), findsOneWidget);
    expect(find.text('31 places'), findsOneWidget);

    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('18 places'), findsOneWidget);

    expect(find.text('Asian'), findsOneWidget);
    expect(find.text('27 places'), findsOneWidget);

    expect(find.text('Hungarian'), findsOneWidget);
    expect(find.text('24 places'), findsOneWidget);

    expect(find.text('Indian'), findsOneWidget);
    expect(find.text('12 places'), findsOneWidget);

    // Scroll to see remaining categories
    await tester.drag(find.byType(GridView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('Desserts'), findsOneWidget);
    expect(find.text('20 places'), findsOneWidget);

    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('35 places'), findsOneWidget);

    expect(find.text('Healthy'), findsOneWidget);
    expect(find.text('16 places'), findsOneWidget);

    expect(find.text('Grill'), findsOneWidget);
    expect(find.text('14 places'), findsOneWidget);

    // 3. Tap a category tile -> navigates to RestaurantListPage
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();

    expect(find.byType(RestaurantListPage), findsOneWidget);
  });

  testWidgets('HomePage "See all" next to Categories navigates to CategoriesPage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Categories section header
    expect(find.text('Categories'), findsOneWidget);

    // Tap "See all" next to Categories
    await tester.tap(find.text('See all').first);
    await tester.pumpAndSettle();

    // Verify CategoriesPage is opened
    expect(find.byType(CategoriesPage), findsOneWidget);
    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('42 places'), findsOneWidget);

    // Tap Search button in CategoriesPage top bar
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });
}

