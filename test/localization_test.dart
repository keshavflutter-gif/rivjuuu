import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/core/storage/language_storage_service.dart';
import 'package:rivjuuu/core/utils/localized_messages.dart';
import 'package:rivjuuu/data/models/restaurant/restaurant_category_model.dart';
import 'package:rivjuuu/features/home/view/home_page.dart';
import 'package:rivjuuu/features/language/bloc/language_bloc.dart';
import 'package:rivjuuu/features/language/bloc/language_event.dart';
import 'package:rivjuuu/features/language/bloc/language_state.dart';
import 'package:rivjuuu/core/widgets/restaurant_bottom_nav_bar.dart';
import 'package:rivjuuu/features/restaurant_dashboard/view/restaurant_dashboard_page.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_account_page.dart';
import 'package:rivjuuu/features/restaurant_profile/view/restaurant_settings_page.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:rivjuuu/features/splash/bloc/splash_bloc.dart';
import 'package:rivjuuu/features/splash/bloc/splash_event.dart';
import 'package:rivjuuu/features/splash/bloc/splash_state.dart';
import 'package:rivjuuu/features/restaurant_registration/models/restaurant_registration_data.dart';
import 'package:rivjuuu/features/auth/bloc/login_bloc.dart';
import 'package:rivjuuu/features/auth/bloc/login_event.dart';
import 'package:rivjuuu/features/auth/bloc/login_state.dart';
import 'package:rivjuuu/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations Translation Parity Tests', () {
    test('English and Hungarian localizations load correctly', () {
      final en = lookupAppLocalizations(const Locale('en'));
      final hu = lookupAppLocalizations(const Locale('hu'));

      expect(en.appName, equals('Rivjuuu'));
      expect(hu.appName, equals('Rivjuuu'));

      expect(en.chooseLanguageTitle, equals('Choose language'));
      expect(hu.chooseLanguageTitle, equals('Válassz nyelvet'));

      expect(en.logIn, equals('Log in'));
      expect(hu.logIn, equals('Bejelentkezés'));

      expect(en.createAccount, equals('Create account'));
      expect(hu.createAccount, equals('Fiók létrehozása'));

      expect(en.customerRole, equals('Customer'));
      expect(hu.customerRole, equals('Vendég'));

      expect(en.restaurantRole, equals('Restaurant'));
      expect(hu.restaurantRole, equals('Étterem'));

      expect(en.stepProgress(1), equals('Step 1 of 4'));
      expect(hu.stepProgress(1), equals('1 / 4 lépés'));

      expect(en.profileTitle, equals('Profile'));
      expect(hu.profileTitle, equals('Profil'));

      expect(en.logOutButton, equals('Log out'));
      expect(hu.logOutButton, equals('Kijelentkezés'));
    });
  });

  group('LanguageStorageService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      LanguageStorageService.resetForTesting();
    });

    test('Defaults to English and false for hasSelectedLanguage', () async {
      final storage = await LanguageStorageService.getInstance();
      expect(await storage.getLanguageCode(), equals('en'));
      expect(await storage.hasSelectedLanguage(), isFalse);
    });

    test('Saves and retrieves Hungarian language preference', () async {
      final storage = await LanguageStorageService.getInstance();
      await storage.saveLanguageCode('hu');
      await storage.setHasSelectedLanguage(true);

      expect(await storage.getLanguageCode(), equals('hu'));
      expect(await storage.hasSelectedLanguage(), isTrue);
    });
  });

  group('LanguageBloc State Management Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      LanguageStorageService.resetForTesting();
    });

    test('Initial state defaults to English and uninitialized', () {
      final bloc = LanguageBloc();
      expect(bloc.state.selectedLanguage, equals('en'));
      expect(bloc.state.isInitialized, isFalse);
      bloc.close();
    });

    test('Initializes previously persisted Hungarian selection', () async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('selected_language_code', 'hu');
      await sp.setBool('has_selected_language', true);

      final bloc = LanguageBloc();
      bloc.add(const LanguageInitialized());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const LanguageState(
            selectedLanguage: 'hu',
            isInitialized: true,
            hasSelectedLanguage: true,
          ),
        ]),
      );
      bloc.close();
    });

    test('LanguageSelected updates language and LanguageConfirmed confirms it', () async {
      final bloc = LanguageBloc();

      bloc.add(const LanguageSelected('hu'));
      await expectLater(
        bloc.stream,
        emits(const LanguageState(
          selectedLanguage: 'hu',
          isInitialized: false,
          hasSelectedLanguage: false,
        )),
      );

      bloc.add(const LanguageConfirmed());
      await expectLater(
        bloc.stream,
        emits(const LanguageState(
          selectedLanguage: 'hu',
          isInitialized: false,
          hasSelectedLanguage: true,
        )),
      );

      final storage = await LanguageStorageService.getInstance();
      expect(await storage.getLanguageCode(), equals('hu'));
      expect(await storage.hasSelectedLanguage(), isTrue);

      bloc.close();
    });
  });

  group('LocalizedMessages Integration Tests', () {
    testWidgets('Translates known messages in Hungarian and English environments', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('hu'),
          home: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(LocalizedMessages.get(context, 'Full name is required')),
                    Text(LocalizedMessages.get(context, 'Owner or contact name is required')),
                    Text(LocalizedMessages.get(context, 'Restaurant name is required')),
                    Text(LocalizedMessages.get(context, 'Please select a category')),
                    Text(LocalizedMessages.get(context, 'Address is required')),
                    Text(LocalizedMessages.get(context, 'Business detail is required')),
                    Text(LocalizedMessages.get(context, 'Please upload a supporting document')),
                    Text(LocalizedMessages.get(context, 'Email address is required')),
                    Text(LocalizedMessages.get(context, 'Password is required')),
                    Text(LocalizedMessages.get(context, 'Please confirm your password')),
                    Text(LocalizedMessages.get(context, 'An account with this email already exists')),
                    Text(LocalizedMessages.get(context, 'An account with this email already exists.')),
                    Text(LocalizedMessages.get(context, 'Location pinned: Budapest')),
                    Text(LocalizedMessages.get(context, 'Uploaded: license.pdf')),
                    Text(LocalizedMessages.get(context, 'Support email: support@rivjuuu.com')),
                    Text(LocalizedMessages.get(context, 'Profile updated')),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('A teljes név megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('A tulajdonos vagy kapcsolattartó nevének megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('Az étterem nevének megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('Kérjük, válassz egy kategóriát', skipOffstage: false), findsOneWidget);
      expect(find.text('A cím megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('A vállalkozási adat megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('Kérjük, tölts fel egy igazoló dokumentumot', skipOffstage: false), findsOneWidget);
      expect(find.text('Az e-mail cím megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('A jelszó megadása kötelező', skipOffstage: false), findsOneWidget);
      expect(find.text('Kérjük, erősítsd meg a jelszavad', skipOffstage: false), findsOneWidget);
      expect(find.text('Már létezik fiók ezzel az e-mail címmel', skipOffstage: false), findsNWidgets(2));
      expect(find.text('Hely rögzítve: Budapest', skipOffstage: false), findsOneWidget);
      expect(find.text('Feltöltve: license.pdf', skipOffstage: false), findsOneWidget);
      expect(find.text('Ügyfélszolgálati e-mail: support@rivjuuu.com', skipOffstage: false), findsOneWidget);
      expect(find.text('Profil frissítve', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Translates known messages in English environment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(LocalizedMessages.get(context, 'Owner or contact name is required')),
                    Text(LocalizedMessages.get(context, 'Restaurant name is required')),
                    Text(LocalizedMessages.get(context, 'Please select a category')),
                    Text(LocalizedMessages.get(context, 'Address is required')),
                    Text(LocalizedMessages.get(context, 'Business detail is required')),
                    Text(LocalizedMessages.get(context, 'Please upload a supporting document')),
                    Text(LocalizedMessages.get(context, 'An account with this email already exists')),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Owner or contact name is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Restaurant name is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Please select a category', skipOffstage: false), findsOneWidget);
      expect(find.text('Address is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Business detail is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Please upload a supporting document', skipOffstage: false), findsOneWidget);
      expect(find.text('An account with this email already exists', skipOffstage: false), findsOneWidget);
    });
  });

  group('RestaurantCategoryModel Localization Tests', () {
    test('Uses Hungarian translations from API when present', () {
      const category = RestaurantCategoryModel(
        id: 'b7e2323a-90b3-4781-9642-2bf311a7eaa2',
        name: 'Burger',
        slug: 'burger',
        description: 'Burgers, fries, and street food',
        translations: [
          CategoryTranslation(
            locale: 'en',
            name: 'Burger',
            description: 'Burgers, fries, and street food',
          ),
          CategoryTranslation(
            locale: 'hu',
            name: 'Hamburger',
            description: 'Hamburgerek, sült krumpli és street food',
          ),
        ],
      );

      expect(category.localizedName('hu'), equals('Hamburger'));
      expect(
        category.localizedDescription('hu'),
        equals('Hamburgerek, sült krumpli és street food'),
      );
      expect(category.localizedName('en'), equals('Burger'));
      expect(
        category.localizedDescription('en'),
        equals('Burgers, fries, and street food'),
      );
    });

    test('Falls back to dictionary translation when translations array lacks Hungarian', () {
      const category = RestaurantCategoryModel(
        id: 'f47b6f52-53b3-4a10-a572-dc1687b37315',
        name: 'Italian',
        slug: 'italian',
        description: 'Authentic Italian cuisine',
        translations: [
          CategoryTranslation(
            locale: 'en',
            name: 'Italian',
            description: 'Authentic Italian cuisine',
          ),
        ],
      );

      expect(category.localizedName('hu'), equals('Olasz'));
      expect(
        category.localizedDescription('hu'),
        equals('Autentikus olasz konyha'),
      );
    });

    test('Falls back to dictionary translation when translations is null', () {
      const category = RestaurantCategoryModel(
        id: '123',
        name: 'Burger',
        slug: 'burger-special',
        description: 'Burgers, fries, and street food',
      );

      expect(category.localizedName('hu'), equals('Hamburger'));
      expect(
        category.localizedDescription('hu'),
        equals('Hamburgerek, sült krumpli és street food'),
      );
    });
  });

  group('RestaurantSettingsPage Language Change Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      LanguageStorageService.resetForTesting();
    });

    testWidgets('Tapping Hungarian in settings sheet dispatches language change and updates UI', (tester) async {
      final languageBloc = LanguageBloc();

      await tester.pumpWidget(
        BlocProvider<LanguageBloc>.value(
          value: languageBloc,
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return MaterialApp(
                locale: Locale(state.selectedLanguage),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const RestaurantSettingsPage(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially in English
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Tap Language row to open sheet
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Sheet opens with Hungarian option
      expect(find.text('Hungarian'), findsOneWidget);

      // Tap Hungarian
      await tester.tap(find.text('Hungarian'));
      await tester.pumpAndSettle();

      // Should now be in Hungarian
      expect(languageBloc.state.selectedLanguage, equals('hu'));
      expect(find.text('Beállítások'), findsOneWidget);
      expect(find.text('Nyelv'), findsOneWidget);
      expect(find.text('Magyar'), findsOneWidget);
    });

    testWidgets('RestaurantAccountContentView and RestaurantBottomNavBar display in Hungarian',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(414, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hu'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: const RestaurantAccountContentView(),
            bottomNavigationBar: RestaurantBottomNavBar(
              currentIndex: 4,
              onTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top title and identity
      expect(find.text('Profil'), findsWidgets);
      expect(find.text('Jóváhagyva'), findsOneWidget);
      expect(find.text('· Növekedési csomag'), findsOneWidget);

      // Section: Restaurant
      expect(find.text('Étterem profil'), findsOneWidget);
      expect(find.text('Étlap'), findsOneWidget);

      // Section: Business
      expect(find.text('Előfizetés'), findsOneWidget);
      expect(find.text('Statisztika'), findsOneWidget);

      // Section: Engagement
      expect(find.text('Hűségprogram'), findsOneWidget);
      expect(find.text('Nyereményjátékok'), findsOneWidget);
      expect(find.text('1 aktív'), findsOneWidget);

      // Section: Account
      expect(find.text('Értesítések'), findsOneWidget);
      expect(find.text('Beállítások'), findsOneWidget);

      // Bottom Navigation Bar
      expect(find.text('Vezérlőpult'), findsOneWidget);
      expect(find.text('Kuponok'), findsOneWidget);
      expect(find.text('Beolvasás'), findsOneWidget);
      expect(find.text('Tevékenység'), findsOneWidget);
      expect(find.text('AKTIVITÁS'), findsOneWidget);
    });

    testWidgets('RestaurantAccountContentView in Hungarian does not overflow on narrow screens',
        (tester) async {
      // Test on 360px and 320px narrow screens
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hu'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: const RestaurantAccountContentView(),
            bottomNavigationBar: RestaurantBottomNavBar(
              currentIndex: 4,
              onTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Jóváhagyva'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage in Hungarian does not overflow on narrow screens',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hu'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestaurantDashboardPage(
            data: RestaurantRegistrationData(
              restaurantName: 'Trattoria Nonna Rosa',
              approvalStatus: 'APPROVED',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Legutóbbi tevékenység'), findsOneWidget);
      expect(find.text('Összes'), findsOneWidget);
    });
  });

  group('Restaurant Persistent Session & Language Persistence on Restart', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      TokenStorageService.resetForTesting();
    });

    test('TokenStorageService stores and retrieves restaurant data correctly', () async {
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final saved = await storage.saveLoginSession(
        accessToken: 'jwt_access_token_xyz',
        refreshToken: 'jwt_refresh_token_xyz',
        userId: 'rest_user_1',
        email: 'restaurant@example.com',
        firstName: 'Márton',
        lastName: 'Szabó',
        role: 'RESTAURANT',
        status: 'ACTIVE',
        restaurantId: 'rest_uuid_99',
        restaurantName: 'Gundel Étterem',
        restaurantCategory: 'Hungarian',
        restaurantAddress: 'Gundel Károly út 4',
        restaurantCity: 'Budapest',
        restaurantApprovalStatus: 'APPROVED',
      );

      expect(saved, isTrue);
      expect(await storage.isLoggedIn(), isTrue);

      final restData = await storage.getRestaurantData();
      expect(restData.restaurantId, equals('rest_uuid_99'));
      expect(restData.restaurantName, equals('Gundel Étterem'));
      expect(restData.category, equals('Hungarian'));
      expect(restData.address, equals('Gundel Károly út 4'));
      expect(restData.city, equals('Budapest'));
      expect(restData.approvalStatus, equals('APPROVED'));
      expect(restData.ownerName, equals('Márton Szabó'));
      expect(restData.email, equals('restaurant@example.com'));

      final userData = await storage.getUserData();
      expect(userData['role'], equals('RESTAURANT'));
      expect(userData['restaurantId'], equals('rest_uuid_99'));
      expect(userData['restaurantApprovalStatus'], equals('APPROVED'));

      // Test clearSession removes restaurant keys
      await storage.clearSession();
      expect(await storage.isLoggedIn(), isFalse);
      final clearedData = await storage.getUserData();
      expect(clearedData['restaurantId'], isNull);
      expect(clearedData['role'], isNull);
    });

    test('SplashBloc auto-logs in APPROVED restaurant user to authenticatedRestaurant', () async {
      final storage = await TokenStorageService.getInstance(prefs: prefs);
      await storage.saveLoginSession(
        accessToken: 'valid_jwt_token',
        refreshToken: 'valid_refresh_token',
        userId: 'u_approved',
        email: 'approved@restaurant.hu',
        role: 'RESTAURANT',
        status: 'ACTIVE',
        restaurantId: 'rest_1',
        restaurantName: 'Borkonyha',
        restaurantApprovalStatus: 'APPROVED',
      );

      final splashBloc = SplashBloc(
        splashDuration: const Duration(milliseconds: 10),
        tokenStorageService: storage,
      );

      expectLater(
        splashBloc.stream,
        emitsInOrder([
          const SplashState(status: SplashStatus.loading),
          predicate<SplashState>((s) =>
              s.status == SplashStatus.authenticatedRestaurant &&
              s.restaurantData?.restaurantName == 'Borkonyha' &&
              s.restaurantData?.approvalStatus == 'APPROVED'),
        ]),
      );

      splashBloc.add(const SplashStarted());
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await splashBloc.close();
    });

    test('SplashBloc routes PENDING restaurant user to authenticatedRestaurantPending', () async {
      final storage = await TokenStorageService.getInstance(prefs: prefs);
      await storage.saveLoginSession(
        accessToken: 'valid_jwt_token',
        refreshToken: 'valid_refresh_token',
        userId: 'u_pending',
        email: 'pending@restaurant.hu',
        role: 'RESTAURANT',
        status: 'ACTIVE',
        restaurantId: 'rest_2',
        restaurantName: 'Pending Bistro',
        restaurantApprovalStatus: 'PENDING',
      );

      final splashBloc = SplashBloc(
        splashDuration: const Duration(milliseconds: 10),
        tokenStorageService: storage,
      );

      expectLater(
        splashBloc.stream,
        emitsInOrder([
          const SplashState(status: SplashStatus.loading),
          predicate<SplashState>((s) =>
              s.status == SplashStatus.authenticatedRestaurantPending &&
              s.restaurantData?.restaurantName == 'Pending Bistro' &&
              s.restaurantData?.approvalStatus == 'PENDING'),
        ]),
      );

      splashBloc.add(const SplashStarted());
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await splashBloc.close();
    });

    test('Language change to Hungarian persists and app restart keeps Hungarian + Restaurant session', () async {
      // 1. Setup persistent storage
      final langStorage = await LanguageStorageService.getInstance(prefs: prefs);
      final tokenStorage = await TokenStorageService.getInstance(prefs: prefs);

      // 2. User changes language to Hungarian
      final langBloc = LanguageBloc(storageService: langStorage);
      langBloc.add(const LanguageSelected('hu'));
      langBloc.add(const LanguageConfirmed());
      await pumpEventQueue();

      expect(langBloc.state.selectedLanguage, equals('hu'));
      expect(await langStorage.getLanguageCode(), equals('hu'));
      await langBloc.close();

      // 3. User logs in to Restaurant
      await tokenStorage.saveLoginSession(
        accessToken: 'jwt_hu_token',
        refreshToken: 'refresh_hu_token',
        userId: 'rest_hu_user',
        email: 'magyar@etterem.hu',
        role: 'RESTAURANT',
        status: 'ACTIVE',
        restaurantName: 'Magyar Étterem',
        restaurantApprovalStatus: 'APPROVED',
      );

      // 4. Simulate App Kill & Cold Restart:
      // SplashBloc runs fresh on app cold launch with the persisted storage
      final splashBloc = SplashBloc(
        splashDuration: const Duration(milliseconds: 10),
        tokenStorageService: tokenStorage,
        languageStorageService: langStorage,
      );

      expectLater(
        splashBloc.stream,
        emitsInOrder([
          const SplashState(status: SplashStatus.loading),
          predicate<SplashState>((s) =>
              s.status == SplashStatus.authenticatedRestaurant &&
              s.restaurantData?.restaurantName == 'Magyar Étterem'),
        ]),
      );

      splashBloc.add(const SplashStarted());
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await splashBloc.close();

      // Language remains Hungarian after restart
      expect(await langStorage.getLanguageCode(), equals('hu'));
    });

    test('LoginBloc restores restaurant session on LoginSessionChecked', () async {
      final storage = await TokenStorageService.getInstance(prefs: prefs);
      await storage.saveLoginSession(
        accessToken: 'token_check',
        refreshToken: 'refresh_check',
        userId: 'u_check',
        email: 'rest@check.hu',
        role: 'RESTAURANT',
        status: 'ACTIVE',
        restaurantId: 'rest_check_id',
        restaurantName: 'Checked Restaurant',
        restaurantCategory: 'Italian',
        restaurantApprovalStatus: 'APPROVED',
      );

      final loginBloc = LoginBloc(tokenStorageService: storage);
      loginBloc.add(const LoginSessionChecked());
      await pumpEventQueue();

      expect(loginBloc.state, isA<LoginSuccess>());
      final success = loginBloc.state as LoginSuccess;
      expect(success.response.role, equals('RESTAURANT'));
      expect(success.response.user?.restaurants?.length, equals(1));
      final rest = success.response.user!.restaurants!.first as Map<String, dynamic>;
      expect(rest['name'], equals('Checked Restaurant'));
      expect(rest['approvalStatus'], equals('APPROVED'));

      await loginBloc.close();
    });

    testWidgets('RestaurantSettingsPage log out confirms and navigates directly to Login screen',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final storage = await TokenStorageService.getInstance(prefs: prefs);
      await storage.saveLoginSession(
        accessToken: 'token_logout_test',
        refreshToken: 'refresh_logout_test',
        userId: 'u_logout',
        email: 'logout@test.hu',
        role: 'RESTAURANT',
        status: 'ACTIVE',
      );
      expect(await storage.isLoggedIn(), isTrue);

      String? pushedRoute;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.login) {
              pushedRoute = settings.name;
              return MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('Login Screen')),
                settings: settings,
              );
            }
            return null;
          },
          home: const RestaurantSettingsPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down and find Log out button
      final logoutFinder = find.text('Log out');
      await tester.scrollUntilVisible(logoutFinder, 200);
      expect(logoutFinder, findsOneWidget);
      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();

      // Confirmation dialog is shown
      expect(find.text('Are you sure you want to log out of your restaurant account?'), findsOneWidget);
      // Tap Confirm Log out button in dialog
      final confirmBtn = find.widgetWithText(ElevatedButton, 'Log out');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Session cleared and navigated directly to Login screen
      expect(await storage.isLoggedIn(), isFalse);
      expect(pushedRoute, equals(AppRoutes.login));
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Customer HomePage back press shows snackbar "Tap again to exit" in English',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger back button
      await tester.binding.handlePopRoute();
      await tester.pump();

      // Snackbar is shown with "Tap again to exit"
      expect(find.text('Tap again to exit'), findsOneWidget);
    });

    testWidgets('Customer HomePage back press shows snackbar "A kilépéshez koppints még egyszer" in Hungarian',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('hu'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('A kilépéshez koppints még egyszer'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage back press shows snackbar "Tap again to exit" in English',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestaurantDashboardPage(
            data: RestaurantRegistrationData(
              restaurantName: 'Test Restaurant',
              approvalStatus: 'APPROVED',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger back button
      await tester.binding.handlePopRoute();
      await tester.pump();

      // Snackbar is shown with "Tap again to exit"
      expect(find.text('Tap again to exit'), findsOneWidget);
    });

    testWidgets('RestaurantDashboardPage back press shows snackbar "A kilépéshez koppints még egyszer" in Hungarian',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hu'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestaurantDashboardPage(
            data: RestaurantRegistrationData(
              restaurantName: 'Test Restaurant',
              approvalStatus: 'APPROVED',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('A kilépéshez koppints még egyszer'), findsOneWidget);
    });
  });
}
