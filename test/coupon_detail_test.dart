import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/coupon_detail/view/coupon_detail_page.dart';
import 'package:rivjuuu/features/restaurant_detail/models/restaurant_detail_models.dart';
import 'package:rivjuuu/features/restaurant_detail/view/restaurant_tabbed_page.dart';

void main() {
  group('CouponDetailPage Tests (coupon.html & coupon-unavailable.html)', () {
    testWidgets(
        'Available state renders matching coupon.html with Redeem coupon CTA',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const CouponDetailPage(
            isAvailable: true,
            title: '20% off your whole bill',
            discountVal: '20% OFF',
            restaurantName: 'Trattoria Nonna Rosa',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar
      expect(find.text('Coupon'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);

      // Big Coupon Card
      expect(find.text('Percentage discount'), findsOneWidget);
      expect(find.text('20% OFF'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('NR'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa · 1.2 km'), findsOneWidget);

      // Status row
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('Dine-in · Trattoria Nonna Rosa'), findsOneWidget);

      // Info rows
      expect(
        find.text('Get 20% off the food on your bill when you dine in.'),
        findsOneWidget,
      );
      expect(find.text('Minimum spend 5,000 HUF'), findsOneWidget);
      expect(find.text('Checked by restaurant staff'), findsOneWidget);
      expect(find.text('Valid 1 Oct – 31 Oct 2026'), findsOneWidget);
      expect(find.text('Available Mon–Sun, 12:00–22:00'), findsOneWidget);
      expect(find.text('Once per customer'), findsOneWidget);
      expect(find.text('Earn 40 loyalty points'), findsOneWidget);
      expect(
        find.text('Points can only be used at Trattoria Nonna Rosa'),
        findsOneWidget,
      );

      // Terms and conditions
      expect(find.text('Terms and conditions'), findsOneWidget);
      expect(find.text('Dine-in only.'), findsOneWidget);
      expect(
        find.text('Cannot be combined with other coupons or rewards.'),
        findsOneWidget,
      );
      expect(
        find.text('Drinks are not included in the discount.'),
        findsOneWidget,
      );
      expect(
        find.text(
            'The restaurant may decline the coupon if the conditions are not met.'),
        findsOneWidget,
      );

      // Hint box
      expect(
        find.text(
            'Restaurant staff will check that your purchase meets the coupon conditions before scanning your QR code.'),
        findsOneWidget,
      );

      // Sticky CTA button
      expect(find.text('Redeem coupon'), findsOneWidget);

      // Tap Redeem coupon -> opens QR redemption screen
      await tester.tap(find.text('Redeem coupon'));
      await tester.pumpAndSettle();

      expect(find.text('Show this QR code to restaurant staff.'), findsOneWidget);
    });

    testWidgets(
        'Unavailable state renders matching coupon-unavailable.html with disabled button',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CouponDetailPage(
            isAvailable: false,
            title: '20% off your whole bill',
            discountVal: '20% OFF',
            statusText: 'Not available right now',
            unavailableReason: 'Available from 12:00',
            unavailableSubtext:
                'This coupon can be redeemed Mon–Sun, 12:00–22:00.',
            restaurantName: 'Trattoria Nonna Rosa',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar & Card
      expect(find.text('Coupon'), findsOneWidget);
      expect(find.text('20% OFF'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);

      // Status pill
      expect(find.text('Not available right now'), findsOneWidget);

      // Disabled CTA
      expect(find.text('Available from 12:00'), findsOneWidget);
      expect(
        find.text('This coupon can be redeemed Mon–Sun, 12:00–22:00.'),
        findsOneWidget,
      );

      // Verify button is disabled
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Available from 12:00'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets(
        'Status row and card restaurant row render on narrow screens without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: CouponDetailPage(
            isAvailable: false,
            title: '20% off your whole bill with extra long title',
            discountVal: '20% OFF',
            statusText: 'Not available right now',
            restaurantName: 'Trattoria Nonna Rosa Long Name',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Not available right now'), findsOneWidget);
    });

    testWidgets(
        'CouponDetailPage.fromCoupon factory handles available and wait coupons correctly',
        (tester) async {
      const activeCoupon = CouponModel(
        id: 'c1',
        discountVal: '20%',
        discountSmall: 'Off',
        type: 'Discount',
        title: '20% off your whole bill',
        requirement: 'Minimum spend 5,000 HUF',
        statusText: 'Available',
        statusType: CouponStatusType.available,
        meta: 'Until 31 Oct',
      );

      const waitCoupon = CouponModel(
        id: 'c4',
        discountVal: 'Happy',
        discountSmall: 'Hour',
        type: 'Happy hour',
        title: 'Aperol spritz for 1,500 HUF',
        requirement: 'Mon–Fri, 16:00–18:00',
        statusText: 'Available from 16:00',
        statusType: CouponStatusType.wait,
      );

      // Test active coupon
      await tester.pumpWidget(
        MaterialApp(
          home: CouponDetailPage.fromCoupon(activeCoupon),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('Redeem coupon'), findsOneWidget);

      // Test wait coupon
      await tester.pumpWidget(
        MaterialApp(
          home: CouponDetailPage.fromCoupon(waitCoupon),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Not available right now'), findsOneWidget);
      expect(find.text('Available from 16:00'), findsOneWidget);
      expect(
        find.text('This coupon can be redeemed Mon–Sun, 12:00–22:00.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'RestaurantTabbedPage Coupons tab: tapping available opens coupon.html and wait opens coupon-unavailable.html',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantTabbedPage(initialTabIndex: 1),
        ),
      );
      await tester.pumpAndSettle();

      // Coupons tab is active
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('Aperol spritz for 1,500 HUF'), findsOneWidget);

      // 1. Tap Available coupon
      await tester.tap(find.text('20% off your whole bill'));
      await tester.pumpAndSettle();

      // Should be on available coupon page
      expect(find.text('Redeem coupon'), findsOneWidget);
      expect(find.text('Available'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // 2. Scroll to and tap Unavailable/Wait coupon "Aperol spritz for 1,500 HUF"
      await tester.ensureVisible(find.text('Aperol spritz for 1,500 HUF'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aperol spritz for 1,500 HUF'));
      await tester.pumpAndSettle();

      // Should be on unavailable coupon page
      expect(find.text('Not available right now'), findsOneWidget);
      expect(find.text('Available from 16:00'), findsOneWidget);
      final disabledBtn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Available from 16:00'),
      );
      expect(disabledBtn.onPressed, isNull);
    });
  });
}
