import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/auth/view/account_type_page.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_state.dart';
import 'package:rivjuuu/features/restaurant_registration/models/restaurant_registration_data.dart';
import 'package:rivjuuu/features/restaurant_registration/repository/restaurant_signup_repository.dart';
import 'package:rivjuuu/features/restaurant_registration/view/registration_pending_page.dart';
import 'package:rivjuuu/features/restaurant_registration/view/registration_approved_page.dart';
import 'package:rivjuuu/features/restaurant_registration/view/choose_plan_page.dart';
import 'package:rivjuuu/features/restaurant_registration/view/restaurant_signup_flow_page.dart';
import 'package:rivjuuu/features/restaurant_registration/view/restaurant_step1_page.dart';
import 'package:rivjuuu/features/restaurant_dashboard/view/restaurant_dashboard_page.dart';
import 'package:rivjuuu/features/restaurant_coupons/view/restaurant_coupons_page.dart';
import 'package:rivjuuu/features/restaurant_coupons/view/restaurant_coupon_form_page.dart';
import 'package:rivjuuu/features/restaurant_coupons/view/restaurant_coupon_detail_page.dart';
import 'package:rivjuuu/features/restaurant_scanner/view/restaurant_scanner_page.dart';
import 'package:rivjuuu/features/restaurant_scanner/view/restaurant_scan_result_page.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_account_page.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_menu_manage_page.dart';

class FailingMockRestaurantRepository implements RestaurantSignupRepository {
  @override
  Future<void> submitRegistration(RestaurantSignupState state) async {
    throw Exception('Network error: Failed to submit registration');
  }
}

class FastSuccessMockRestaurantRepository implements RestaurantSignupRepository {
  @override
  Future<void> submitRegistration(RestaurantSignupState state) async {
    // Immediate success without delay for fast test execution
  }
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Restaurant Signup Flow - End-to-End & BLoC Navigation Tests', () {
    testWidgets('AccountTypePage -> tapping Restaurant opens Step 1 in RestaurantSignupFlowPage', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const AccountTypePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);

      await tester.tap(find.text('Restaurant'));
      await tester.pumpAndSettle();

      expect(find.text('Account information'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);
    });

    testWidgets('Step navigation without validation blocks: moves smoothly from Step 1 to Step 2', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantStep1Page(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Account information'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);

      // Enter sample test inputs
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Márton');
      await tester.enterText(textFields.at(1), 'a');
      await tester.pumpAndSettle();

      // Tap continue without being blocked by email or password validation
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Advances smoothly to Step 2
      expect(find.text('Restaurant information'), findsOneWidget);
      expect(find.text('Step 2 of 4'), findsOneWidget);
    });

    testWidgets('Complete 4-Step Flow: Forward, Backward, Edit, and Submission Navigation', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fastRepo = FastSuccessMockRestaurantRepository();

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RestaurantSignupFlowPage(repository: fastRepo),
        ),
      );
      await tester.pumpAndSettle();

      // ----------------------------------------
      // STEP 1: Account Information
      // ----------------------------------------
      expect(find.text('Account information'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);

      final step1Fields = find.byType(TextField);
      await tester.enterText(step1Fields.at(0), 'Márton Szabó');
      await tester.enterText(step1Fields.at(1), 'hello@nonnarosa.hu');
      await tester.enterText(step1Fields.at(2), 'Password123');
      await tester.enterText(step1Fields.at(3), 'Password123');
      await tester.pumpAndSettle();

      // Toggle password visibility
      final visibilityIcons = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcons, findsNWidgets(2));
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Continue to Step 2
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // ----------------------------------------
      // STEP 2: Restaurant Information
      // ----------------------------------------
      expect(find.text('Restaurant information'), findsOneWidget);
      expect(find.text('Step 2 of 4'), findsOneWidget);

      // Fill Restaurant name
      final step2Fields = find.byType(TextField);
      await tester.enterText(step2Fields.at(0), 'Trattoria Nonna Rosa');
      await tester.pumpAndSettle();

      // Select Category
      await tester.tap(find.text('Select category'));
      await tester.pumpAndSettle();
      expect(find.text('Italian'), findsOneWidget);
      await tester.tap(find.text('Italian'));
      await tester.pumpAndSettle();
      expect(find.text('Italian'), findsOneWidget);

      // Enter Address
      await tester.enterText(step2Fields.at(1), 'Fő utca 12, Hungary');
      await tester.pumpAndSettle();

      // Set Location on Map
      await tester.tap(find.text('Set location on map'));
      await tester.pumpAndSettle();
      expect(find.text('Location pinned: Fő utca 12, Hungary'), findsOneWidget);

      // Test Backward Navigation from Step 2 -> Step 1
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify Step 1 is active and data persisted
      expect(find.text('Account information'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Márton Szabó'), findsOneWidget);
      expect(find.text('hello@nonnarosa.hu'), findsOneWidget);

      // Return to Step 2
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Restaurant information'), findsOneWidget);
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

      // Continue to Step 3
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // ----------------------------------------
      // STEP 3: Business Information
      // ----------------------------------------
      expect(find.text('Business information'), findsOneWidget);
      expect(find.text('Step 3 of 4'), findsOneWidget);
      expect(find.text('Fields to be confirmed by client'), findsOneWidget);

      // Fill Business Detail
      final step3Field = find.byType(TextField);
      await tester.enterText(step3Field, 'Tax ID: HU12345678, VAT Registered');
      await tester.pumpAndSettle();

      // Upload Supporting Document
      await tester.tap(find.text('Upload a file'));
      await tester.pumpAndSettle();
      expect(find.text('business_license_certificate.pdf'), findsOneWidget);

      // Continue to Step 4
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // ----------------------------------------
      // STEP 4: Review and Submit
      // ----------------------------------------
      expect(find.text('Review and submit'), findsOneWidget);
      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Business information'), findsOneWidget);

      // Verify Review data displayed from BLoC state
      expect(find.text('Márton Szabó'), findsOneWidget);
      expect(find.text('hello@nonnarosa.hu'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
      expect(find.text('Fő utca 12, Hungary'), findsOneWidget);
      expect(find.text('Tax ID: HU12345678, VAT Registered'), findsOneWidget);
      expect(find.text('business_license_certificate.pdf'), findsOneWidget);

      // ----------------------------------------
      // EDIT NAVIGATION FROM REVIEW SCREEN
      // ----------------------------------------
      final editButtons = find.text('Edit');
      expect(editButtons, findsNWidgets(3));

      // Edit Account -> navigates to Step 1
      await tester.tap(editButtons.at(0));
      await tester.pumpAndSettle();
      expect(find.text('Account information'), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Márton Szabó'), findsOneWidget);

      // Navigate back to Step 4
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Review and submit'), findsOneWidget);

      // Edit Restaurant -> navigates to Step 2
      await tester.tap(find.text('Edit').at(1));
      await tester.pumpAndSettle();
      expect(find.text('Restaurant information'), findsOneWidget);
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

      // Return to Step 4
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Review and submit'), findsOneWidget);

      // Edit Business -> navigates to Step 3
      await tester.tap(find.text('Edit').at(2));
      await tester.pumpAndSettle();
      expect(find.text('Business information'), findsOneWidget);
      expect(find.text('Step 3 of 4'), findsOneWidget);
      expect(find.text('Tax ID: HU12345678, VAT Registered'), findsOneWidget);

      // Return to Step 4
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Review and submit'), findsOneWidget);

      // ----------------------------------------
      // SUBMISSION
      // ----------------------------------------
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit application');
      expect(submitButton, findsOneWidget);

      // Submit application
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Navigates to RegistrationPendingPage
      expect(find.text('Application under review'), findsOneWidget);
      expect(find.text('Pending review'), findsOneWidget);
    });

    testWidgets('Submission failure shows error SnackBar and stays on Review step', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final failingRepo = FailingMockRestaurantRepository();

      final completeData = RestaurantRegistrationData(
        ownerName: 'Márton Szabó',
        email: 'hello@nonnarosa.hu',
        password: 'Password123',
        confirmPassword: 'Password123',
        restaurantName: 'Trattoria Nonna Rosa',
        category: 'Italian',
        address: 'Fő utca 12, Hungary',
        locationLabel: 'Fő utca 12, Hungary',
        businessDetail: 'Tax ID: HU12345678',
        uploadedFileName: 'license.pdf',
        agreedToTerms: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RestaurantSignupFlowPage(
            initialStep: 3,
            initialData: completeData,
            repository: failingRepo,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Review and submit'), findsOneWidget);
      expect(find.text('Step 4 of 4'), findsOneWidget);

      final submitButton = find.widgetWithText(ElevatedButton, 'Submit application');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify error SnackBar displayed
      expect(find.textContaining('Network error: Failed to submit registration'), findsOneWidget);
      // Remains on Step 4
      expect(find.text('Review and submit'), findsOneWidget);
    });

    testWidgets('RegistrationPendingPage renders matching reference design and opens details modal', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final data = RestaurantRegistrationData(
        ownerName: 'Márton Szabó',
        email: 'hello@nonnarosa.hu',
        restaurantName: 'Trattoria Nonna Rosa',
        category: 'Italian',
        address: 'Fő utca 12, Hungary',
        businessDetail: 'Business reg 12345',
        uploadedFileName: 'license.pdf',
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RegistrationPendingPage(data: data, autoAdvance: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Application under review'), findsOneWidget);
      expect(
        find.text('Your restaurant application has been submitted and is waiting for review.'),
        findsOneWidget,
      );
      expect(find.text('NR'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Italian · Fő utca 12, Hungary'), findsOneWidget);
      expect(find.text('Pending review'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      // Open submitted details bottom sheet
      await tester.tap(find.text('View submitted details'));
      await tester.pumpAndSettle();

      expect(find.text('Submitted details'), findsOneWidget);
      expect(find.text('Márton Szabó'), findsOneWidget);
      expect(find.text('hello@nonnarosa.hu'), findsWidgets);
      expect(find.text('Business reg 12345'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Submitted details'), findsNothing);
    });

    testWidgets('RegistrationApprovedPage renders properly and navigates to ChoosePlanPage on Continue', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final data = RestaurantRegistrationData(
        ownerName: 'Márton Szabó',
        email: 'hello@nonnarosa.hu',
        restaurantName: 'Trattoria Nonna Rosa',
        category: 'Italian',
        address: 'Fő utca 12, Hungary',
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RegistrationApprovedPage(data: data),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your restaurant is approved'), findsOneWidget);
      expect(
        find.text('Choose a plan to finish setup and start publishing coupons.'),
        findsOneWidget,
      );
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Italian · Fő utca 12, Hungary'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text('Choose a plan'), findsOneWidget);
      expect(find.text('Starter'), findsOneWidget);
      expect(find.text('Growth'), findsOneWidget);
    });

    testWidgets('ChoosePlanPage renders plans, toggles billing interval and selects plan', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: ChoosePlanPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Choose a plan'), findsOneWidget);
      expect(find.text('Pick a plan to publish coupons and reach more guests. You can change it any time.'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Yearly'), findsOneWidget);
      expect(find.text('-15%'), findsOneWidget);

      // Starter card features
      expect(find.text('Starter'), findsOneWidget);
      expect(find.text('9,990'), findsOneWidget);
      expect(find.text('Up to 3 active coupons'), findsOneWidget);

      // Growth card features
      expect(find.text('Growth'), findsOneWidget);
      expect(find.text('MOST POPULAR'), findsOneWidget);
      expect(find.text('19,990'), findsOneWidget);
      expect(find.text('Up to 10 active coupons'), findsOneWidget);

      // Toggle to Yearly
      await tester.tap(find.text('Yearly'));
      await tester.pumpAndSettle();

      // Yearly discounted prices
      expect(find.text('8,490'), findsOneWidget);
      expect(find.text('16,990'), findsOneWidget);

      // Tap Choose plan on Growth
      final growthChooseBtn = find.widgetWithText(ElevatedButton, 'Choose plan');
      expect(growthChooseBtn, findsOneWidget);
      await tester.tap(growthChooseBtn);
      await tester.pumpAndSettle();

      // Bottom sheet: Confirm your plan
      expect(find.text('Confirm your plan'), findsOneWidget);
      expect(find.text('Growth · Yearly'), findsOneWidget);
      expect(find.text('16,990 HUF'), findsOneWidget);
      expect(find.text('Add payment method'), findsOneWidget);
      expect(find.text('Subscribe · 16,990 HUF'), findsOneWidget);

      // Tap Subscribe
      await tester.tap(find.text('Subscribe · 16,990 HUF'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Navigates directly to RestaurantDashboardPage (dashboard.html) without showing dialog
      expect(find.text('Subscription active!'), findsNothing);
      expect(find.text('Good evening'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Redemptions today'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('Quick actions'), findsOneWidget);
      expect(find.text('Recent activity'), findsOneWidget);
      expect(find.text('Growth plan'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage renders exact typography, KPIs, Quick Actions, and Bottom Nav matching dashboard.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RestaurantDashboardPage(
            data: RestaurantRegistrationData(
              restaurantName: 'Trattoria Nonna Rosa',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header verification
      expect(find.text('NR'), findsOneWidget);
      expect(find.text('Good evening'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

      // Hero KPI
      expect(find.text('Redemptions today'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('+5 vs. last Tuesday'), findsOneWidget);
      expect(find.text('Scan QR'), findsWidgets);

      // 2x2 Grid KPIs
      expect(find.text('Active coupons'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('1 ends this week'), findsOneWidget);

      expect(find.text('Points given'), findsOneWidget);
      expect(find.text('720'), findsOneWidget);
      expect(find.text('This week'), findsOneWidget);

      expect(find.text('Giveaway entries'), findsOneWidget);
      expect(find.text('1,248'), findsOneWidget);
      expect(find.text('Draw on 15 Oct'), findsOneWidget);

      expect(find.text('Profile views'), findsOneWidget);
      expect(find.text('2,310'), findsOneWidget);
      expect(find.text('+12% this week'), findsOneWidget);

      // Quick actions
      expect(find.text('Quick actions'), findsOneWidget);
      expect(find.text('Create coupon'), findsOneWidget);
      expect(find.text('Create giveaway'), findsOneWidget);

      // Recent activity
      expect(find.text('Recent activity'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
      expect(find.text('AK'), findsOneWidget);
      expect(find.text('Anna K. redeemed 20%\noff'), findsOneWidget);
      expect(find.text('19:42 · +40 points'), findsOneWidget);
      expect(find.text('Redeemed'), findsOneWidget);
      expect(find.text('BT'), findsOneWidget);
      expect(find.text('Bence T. used Free espresso'), findsOneWidget);
      expect(find.text('18:15 · −150 points'), findsOneWidget);
      expect(find.text('Reward'), findsOneWidget);
      expect(find.text('36 new giveaway entries'), findsOneWidget);
      expect(find.text('Win dinner for two · today'), findsOneWidget);
      expect(find.text('+36'), findsOneWidget);

      // Subscription card
      expect(find.text('Growth plan'), findsOneWidget);
      expect(find.text('Renews 14 Nov 2026 · 4 of 10 coupons used'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);

      // Bottom nav
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Coupons'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Tap Coupons tab in bottom nav -> opens RestaurantCouponsPage
      await tester.tap(find.text('Coupons'));
      await tester.pumpAndSettle();

      expect(find.text('Active · 4'), findsOneWidget);
      expect(find.text('Scheduled · 1'), findsOneWidget);
      expect(find.text('Expired / inactive'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);

      // Tap Dashboard in bottom nav -> returns to RestaurantDashboardPage
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Redemptions today'), findsOneWidget);

      // Tap Active coupons KPI card -> opens RestaurantCouponsPage
      await tester.tap(find.text('Active coupons'));
      await tester.pumpAndSettle();

      expect(find.text('Active · 4'), findsOneWidget);
      expect(find.text('Free tiramisu with any main'), findsOneWidget);
    });

    testWidgets('RestaurantCouponsPage renders exact coupons, tabs, and expired states matching coupons.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantCouponsPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar
      expect(find.text('Coupons'), findsWidgets);
      expect(find.text('Create coupon'), findsOneWidget);

      // Tabs
      expect(find.text('Active · 4'), findsOneWidget);
      expect(find.text('Scheduled · 1'), findsOneWidget);
      expect(find.text('Expired / inactive'), findsOneWidget);

      // Active coupons list
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('1 Oct – 31 Oct · Min. 5,000 HUF'), findsOneWidget);
      expect(find.text('Free tiramisu with any main'), findsOneWidget);
      expect(find.text('Until 31 Oct · One per table'), findsOneWidget);
      expect(find.text('Second Margherita free'), findsOneWidget);
      expect(find.text('Weekends · Sat–Sun'), findsOneWidget);
      expect(find.text('Aperol spritz for 1,500 HUF'), findsOneWidget);
      expect(find.text('Mon–Fri, 16:00–18:00'), findsOneWidget);
      expect(find.text('4 of 10 active coupons on your Growth plan'), findsOneWidget);

      // Switch to Scheduled tab
      await tester.tap(find.text('Scheduled · 1'));
      await tester.pumpAndSettle();

      expect(find.text('Spooky cocktail & dessert combo'), findsOneWidget);
      expect(find.text('Starts 28 Oct · 4 days left'), findsOneWidget);

      // Switch to Expired / inactive tab
      await tester.tap(find.text('Expired / inactive'));
      await tester.pumpAndSettle();

      expect(find.text('Truffle week'), findsOneWidget);
      expect(find.text('Ended 30 Sep 2026'), findsOneWidget);
      expect(find.text('Reuse'), findsOneWidget);

      expect(find.text('Nonna’s off-menu lasagne'), findsOneWidget);
      expect(find.text('Deactivated 12 Sep 2026'), findsOneWidget);
      expect(find.text('Activate'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage renders exact profile header, sections, and nav matching account.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Profile in bottom nav
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Header and Identity
      expect(find.text('Profile'), findsWidgets);
      expect(find.text('NR'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('· Growth plan'), findsOneWidget);

      // Section: Restaurant
      expect(find.text('RESTAURANT'), findsOneWidget);
      expect(find.text('Restaurant profile'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);

      // Section: Business
      expect(find.text('BUSINESS'), findsOneWidget);
      expect(find.text('Subscription'), findsOneWidget);
      expect(find.text('Growth'), findsOneWidget);
      expect(find.text('Statistics'), findsOneWidget);

      // Section: Engagement
      expect(find.text('ENGAGEMENT'), findsOneWidget);
      expect(find.text('Loyalty'), findsOneWidget);
      expect(find.text('Giveaways'), findsOneWidget);
      expect(find.text('1 active'), findsOneWidget);

      // Section: Account
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Tap Dashboard in bottom nav -> returns to RestaurantDashboardPage
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Redemptions today'), findsOneWidget);
    });

    testWidgets('RestaurantCouponFormPage renders all 6 sections and handles coupon creation matching coupon-form.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantCouponsPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "+ Create coupon" in top bar
      final createCouponBtn = find.text('Create coupon');
      expect(createCouponBtn, findsOneWidget);
      await tester.tap(createCouponBtn);
      await tester.pumpAndSettle();

      // Title & Back Button
      expect(find.text('Create coupon'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Section 1: Coupon type
      expect(find.text('Coupon type'), findsOneWidget);
      expect(find.text('Percentage'), findsOneWidget);
      expect(find.text('Fixed value'), findsOneWidget);
      expect(find.text('Gift item'), findsOneWidget);
      expect(find.text('1+1'), findsOneWidget);
      expect(find.text('Menu deal'), findsOneWidget);
      expect(find.text('Flash sale'), findsOneWidget);
      expect(find.text('Seasonal'), findsOneWidget);
      expect(find.text('First-time'), findsOneWidget);
      expect(find.text('Happy hour'), findsOneWidget);
      expect(find.text('Secret menu'), findsOneWidget);

      // Section 2: Details
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Coupon title'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsWidgets);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Get 20% off the food on your bill when you dine in.'), findsOneWidget);
      expect(find.text('Discount'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);

      // Section 3: Validity
      expect(find.text('Validity'), findsOneWidget);
      expect(find.text('Start date'), findsOneWidget);
      expect(find.text('1 Oct 2026'), findsOneWidget);
      expect(find.text('End date'), findsOneWidget);
      expect(find.text('31 Oct 2026'), findsOneWidget);
      expect(find.text('Available days'), findsOneWidget);
      expect(find.text('From'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('Until'), findsOneWidget);
      expect(find.text('22:00'), findsOneWidget);

      // Section 4: Rules
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Minimum purchase'), findsOneWidget);
      expect(find.text('HUF'), findsOneWidget);
      expect(find.text('Uses per customer'), findsOneWidget);
      expect(find.text('Total redemptions'), findsOneWidget);
      expect(find.text('Unlimited'), findsOneWidget);
      expect(find.text('First-time guests only'), findsOneWidget);
      expect(find.text('Terms and conditions'), findsOneWidget);

      // Section 5: Loyalty
      expect(find.text('Loyalty'), findsOneWidget);
      expect(find.text('Points after redemption'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);

      // Section 6: Status & preview
      expect(find.text('Status & preview'), findsOneWidget);
      expect(find.text('Publish as active'), findsOneWidget);
      expect(find.text('CUSTOMER PREVIEW'), findsOneWidget);
      expect(find.text('20%'), findsWidgets);
      expect(find.text('OFF'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

      // Sticky CTA
      final publishBtn = find.text('Publish coupon');
      expect(publishBtn, findsOneWidget);

      // Tap Publish coupon -> navigates directly to coupon detail page
      await tester.tap(publishBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RestaurantCouponDetailPage), findsOneWidget);
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Deactivate coupon'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage "Create coupon" quick action opens RestaurantCouponFormPage', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Quick action "Create coupon"
      final quickActionCoupon = find.text('Create coupon');
      expect(quickActionCoupon, findsOneWidget);
      await tester.tap(quickActionCoupon);
      await tester.pumpAndSettle();

      expect(find.text('Publish coupon'), findsOneWidget);
      expect(find.text('Coupon type'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage Quick Actions render without text clipping or overflow across devices and text scales', (tester) async {
      tester.view.physicalSize = const Size(360 * 2, 740 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: const RestaurantDashboardPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Scan QR'), findsNWidgets(2));
      expect(find.text('Create coupon'), findsOneWidget);
      expect(find.text('Create giveaway'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('RestaurantCouponFormPage Customer preview ticket does not overflow with large text scale', (tester) async {
      tester.view.physicalSize = const Size(360 * 2, 740 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: const RestaurantCouponFormPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CUSTOMER PREVIEW'), findsOneWidget);
      expect(find.text('20%'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    });

    testWidgets('RestaurantCouponFormPage typing and selecting coupon type dynamically updates textfields and customer preview', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantCouponFormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on '1+1' coupon type
      await tester.tap(find.text('1+1'));
      await tester.pumpAndSettle();

      // Text fields must now match 1+1 template
      expect(find.text('Second Margherita free'), findsWidgets);
      expect(find.text('Buy one Margherita pizza, get the second one free.'), findsOneWidget);
      expect(find.text('BUY ONE, GET ONE'), findsOneWidget);
      expect(find.text('DEAL'), findsOneWidget);

      // Now edit the title
      await tester.enterText(find.widgetWithText(TextField, 'Second Margherita free'), 'Buy 1 Pasta Get 1 Free');
      await tester.pumpAndSettle();

      // Preview ticket updates live
      expect(find.text('Buy 1 Pasta Get 1 Free'), findsWidgets);
    });

    testWidgets('RestaurantCouponDetailPage renders all components and toggles deactivation matching coupon-detail.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantCouponDetailPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar
      expect(find.text('20% off your bill'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);

      // Hero performance card
      expect(find.text('Percentage discount'), findsOneWidget);
      expect(find.text('20% OFF'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('Active · 1 Oct – 31 Oct 2026'), findsOneWidget);

      // Stat grid
      expect(find.text('Views'), findsOneWidget);
      expect(find.text('3,480'), findsOneWidget);
      expect(find.text('+18%'), findsOneWidget);
      expect(find.text('Redemptions'), findsOneWidget);
      expect(find.text('142'), findsOneWidget);
      expect(find.text('+9%'), findsOneWidget);
      expect(find.text('Redemption rate'), findsOneWidget);
      expect(find.text('4.1%'), findsOneWidget);
      expect(find.text('Repeat guests'), findsOneWidget);
      expect(find.text('38'), findsOneWidget);

      // Rules card
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Minimum spend 5,000 HUF'), findsOneWidget);
      expect(find.text('Mon–Sun, 12:00–22:00'), findsOneWidget);
      expect(find.text('Once per customer'), findsOneWidget);
      expect(find.text('+40 loyalty points'), findsOneWidget);

      // Recent redemptions
      expect(find.text('Recent redemptions'), findsOneWidget);
      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('Zsófia B.'), findsOneWidget);
      expect(find.text('Dávid M.'), findsOneWidget);

      // Deactivate coupon button
      final deactivateBtn = find.text('Deactivate coupon');
      expect(deactivateBtn, findsOneWidget);

      // Tap Deactivate
      await tester.tap(deactivateBtn);
      await tester.pumpAndSettle();

      expect(find.text('Coupon deactivated successfully'), findsOneWidget);
      expect(find.text('Activate coupon'), findsOneWidget);
      expect(find.text('Inactive · 1 Oct – 31 Oct 2026'), findsOneWidget);
    });

    testWidgets('RestaurantScannerPage renders viewfinder, top bar, flash, enter code matching scanner.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantScannerPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Scan coupon'), findsOneWidget);
      expect(find.text('Scan the customer’s Rivjuuu QR code'), findsOneWidget);
      expect(find.text('Check the order meets the coupon conditions before scanning.'), findsOneWidget);
      expect(find.text('Flash'), findsOneWidget);
      expect(find.text('Enter code'), findsOneWidget);

      // Tap Flash
      await tester.tap(find.text('Flash'));
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Enter Code to open bottom sheet
      await tester.tap(find.text('Enter code'));
      await tester.pumpAndSettle();

      expect(find.text('Enter coupon code'), findsOneWidget);
      expect(find.text('Check coupon'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage Quick action Scan QR and bottom nav Scan navigate to RestaurantScannerPage', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantDashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Hero button "Scan QR"
      final heroScanBtn = find.widgetWithText(ElevatedButton, 'Scan QR');
      expect(heroScanBtn, findsOneWidget);
      await tester.tap(heroScanBtn);
      await tester.pumpAndSettle();

      // Should now be on RestaurantScannerPage
      expect(find.text('Scan coupon'), findsOneWidget);
      expect(find.text('Scan the customer’s Rivjuuu QR code'), findsOneWidget);

      // Close scanner
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Back on dashboard
      expect(find.text('Quick actions'), findsOneWidget);

      // Tap bottom nav "Scan" button
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();

      expect(find.text('Scan coupon'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Quick actions'), findsOneWidget);
    });

    testWidgets('RestaurantScanResultPage renders valid coupon details and confirms redemption matching scan-valid.html and scan-success.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantScanResultPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Scan result'), findsOneWidget);
      expect(find.text('Valid coupon'), findsOneWidget);
      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('5,000 HUF'), findsOneWidget);
      expect(find.text('+40 points'), findsOneWidget);
      expect(find.text('Before you confirm'), findsOneWidget);
      expect(find.text('Confirm redemption'), findsOneWidget);

      // Tap Confirm redemption
      await tester.tap(find.text('Confirm redemption'));
      await tester.pumpAndSettle();

      // Should transition to Coupon redeemed success view
      expect(find.text('Coupon redeemed'), findsOneWidget);
      expect(find.text('The guest’s coupon is used and their points are added.'), findsOneWidget);
      expect(find.text('Scan next'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Menu row navigates to RestaurantMenuManagePage', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Profile header & Restaurant section
      expect(find.text('Restaurant profile'), findsOneWidget);
      final menuRow = find.text('Menu');
      expect(menuRow, findsOneWidget);

      // Tap Menu row
      await tester.tap(menuRow);
      await tester.pumpAndSettle();

      // Verify RestaurantMenuManagePage opens matching menu-manage.html
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Menu items'), findsOneWidget);
      expect(find.text('Photos & PDF'), findsOneWidget);

      // Categories and items
      expect(find.text('Main dishes'), findsOneWidget);
      expect(find.text('3 items'), findsOneWidget);
      expect(find.text('Cacio e pepe'), findsOneWidget);
      expect(find.text('3,900 HUF'), findsOneWidget);
      expect(find.text('Penne all’arrabbiata'), findsOneWidget);
      expect(find.text('Margherita'), findsOneWidget);

      expect(find.text('Desserts'), findsOneWidget);
      expect(find.text('Tiramisu della Nonna'), findsOneWidget);
      expect(find.text('1,900 HUF'), findsOneWidget);

      expect(find.text('Drinks'), findsOneWidget);
      expect(find.text('House lemonade'), findsOneWidget);
      expect(find.text('1,200 HUF'), findsOneWidget);

      expect(find.text('Add category'), findsOneWidget);
      expect(find.text('Menu photos & PDF'), findsOneWidget);
      expect(find.text('Full menu, autumn 2026'), findsOneWidget);
      expect(find.text('Menu page 1'), findsOneWidget);
      expect(find.text('Upload menu photos or PDF'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Should be back on Profile page
      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantMenuManagePage handles adding item and category matching menu-manage.html', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantMenuManagePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify chips interaction
      await tester.tap(find.text('Photos & PDF'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Menu items'));
      await tester.pumpAndSettle();

      // Tap "+" top bar button to open Add menu item sheet
      await tester.tap(find.byIcon(Icons.add_rounded).first);
      await tester.pumpAndSettle();

      expect(find.text('Add menu item'), findsOneWidget);
      expect(find.text('Item name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Price (HUF)'), findsOneWidget);

      // Enter new item
      await tester.enterText(find.widgetWithText(TextField, 'e.g. Cacio e pepe'), 'Truffle Tagliatelle');
      await tester.enterText(find.widgetWithText(TextField, 'e.g. Tonnarelli, pecorino romano, black pepper'), 'Fresh black truffle, butter, parmesan');
      await tester.enterText(find.widgetWithText(TextField, 'e.g. 3,900'), '4,800');

      // Tap Add item button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add item'));
      await tester.pumpAndSettle();

      // Item should now appear under Main dishes
      expect(find.text('Truffle Tagliatelle'), findsOneWidget);
      expect(find.text('4,800 HUF'), findsOneWidget);
      expect(find.text('4 items'), findsOneWidget);

      // Tap "Add category" button
      await tester.tap(find.text('Add category'));
      await tester.pumpAndSettle();

      expect(find.text('Category name'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'e.g. Appetizers, Starters, Wines'), 'Antipasti');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create category'));
      await tester.pumpAndSettle();

      expect(find.text('Antipasti'), findsOneWidget);
      expect(find.text('0 items'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Subscription row navigates to RestaurantSubscriptionPage and toggles plan', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find Subscription row and tap
      final subRow = find.text('Subscription');
      expect(subRow, findsOneWidget);
      await tester.tap(subRow);
      await tester.pumpAndSettle();

      // Verify RestaurantSubscriptionPage content matching subscription.html
      expect(find.text('Current plan'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Growth'), findsWidgets);
      expect(find.text('19,990'), findsWidgets);
      expect(find.text('HUF / month'), findsOneWidget);
      expect(find.text('Included'), findsOneWidget);
      expect(find.text('Up to 10 active coupons'), findsOneWidget);
      expect(find.text('2 giveaways per month'), findsOneWidget);
      expect(find.text('Highlighted in your category'), findsOneWidget);
      expect(find.text('Full statistics'), findsOneWidget);
      expect(find.text('Billing'), findsOneWidget);
      expect(find.text('Payment method'), findsOneWidget);
      expect(find.text('•••• 4242 (Mastercard)'), findsOneWidget);
      expect(find.text('Last payment 14 Oct 2026'), findsOneWidget);
      expect(find.text('Change plan'), findsOneWidget);
      expect(find.text('Cancel subscription'), findsOneWidget);

      // Tap Change plan button to open sheet matching subscription-change.html
      await tester.tap(find.text('Change plan'));
      await tester.pumpAndSettle();

      expect(find.text('Starter · 9,990 HUF'), findsOneWidget);
      expect(find.text('Growth · 19,990 HUF'), findsOneWidget);
      expect(find.text('Pro · 34,990 HUF'), findsOneWidget);

      // Select Pro plan and confirm
      await tester.tap(find.text('Pro · 34,990 HUF'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm change'));
      await tester.pumpAndSettle();

      // Should now show Pro plan and 34,990
      expect(find.text('Pro'), findsOneWidget);
      expect(find.text('34,990'), findsWidgets);

      // Back navigation
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Statistics row navigates to RestaurantStatisticsPage and filters', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find Statistics row and tap
      final statsRow = find.text('Statistics');
      expect(statsRow, findsOneWidget);
      await tester.tap(statsRow);
      await tester.pumpAndSettle();

      // Verify RestaurantStatisticsPage content matching statistics.html
      expect(find.text('7 days'), findsOneWidget);
      expect(find.text('30 days'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);

      // 4 KPIs
      expect(find.text('Profile views'), findsOneWidget);
      expect(find.text('9,840'), findsOneWidget);
      expect(find.text('+12%'), findsOneWidget);

      expect(find.text('Redemptions'), findsWidgets);
      expect(find.text('317'), findsOneWidget);
      expect(find.text('+9%'), findsOneWidget);

      expect(find.text('Repeat customers'), findsOneWidget);
      expect(find.text('37%'), findsOneWidget);
      expect(find.text('−2 pts'), findsOneWidget);

      expect(find.text('Points earned / used'), findsOneWidget);
      expect(find.text('12.5k / 4.4k'), findsOneWidget);
      expect(find.text('loyalty'), findsOneWidget);

      // Weekly chart
      expect(find.text('Last 4 weeks'), findsOneWidget);

      // Coupon performance ranking
      expect(find.text('Coupon performance'), findsOneWidget);
      expect(find.text('20% off your whole bill'), findsOneWidget);
      expect(find.text('142'), findsOneWidget);
      expect(find.text('4.1% rate'), findsOneWidget);
      expect(find.text('Free tiramisu with any main'), findsOneWidget);
      expect(find.text('88'), findsOneWidget);
      expect(find.text('Second Margherita free'), findsOneWidget);
      expect(find.text('51'), findsOneWidget);
      expect(find.text('Aperol spritz for 1,500 HUF'), findsOneWidget);
      expect(find.text('36'), findsOneWidget);

      // Tap 7 days filter chip
      await tester.tap(find.text('7 days'));
      await tester.pumpAndSettle();

      // Values update dynamically
      expect(find.text('2,310'), findsOneWidget);
      expect(find.text('84'), findsOneWidget);
      expect(find.text('41%'), findsOneWidget);

      // Back navigation
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Loyalty row navigates to RestaurantLoyaltyPage and opens activity & add sheets', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Loyalty row in Engagement section
      final loyaltyRow = find.text('Loyalty');
      expect(loyaltyRow, findsOneWidget);
      await tester.tap(loyaltyRow);
      await tester.pumpAndSettle();

      // RestaurantLoyaltyPage rendered
      expect(find.text('Points awarded'), findsOneWidget);
      expect(find.text('12,480'), findsOneWidget);
      expect(find.text('Last 30 days'), findsOneWidget);
      expect(find.text('Points redeemed'), findsOneWidget);
      expect(find.text('4,350'), findsOneWidget);
      expect(find.text('29 rewards used'), findsOneWidget);

      expect(find.text('Earning rules'), findsOneWidget);
      expect(find.text('Points are set per coupon'), findsOneWidget);
      expect(find.text('Points can only be used at Trattoria Nonna Rosa'), findsOneWidget);

      expect(find.text('Rewards'), findsOneWidget);
      expect(find.text('Free espresso'), findsOneWidget);
      expect(find.text('150 points · 21 redeemed'), findsOneWidget);
      expect(find.text('Free dessert'), findsOneWidget);
      expect(find.text('400 points · 8 redeemed'), findsOneWidget);
      expect(find.text('10% bonus on your bill'), findsOneWidget);
      expect(find.text('700 points · 0 redeemed'), findsOneWidget);

      // Tap View loyalty activity button
      final activityBtn = find.text('View loyalty activity');
      expect(activityBtn, findsOneWidget);
      await tester.tap(activityBtn);
      await tester.pumpAndSettle();

      // Navigated to Activity screen in dashboard bottom nav
      expect(find.text('Activity'), findsWidgets);
      expect(find.text('Earned'), findsWidgets);
      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('Bence T.'), findsOneWidget);

      // Navigate back to Profile tab -> Loyalty
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Loyalty'));
      await tester.pumpAndSettle();

      // Tap Add reward header button
      final addRewardBtn = find.text('Add reward');
      expect(addRewardBtn, findsOneWidget);
      await tester.tap(addRewardBtn);
      await tester.pumpAndSettle();

      // Add reward page opened
      expect(find.text('Reward title'), findsOneWidget);
      expect(find.text('Points required'), findsOneWidget);
      expect(find.text('CUSTOMER PREVIEW'), findsOneWidget);

      // Close add reward page
      final addRewardBack = find.byIcon(LucideIcons.arrowLeft);
      if (addRewardBack.evaluate().isNotEmpty) {
        await tester.tap(addRewardBack.last);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
      }
      await tester.pumpAndSettle();

      // Back navigation to Account
      final loyaltyBack = find.byIcon(LucideIcons.arrowLeft);
      if (loyaltyBack.evaluate().isNotEmpty) {
        await tester.tap(loyaltyBack.first);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      }
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Giveaways row navigates to RestaurantGiveawaysPage, switches tabs and opens detail sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Giveaways row in Engagement section
      final giveawaysRow = find.text('Giveaways');
      expect(giveawaysRow, findsOneWidget);
      await tester.tap(giveawaysRow);
      await tester.pumpAndSettle();

      // RestaurantGiveawaysPage rendered with tabs
      expect(find.text('Active · 1'), findsOneWidget);
      expect(find.text('Scheduled · 1'), findsOneWidget);
      expect(find.text('Completed · 4'), findsOneWidget);

      // Active giveaway card
      expect(find.text('Win dinner for two'), findsOneWidget);
      expect(find.text('15,000 HUF dinner coupon'), findsOneWidget);
      expect(find.text('1–14 Oct'), findsOneWidget);
      expect(find.text('1,248 joined'), findsOneWidget);
      expect(find.text('3 winners'), findsOneWidget);

      // Tap giveaway card to open Giveaway Details
      await tester.tap(find.text('Win dinner for two'));
      await tester.pumpAndSettle();

      expect(find.text('Entries'), findsOneWidget);
      expect(find.text('Winners'), findsOneWidget);
      expect(find.text('Ends'), findsOneWidget);
      expect(find.text('Draw winners'), findsOneWidget);
      expect(find.text('End giveaway early'), findsOneWidget);

      // Close details sheet
      final detailsBack = find.byIcon(LucideIcons.arrowLeft);
      if (detailsBack.evaluate().isNotEmpty) {
        await tester.tap(detailsBack.last);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
      }
      await tester.pumpAndSettle();

      // Switch to Scheduled tab
      await tester.tap(find.text('Scheduled · 1'));
      await tester.pumpAndSettle();

      expect(find.text('Weekend Brunch Voucher'), findsOneWidget);
      expect(find.text('Free 2x Brunch Combo'), findsOneWidget);

      // Switch to Completed tab
      await tester.tap(find.text('Completed · 4'));
      await tester.pumpAndSettle();

      expect(find.text('Summer Pizza Feast'), findsOneWidget);

      // Tap Create giveaway button
      final createGiveawayBtn = find.text('Create giveaway');
      expect(createGiveawayBtn, findsOneWidget);
      await tester.tap(createGiveawayBtn);
      await tester.pumpAndSettle();

      expect(find.text('Basics'), findsOneWidget);
      expect(find.text('Prize'), findsWidgets);
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Timing & winners'), findsOneWidget);
      expect(find.text('Publish giveaway'), findsOneWidget);

      // Close create giveaway full screen page
      final createGiveawayBack = find.byIcon(LucideIcons.arrowLeft);
      if (createGiveawayBack.evaluate().isNotEmpty) {
        await tester.tap(createGiveawayBack.last);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
      }
      await tester.pumpAndSettle();

      // Back navigation to Account
      final giveawaysBack = find.byIcon(LucideIcons.arrowLeft);
      if (giveawaysBack.evaluate().isNotEmpty) {
        await tester.tap(giveawaysBack.first);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      }
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Settings row navigates to RestaurantSettingsPage and opens sheets', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Settings row in Account section
      final settingsRow = find.text('Settings');
      expect(settingsRow, findsOneWidget);
      await tester.tap(settingsRow);
      await tester.pumpAndSettle();

      // RestaurantSettingsPage rendered
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('NOTIFICATION PREFERENCES'), findsOneWidget);
      expect(find.text('Coupon redemptions'), findsOneWidget);
      expect(find.text('Giveaway updates'), findsOneWidget);
      expect(find.text('Loyalty rewards'), findsOneWidget);
      expect(find.text('Subscription & billing'), findsOneWidget);
      expect(find.text('SUPPORT & LEGAL'), findsOneWidget);
      expect(find.text('Help & contact support'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms and Conditions'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      // Open Change password sheet
      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();
      expect(find.text('Current password'), findsOneWidget);
      expect(find.text('New password'), findsOneWidget);
      expect(find.text('Confirm new password'), findsOneWidget);
      expect(find.text('Update password'), findsOneWidget);

      // Close Change password sheet
      final closePass = find.byIcon(LucideIcons.x);
      if (closePass.evaluate().isNotEmpty) {
        await tester.tap(closePass);
      } else {
        await tester.tap(find.byIcon(Icons.close_rounded));
      }
      await tester.pumpAndSettle();

      // Open Language sheet
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      expect(find.text('English'), findsWidgets);
      expect(find.text('Hungarian'), findsOneWidget);
      expect(find.text('Changes apply straight away.'), findsOneWidget);

      // Select Hungarian
      await tester.tap(find.text('Hungarian'));
      await tester.pumpAndSettle();

      // Language is now Hungarian
      expect(find.text('Hungarian'), findsOneWidget);

      // Back navigation to Account
      final settingsBack = find.byIcon(LucideIcons.arrowLeft);
      if (settingsBack.evaluate().isNotEmpty) {
        await tester.tap(settingsBack);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      }
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });

    testWidgets('RestaurantAccountPage tapping Restaurant profile row navigates to RestaurantProfileManagePage and opens edit sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const RestaurantAccountPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify "Restaurant profile" row is present with "85%"
      expect(find.text('Restaurant profile'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);

      // Tap Restaurant profile
      await tester.tap(find.text('Restaurant profile'));
      await tester.pumpAndSettle();

      // Verify RestaurantProfileManagePage renders
      expect(find.text('Restaurant profile'), findsOneWidget);
      expect(find.text('Change cover'), findsOneWidget);
      expect(find.text('Profile completeness'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
      expect(find.text('Basic information'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsWidgets);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Fő utca 12, Hungary'), findsOneWidget);
      expect(find.text('Images'), findsOneWidget);
      expect(find.text('View as customer'), findsOneWidget);

      // Tap "Edit" on Basic information
      final editButtons = find.text('Edit');
      expect(editButtons, findsWidgets);
      await tester.tap(editButtons.first);
      await tester.pumpAndSettle();

      // Verify bottom sheet opened
      expect(find.text('Save changes'), findsOneWidget);

      // Close bottom sheet
      final editClose = find.byIcon(LucideIcons.x);
      if (editClose.evaluate().isNotEmpty) {
        await tester.tap(editClose);
      } else {
        await tester.tap(find.byIcon(Icons.close_rounded));
      }
      await tester.pumpAndSettle();

      // Back navigation to Account
      final manageBack = find.byIcon(LucideIcons.arrowLeft);
      if (manageBack.evaluate().isNotEmpty) {
        await tester.tap(manageBack);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      }
      await tester.pumpAndSettle();

      expect(find.text('Restaurant profile'), findsOneWidget);
    });
  });
}
