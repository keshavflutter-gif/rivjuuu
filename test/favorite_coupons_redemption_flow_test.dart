import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/profile/view/favorite_coupons_page.dart';
import 'package:rivjuuu/features/profile/view/redemption_success_page.dart';

void main() {
  group('Favorite Coupons -> QR -> Redemption Success Flow Tests', () {
    testWidgets('Tapping coupon opens QR screen, and tapping Done on QR screen opens Redemption Success screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const FavoriteCouponsPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: Favorite coupons screen (Image 1)
      expect(find.text('Favorite coupons'), findsOneWidget);
      expect(find.text('3 saved coupons'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('Free dessert with any main'), findsOneWidget);
      expect(find.text('Two cocktails for one'), findsOneWidget);

      // Step 2: Tap on 1st coupon to open QR screen (Image 2)
      await tester.tap(find.text('20% off your whole bill'));
      await tester.pumpAndSettle();

      expect(find.text('Redeem coupon'), findsOneWidget);
      expect(find.text('20% OFF'), findsOneWidget);
      expect(find.text('Show this QR code to restaurant staff.'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Step 3: Tap 'Done' on QR screen -> Navigates to Redemption Success screen (Image 3)
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Step 4: Verify Redemption Success screen (Image 3)
      expect(find.text('Coupon redeemed'), findsOneWidget);
      expect(
        find.text('Your coupon was successfully used at this restaurant.'),
        findsOneWidget,
      );
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('8 Oct 2026, 19:42'), findsOneWidget);
      expect(find.text('+40 points'), findsOneWidget);

      // Verify buttons
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('View rewards'), findsOneWidget);
    });

    testWidgets('RedemptionSuccessPage renders standalone with custom data', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RedemptionSuccessPage(
            restaurant: 'Café Mókus',
            coupon: 'Free dessert with any main',
            redeemed: '12 Oct 2026, 15:30',
            loyaltyPoints: '+25 points',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Coupon redeemed'), findsOneWidget);
      expect(find.text('Café Mókus'), findsOneWidget);
      expect(find.text('Free dessert with any main'), findsOneWidget);
      expect(find.text('12 Oct 2026, 15:30'), findsOneWidget);
      expect(find.text('+25 points'), findsOneWidget);
    });
  });
}
