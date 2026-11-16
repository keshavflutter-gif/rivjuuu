import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/restaurant_detail/view/restaurant_tabbed_page.dart';
import 'package:rivjuuu/features/restaurant_detail/widgets/restaurant_tabs_bar_widget.dart';

void main() {
  testWidgets(
      'RestaurantTabbedView maintains independent scroll per tab and prevents scroll jumping',
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

    // 1. Verify Menu tab is selected and scrollable
    expect(find.byType(RestaurantTabsBarWidget), findsOneWidget);
    expect(find.text('Menu items'), findsOneWidget);

    final menuScrollFinder = find.byKey(const PageStorageKey('restaurant_tab_menu_scroll'));
    expect(menuScrollFinder, findsOneWidget);

    // Scroll down on Menu tab by 250px
    await tester.drag(menuScrollFinder, const Offset(0, -250));
    await tester.pumpAndSettle();

    // 2. Switch to Coupons tab (Index 1)
    await tester.tap(find.text('Coupons'));
    await tester.pumpAndSettle();

    // Verify Coupons tab starts smoothly at top (offset 0.0)
    final couponsScrollFinder = find.byKey(const PageStorageKey('restaurant_tab_coupons_scroll'));
    expect(couponsScrollFinder, findsOneWidget);

    final ScrollableState couponsScrollable = tester.state(
      find.descendant(
        of: couponsScrollFinder,
        matching: find.byType(Scrollable),
      ).first,
    );
    expect(couponsScrollable.position.pixels, 0.0);

    // Scroll down on Coupons tab
    await tester.drag(couponsScrollFinder, const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(couponsScrollable.position.pixels, greaterThan(0.0));

    // 3. Switch back to Menu tab (Index 0)
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();

    final ScrollableState menuScrollable = tester.state(
      find.descendant(
        of: menuScrollFinder,
        matching: find.byType(Scrollable),
      ).first,
    );
    // Menu tab should be at 250px where we left it, NOT jumping or resetting
    expect(menuScrollable.position.pixels, 250.0);

    // 4. Switch to Giveaways tab (Index 3)
    await tester.ensureVisible(find.text('Giveaways'));
    await tester.tap(find.text('Giveaways'));
    await tester.pumpAndSettle();

    final giveawaysScrollFinder = find.byKey(const PageStorageKey('restaurant_tab_giveaways_scroll'));
    expect(giveawaysScrollFinder, findsOneWidget);

    final ScrollableState giveawaysScrollable = tester.state(
      find.descendant(
        of: giveawaysScrollFinder,
        matching: find.byType(Scrollable),
      ).first,
    );
    expect(giveawaysScrollable.position.pixels, 0.0);
  });
}
