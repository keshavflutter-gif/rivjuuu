import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/profile/view/profile_page.dart';
import 'package:rivjuuu/features/rewards/view/my_rewards_page.dart';
import 'package:rivjuuu/features/rewards/widgets/reward_redeem_bottom_sheet.dart';

void main() {
  testWidgets('MyRewardsPage renders matching my-rewards.html reference design',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: MyRewardsPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Title & Intro strip
    expect(find.text('My rewards'), findsOneWidget);
    expect(
      find.text(
        'Your restaurant rewards. Points stay with the restaurant where you earned them.',
      ),
      findsOneWidget,
    );

    // 2. Sections: Reward available & Collecting
    expect(find.text('REWARD AVAILABLE'), findsOneWidget);
    expect(find.text('Kōya Sushi & Ramen'), findsOneWidget);
    expect(find.text('Free miso ramen is ready'), findsOneWidget);
    expect(find.text('Reward ready'), findsOneWidget);
    expect(find.text('1,050'), findsOneWidget);

    expect(find.text('COLLECTING'), findsOneWidget);
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('80 more for your next reward'), findsOneWidget);
    expect(find.text('Bamba Burger Bar'), findsOneWidget);
    expect(find.text('Café Mókus'), findsOneWidget);

    // 3. Bottom nav bar shows Rewards tab active
    expect(find.text('Rewards'), findsOneWidget);
  });

  testWidgets(
      'Full reward flow: my-rewards -> loyalty-detail -> reward-redeem -> reward-redeemed',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: MyRewardsPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Tap on Trattoria Nonna Rosa in My rewards
    await tester.tap(find.text('Trattoria Nonna Rosa'));
    await tester.pumpAndSettle();

    // 2. On LoyaltyDetailPage
    expect(find.text('Points can only be used here'), findsOneWidget);
    expect(find.text('320'), findsOneWidget);
    expect(find.textContaining('until your next reward'), findsOneWidget);
    expect(find.text('Available rewards'), findsOneWidget);
    expect(find.text('Free espresso'), findsOneWidget);
    expect(find.text('Free dessert'), findsOneWidget);
    expect(find.text('Redeem'), findsOneWidget);
    expect(find.text('Locked'), findsWidgets);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Earned · 20% off coupon'), findsOneWidget);

    // 3. Tap "Redeem" to open reward-redeem bottom sheet
    await tester.tap(find.text('Redeem'));
    await tester.pumpAndSettle();

    expect(find.byType(RewardRedeemBottomSheet), findsOneWidget);
    expect(find.text('Use 150 points for a free espresso?'), findsOneWidget);
    expect(find.text('Your points'), findsOneWidget);
    expect(find.descendant(
      of: find.byType(RewardRedeemBottomSheet),
      matching: find.text('−150'),
    ), findsOneWidget);
    expect(find.text('Points left'), findsOneWidget);
    expect(find.text('Redeem reward'), findsOneWidget);

    // 4. Confirm redemption
    await tester.tap(find.text('Redeem reward'));
    await tester.pumpAndSettle();

    // 5. On RewardRedeemedPage
    expect(find.text('Reward redeemed'), findsOneWidget);
    expect(find.text('Enjoy your free espresso at Trattoria Nonna Rosa.'),
        findsOneWidget);
    expect(find.text('Points used'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('170 points'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // 6. Tap "Done" to return to LoyaltyDetailPage
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Verified points updated to 170
    expect(find.text('170'), findsOneWidget);
    expect(find.text('Redeemed · Free espresso'), findsWidgets);
  });

  testWidgets('ProfilePage My rewards item navigates to MyRewardsPage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: ProfilePage(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap "My rewards" under My activity
    await tester.tap(find.text('My rewards'));
    await tester.pumpAndSettle();

    expect(find.byType(MyRewardsPage), findsOneWidget);
    expect(find.text('My rewards'), findsWidgets);
  });
}
