import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/home/view/home_page.dart';
import 'package:rivjuuu/features/profile/view/edit_profile_view.dart';
import 'package:rivjuuu/features/profile/view/profile_page.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ProfilePage renders matching profile.html reference design',
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

    // 1. Top Bar & Bottom Bar
    expect(find.text('Profile'), findsWidgets);
    expect(find.byIcon(Icons.notifications_none_rounded), findsWidgets);

    // 2. Profile Header
    expect(find.text('MS'), findsOneWidget);
    expect(find.text('Márk Szilágyi'), findsOneWidget);
    expect(find.text('mark.szilagyi@example.com'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    // 3. My activity Group
    expect(find.text('MY ACTIVITY'), findsOneWidget);
    expect(find.text('Coupon history'), findsOneWidget);
    expect(find.text('My rewards'), findsOneWidget);
    expect(find.text('My giveaways'), findsOneWidget);
    expect(find.text('My reviews'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('Favorite restaurants'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Favorite coupons'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // Scroll to see Social and Account groups
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // 4. Social Group
    expect(find.text('SOCIAL'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('32'), findsOneWidget);
    expect(find.text('Friend requests'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // 5. Account Group
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets(
      'EditProfilePage renders matching edit-profile.html and saves changes',
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

    // Tap "Edit" to navigate to EditProfilePage
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileView), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('mark.szilagyi@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.text('Save changes'), findsOneWidget);

    // Edit full name
    await tester.enterText(find.byType(TextField), 'Márk Updated');
    await tester.tap(find.text('Save changes'));
    await tester.pump();

    // Verify "Profile updated" toast (edit-profile-saved.html)
    expect(find.text('Profile updated'), findsWidgets);
    await tester.pumpAndSettle();

    // Verified navigated back to ProfilePage with updated name
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Márk Updated'), findsOneWidget);
  });

  testWidgets('Home bottom bar Profile tab navigates to ProfilePage',
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

    // Tap Profile in bottom navigation bar
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('MY ACTIVITY'), findsOneWidget);
  });

  testWidgets('Coupon history page renders and filters coupons',
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

    await tester.tap(find.text('Coupon history'));
    await tester.pumpAndSettle();

    expect(find.text('Coupon history'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Redeemed'), findsWidgets);
    expect(find.text('Expired'), findsWidgets);

    // Filter to Redeemed
    await tester.tap(find.text('Redeemed').first);
    await tester.pumpAndSettle();
    expect(find.text('20% OFF'), findsOneWidget);

    // Filter to Expired
    await tester.tap(find.text('Expired').first);
    await tester.pumpAndSettle();
    expect(find.text('15% OFF'), findsOneWidget);
  });

  testWidgets('My giveaways page renders tabs and prize coupon',
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

    await tester.tap(find.text('My giveaways'));
    await tester.pumpAndSettle();

    expect(find.text('My giveaways'), findsOneWidget);
    expect(find.text('Joined'), findsWidgets);
    expect(find.text('Won'), findsOneWidget);
    expect(find.text('Ended'), findsWidgets);

    // Switch to Won tab
    await tester.tap(find.text('Won'));
    await tester.pumpAndSettle();
    expect(find.text('You won'), findsOneWidget);
    expect(find.text('Pizza night for four'), findsOneWidget);
    expect(find.text('View prize coupon'), findsOneWidget);

    // Tap View prize coupon
    await tester.tap(find.text('View prize coupon'));
    await tester.pumpAndSettle();
    expect(find.text('Redeem coupon'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Tap Done
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('My giveaways'), findsOneWidget);
  });

  testWidgets('Review detail page renders full review and thumbnails',
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

    await tester.tap(find.text('My reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('Anna Kovács'), findsOneWidget);
    expect(find.text('8.9'), findsOneWidget);
    expect(find.textContaining('cacio e pepe'), findsOneWidget);
  });

  testWidgets('Favorite restaurants and Favorite coupons render correctly',
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

    // Favorite restaurants
    await tester.tap(find.text('Favorite restaurants'));
    await tester.pumpAndSettle();
    expect(find.text('Favorite restaurants'), findsOneWidget);
    expect(find.text('5 restaurants'), findsOneWidget);
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

    // Back to Profile
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Favorite coupons
    await tester.ensureVisible(find.text('Favorite coupons'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorite coupons'));
    await tester.pumpAndSettle();
    expect(find.text('Favorite coupons'), findsOneWidget);
    expect(find.text('3 saved coupons'), findsOneWidget);
    expect(find.text('20% off your whole bill'), findsOneWidget);
  });

  testWidgets('Friends and Friend requests pages render and handle actions',
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

    // Scroll down to Social section
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap Friends
    await tester.tap(find.text('Friends'));
    await tester.pumpAndSettle();
    expect(find.text('Anna Kovács'), findsOneWidget);
    expect(find.text('Bence Tóth'), findsOneWidget);

    // Switch to Requests
    await tester.tap(find.textContaining('Requests'));
    await tester.pumpAndSettle();
    expect(find.text('Péter Nagy'), findsOneWidget);
    expect(find.text('Accept'), findsWidgets);
    expect(find.text('Decline'), findsWidgets);

    // Accept Peter Nagy
    await tester.tap(find.text('Accept').first);
    await tester.pump();
    expect(find.text('Accepted Péter Nagy'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Notifications and Settings pages render correctly',
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

    // Tap Notifications Bell at top
    await tester.tap(find.byIcon(Icons.notifications_none_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('Mark all read'), findsOneWidget);
    expect(find.text('You won a giveaway'), findsOneWidget);

    // Mark all read
    await tester.tap(find.text('Mark all read'));
    await tester.pump();
    expect(find.text('All notifications marked as read'), findsOneWidget);
    await tester.pumpAndSettle();

    // Back to Profile
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Scroll to Account section
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('Log out'), findsOneWidget);

    // Tap Log out to show confirmation dialog
    await tester.ensureVisible(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to log out of Rivjuuu?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'ProfilePage displays logged-in user details (displayName, email, initials)',
      (WidgetTester tester) async {
    TokenStorageService.resetForTesting();
    SharedPreferences.setMockInitialValues({
      'auth_access_token': 'test_token',
      'auth_user_display_name': 'Keshav Dev',
      'auth_user_email': 'keshavdev1@yopmail.com',
      'auth_user_first_name': 'Keshav',
      'auth_user_last_name': 'Dev',
    });

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

    // Verify logged-in user name, email, and dynamic initials
    expect(find.text('Keshav Dev'), findsOneWidget);
    expect(find.text('keshavdev1@yopmail.com'), findsOneWidget);
    expect(find.text('KD'), findsOneWidget);
  });

  testWidgets(
      'ProfilePage resolves name from firstName & lastName when displayName is absent',
      (WidgetTester tester) async {
    TokenStorageService.resetForTesting();
    SharedPreferences.setMockInitialValues({
      'auth_access_token': 'test_token',
      'auth_user_email': 'keshavhardik@yopmail.com',
      'auth_user_first_name': 'Keshav',
      'auth_user_last_name': 'Hardik',
    });

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

    // Verify resolved full name, email, and dynamic initials
    expect(find.text('Keshav Hardik'), findsOneWidget);
    expect(find.text('keshavhardik@yopmail.com'), findsOneWidget);
    expect(find.text('KH'), findsOneWidget);
  });
}
