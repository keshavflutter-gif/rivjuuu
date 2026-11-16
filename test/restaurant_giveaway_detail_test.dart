import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_giveaway_form_page.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_giveaway_detail_page.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: child,
    );
  }

  group('Restaurant Giveaway Detail & Draw & Winners Flow Tests', () {
    testWidgets('RestaurantGiveawayDetailPage renders exact overview matching giveaway-detail.html',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(const RestaurantGiveawayDetailPage()),
      );
      await tester.pumpAndSettle();

      // Top title and Active status
      expect(find.text('Win dinner for two'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      // Facts
      expect(find.text('Entries'), findsOneWidget);
      expect(find.text('1,248'), findsOneWidget);
      expect(find.text('Winners'), findsWidgets); // tab and fact
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Ends'), findsOneWidget);
      expect(find.text('14 Oct'), findsOneWidget);

      // 3 Tabs
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Participants'), findsOneWidget);

      // Overview Prize card
      expect(find.text('15,000 HUF dinner coupon'), findsOneWidget);
      expect(find.text('Prize coupon valid for 30 days'), findsOneWidget);

      // Rules card
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Free to join, one entry per customer.'), findsOneWidget);
      expect(
          find.text('Customers aged 18+. Staff can’t take part.'), findsOneWidget);
      expect(find.text('Winners drawn at random after 14 Oct.'), findsOneWidget);

      // Runs card
      expect(find.text('Runs'), findsOneWidget);
      expect(find.text('1 Oct – 14 Oct 2026'), findsOneWidget);

      // Draw winners action
      expect(find.text('Draw winners'), findsOneWidget);
      expect(find.text('End giveaway early'), findsOneWidget);
    });

    testWidgets(
        'Tapping Draw winners opens giveaway-draw.html sheet, and tapping Draw winners transitions to giveaway-winners.html',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(const RestaurantGiveawayDetailPage()),
      );
      await tester.pumpAndSettle();

      // Tap "Draw winners" in overview
      await tester.tap(find.text('Draw winners'));
      await tester.pumpAndSettle();

      // Verify giveaway-draw.html modal sheet is displayed
      expect(find.text('Draw 3 winners?'), findsOneWidget);
      expect(
        find.text(
            'Winners are picked at random from 1,248 participants. Each winner gets the prize coupon and a notification. This can’t be undone.'),
        findsOneWidget,
      );
      expect(
        find.text(
            'The giveaway closes when you draw. New entries won’t be accepted.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Draw winners inside modal sheet (the one on top in the sheet)
      final drawBtnInSheet = find.widgetWithText(ElevatedButton, 'Draw winners').last;
      await tester.tap(drawBtnInSheet);
      await tester.pumpAndSettle();

      // Modal closed, active tab transitioned to Winners, and giveaway-winners.html view is rendered
      expect(find.text('Draw 3 winners?'), findsNothing);
      expect(
        find.text('3 winners drawn. Prize coupons have been sent.'),
        findsOneWidget,
      );

      // Status badge updated to Completed
      expect(find.text('Completed'), findsOneWidget);

      // 3 Winners rendered
      expect(find.text('Eszter F.'), findsOneWidget);
      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('Dávid M.'), findsOneWidget);
      expect(find.text('EF'), findsOneWidget);
      expect(find.text('AK'), findsOneWidget);
      expect(find.text('DM'), findsOneWidget);
      expect(find.text('Prize coupon awarded'), findsNWidgets(3));
      expect(find.text('Sent'), findsNWidgets(3));
    });

    testWidgets(
        'Switching to Participants tab renders participants list matching giveaway-participants.html',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(const RestaurantGiveawayDetailPage()),
      );
      await tester.pumpAndSettle();

      // Switch to Participants tab
      await tester.tap(find.text('Participants'));
      await tester.pumpAndSettle();

      expect(find.text('1,248 participants · newest first'), findsOneWidget);
      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('Péter N.'), findsOneWidget);
      expect(find.text('Eszter F.'), findsOneWidget);
      expect(find.text('Dávid M.'), findsOneWidget);
      expect(find.text('Joined today, 19:50'), findsOneWidget);
      expect(find.text('Joined today, 18:02'), findsOneWidget);
    });

    testWidgets(
        'Publishing giveaway in RestaurantGiveawayFormPage opens RestaurantGiveawayDetailPage',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantGiveawayFormPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Publish giveaway'), findsOneWidget);

      // Tap Publish giveaway
      await tester.tap(find.text('Publish giveaway'));
      await tester.pumpAndSettle();

      // Verify that RestaurantGiveawayDetailPage is opened
      expect(find.text('Win dinner for two'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Draw winners'), findsOneWidget);
    });
  });
}
