import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/app.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/data/models/auth/login_request.dart';
import 'package:rivjuuu/data/models/auth/login_response.dart';
import 'package:rivjuuu/data/repositories/auth/login_repository.dart';
import 'package:rivjuuu/features/auth/bloc/login_bloc.dart';
import 'package:rivjuuu/features/auth/view/account_type_page.dart';
import 'package:rivjuuu/features/auth/view/customer_signup_page.dart';
import 'package:rivjuuu/features/auth/view/new_password_page.dart';
import 'package:rivjuuu/features/permissions/view/notification_permission_page.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestFakeLoginRepository implements LoginRepository {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return const LoginResponse(
      success: 1,
      message: 'Login successful',
      accessToken: 'mock_token',
      refreshToken: 'mock_refresh_token',
      role: 'CUSTOMER',
      user: LoginUser(
        id: 'mock_user_id',
        email: 'test@example.com',
        role: 'CUSTOMER',
        status: 'ACTIVE',
      ),
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TokenStorageService.resetForTesting();
    LoginBloc.defaultRepository = _TestFakeLoginRepository();
  });

  tearDown(() {
    LoginBloc.defaultRepository = null;
  });

  testWidgets('Complete flow: Splash -> Language -> Login -> Home', (WidgetTester tester) async {
    // 1. Launch App -> Shows Splash Screen
    await tester.pumpWidget(const RivjuuuApp());
    expect(find.text('Good Food\nMore Rewards'), findsOneWidget);

    // 2. Advance time past splash timer (2.6s) + transition animation (500ms)
    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();

    // 3. Verify Language Screen is now shown
    expect(find.text('Choose language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Hungarian'), findsOneWidget);

    // 4. Tap Continue button -> Should navigate to Login Screen
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 5. Verify Login Screen
    expect(find.text('Welcome to Rivjuuu'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    // 6. Enter credentials and tap Log in -> navigates to Customer Home Screen
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // 7. Verify Home Screen loaded properly
    expect(find.text('Current location'), findsOneWidget);
    expect(find.text('City centre'), findsOneWidget);
    expect(find.text('Search restaurants'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Nearby restaurants'), findsOneWidget);
    expect(find.text('Hot offers'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Giveaways'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    // 8. Tap Explore -> Navigates to Categories / Explore Screen (categories.html)
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Italian'), findsOneWidget);

    // 9. Tap Italian -> Navigates to Restaurant List Screen
    await tester.tap(find.text('Italian'));
    await tester.pumpAndSettle();

    // Verify Restaurant List Screen
    expect(find.text('Italian restaurants'), findsOneWidget);
    expect(find.text('18 restaurants'), findsOneWidget);
    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Has coupons'), findsOneWidget);
    expect(find.text('Open now'), findsOneWidget);
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('Pizzeria Forno'), findsOneWidget);
    expect(find.text('Pasta & Pizza Lab'), findsOneWidget);

    // Scroll to reveal subsequent items
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Dolce Vita Bistro'), findsOneWidget);
  });

  testWidgets('AccountTypePage renders with no overflow on small screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountTypePage(),
      ),
    );

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
  });

  testWidgets('CustomerSignUpPage renders cleanly matching reference design', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomerSignUpPage(),
      ),
    );

    expect(find.text('Create account'), findsWidgets);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('SearchPage renders matching design with recent searches, categories, and suggested', (WidgetTester tester) async {
    await tester.pumpWidget(const RivjuuuApp());
    // Advance past splash
    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();

    // From Language -> Login -> Home
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // Tap Search bar on Home
    await tester.tap(find.text('Search restaurants'));
    await tester.pumpAndSettle();

    // Verify Search Screen elements
    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.text('Popular categories'), findsOneWidget);
    expect(find.text('Suggested for you'), findsOneWidget);

    // Verify recent items
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('Brunch'), findsNWidgets(2)); // in recent and in categories

    // Verify suggested restaurants
    expect(find.text('Kōya Sushi & Ramen'), findsOneWidget);
    expect(find.text('Café Mókus'), findsOneWidget);

    // 10. Type query "pizza" -> Transitions to search-results.html in the same screen
    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.pumpAndSettle();

    // Verify search results state
    expect(find.textContaining('restaurants for “pizza”'), findsOneWidget);
    expect(find.text('Pizzeria Forno'), findsOneWidget);
    expect(find.text('-15%'), findsOneWidget);
    expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);

    // 11. Type query with no matches "lángos truck" -> Transitions to search-no-results.html
    await tester.enterText(find.byType(TextField), 'lángos truck');
    await tester.pumpAndSettle();

    // Verify no-results state
    expect(find.text('No restaurants found'), findsOneWidget);
    expect(find.text('Try another name or dish, or browse by category.'), findsOneWidget);
    expect(find.text('Browse categories'), findsOneWidget);

    // 12. Tap Browse categories -> Resets back to initial state
    await tester.tap(find.text('Browse categories'));
    await tester.pumpAndSettle();

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Popular categories'), findsOneWidget);
  });

  testWidgets(
      'NotificationPermissionPage navigates directly to HomePage on Enable notifications',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: NotificationPermissionPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stay updated'), findsOneWidget);
    expect(find.text('Enable notifications'), findsOneWidget);

    // Tap "Enable notifications" -> Navigates to HomePage
    await tester.tap(find.text('Enable notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Current location'), findsOneWidget);
    expect(find.text('City centre'), findsOneWidget);
  });

  testWidgets(
      'NotificationPermissionPage navigates directly to HomePage on Not now',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: NotificationPermissionPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stay updated'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);

    // Tap "Not now" -> Navigates to HomePage
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    expect(find.text('Current location'), findsOneWidget);
    expect(find.text('City centre'), findsOneWidget);
  });

  testWidgets('NewPasswordPage renders single clean textfields and toggles visibility',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: NewPasswordPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create new password'), findsOneWidget);
    expect(find.text('Choose a new password for your account.'), findsOneWidget);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Confirm new password'), findsOneWidget);
    expect(find.text('Reset password'), findsOneWidget);

    // Verify 2 text fields
    expect(find.byType(TextField), findsNWidgets(2));

    // Enter passwords
    await tester.enterText(find.byType(TextField).first, 'newSecret123');
    await tester.enterText(find.byType(TextField).last, 'newSecret123');
    await tester.pumpAndSettle();

    // Tap visibility toggle icons
    expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.visibility_outlined).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    // Tap Reset password -> navigates to PasswordUpdatedPage
    await tester.tap(find.text('Reset password'));
    await tester.pumpAndSettle();
    expect(find.text('Password updated'), findsOneWidget);
  });
}
