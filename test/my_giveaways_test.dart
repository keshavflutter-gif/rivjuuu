import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/features/profile/view/my_giveaways_page.dart';

void main() {
  Widget createWidgetUnderTest({int initialTab = 0, bool? showBackButton, bool showBottomNav = true}) {
    return MaterialApp(
      home: MyGiveawaysPage(
        initialTab: initialTab,
        showBackButton: showBackButton,
        showBottomNav: showBottomNav,
      ),
    );
  }

  group('MyGiveawaysPage & MyGiveawaysView Tests', () {
    testWidgets('renders header, tabs, and Joined giveaway items matching my-giveaways.html', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Top bar title
      expect(find.text('My giveaways'), findsOneWidget);

      // 3 Tabs & 2 card badges with 'Joined' = 3 total
      expect(find.text('Joined'), findsNWidgets(3));
      expect(find.text('Won'), findsOneWidget);
      expect(find.text('Ended'), findsOneWidget);

      // Joined Tab content
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Win dinner for two'), findsOneWidget);
      expect(find.text('15,000 HUF dinner coupon'), findsOneWidget);
      expect(find.text('Draw on 15 Oct'), findsOneWidget);

      expect(find.text('Café Mókus'), findsOneWidget);
      expect(find.text('Dessert of the day'), findsOneWidget);
      expect(find.text('Daily prize'), findsOneWidget);
      expect(find.text('Next draw today 20:00'), findsOneWidget);

      // Status badges + tab bar = 3 widgets with text 'Joined'
      expect(find.text('Joined'), findsNWidgets(3));

      // Bottom nav items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Rewards'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('switching to Won tab renders won prize coupon card', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap 'Won' tab
      await tester.tap(find.text('Won'));
      await tester.pumpAndSettle();

      expect(find.text('Pizzeria Forno'), findsOneWidget);
      expect(find.text('Pizza night for four'), findsOneWidget);
      expect(find.text('Prize coupon · valid until 7 Nov'), findsOneWidget);
      expect(find.text('You won'), findsOneWidget);
      expect(find.text('View prize coupon'), findsOneWidget);
    });

    testWidgets('switching to Ended tab renders ended giveaways with grayscale items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap 'Ended' tab
      await tester.tap(find.text('Ended'));
      await tester.pumpAndSettle();

      expect(find.text('Pasta masterclass'), findsOneWidget);
      expect(find.text('Ramen for a week'), findsOneWidget);
      expect(find.text('Ended 30 Sep'), findsOneWidget);
      expect(find.text('Ended 18 Sep'), findsOneWidget);
      // 1 tab + 2 card badges = 3 widgets with text 'Ended'
      expect(find.text('Ended'), findsNWidgets(3));
      expect(find.text('Not selected this time'), findsNWidgets(2));
    });

    testWidgets('supports showBackButton when explicitly requested', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showBackButton: true));
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.text('My giveaways'), findsOneWidget);
    });
  });
}
