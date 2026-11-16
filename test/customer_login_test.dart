import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/api/api_exception.dart';
import 'package:rivjuuu/core/constants/app_messages.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:rivjuuu/core/utils/validators.dart';
import 'package:rivjuuu/data/models/auth/login_request.dart';
import 'package:rivjuuu/data/models/auth/login_response.dart';
import 'package:rivjuuu/data/repositories/auth/login_repository.dart';
import 'package:rivjuuu/features/auth/bloc/login_bloc.dart';
import 'package:rivjuuu/features/auth/bloc/login_event.dart';
import 'package:rivjuuu/features/auth/bloc/login_state.dart';
import 'package:rivjuuu/features/auth/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeLoginRepository implements LoginRepository {
  final Exception? exception;
  final LoginResponse? customResponse;

  _FakeLoginRepository({this.exception, this.customResponse});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    if (exception != null) {
      throw exception!;
    }
    return customResponse ??
        const LoginResponse(
          success: 1,
          message: 'Login successful',
          accessToken: 'test_access_token_jwt',
          refreshToken: 'test_refresh_token_jwt',
          role: 'CUSTOMER',
          user: LoginUser(
            id: '1c662515-d42e-4c7e-a916-fcf0f4abdb73',
            email: 'keshavhardik@yopmail.com',
            firstName: 'Keshav',
            lastName: 'Hardik',
            phone: null,
            role: 'CUSTOMER',
            status: 'ACTIVE',
            customerProfile: CustomerProfile(
              id: '204147a6-5dfd-45eb-87fd-40f01b9b941b',
              userId: '1c662515-d42e-4c7e-a916-fcf0f4abdb73',
              displayName: 'Keshav Hardik',
              avatarUrl: null,
              bio: null,
              createdAt: '2026-11-16T08:20:23.463Z',
              updatedAt: '2026-11-16T08:20:23.463Z',
            ),
            restaurants: [],
          ),
        );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TokenStorageService.resetForTesting();
  });

  group('Customer Login - Form Validation Tests', () {
    test('Email validator handles null, empty, whitespace and invalid formats', () {
      expect(Validators.validateEmail(null), AppMessages.emailRequired);
      expect(Validators.validateEmail(''), AppMessages.emailRequired);
      expect(Validators.validateEmail('   '), AppMessages.emailRequired);
      expect(Validators.validateEmail('invalid_email'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('user@'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('user@domain'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('  user@example.com  '), isNull);
    });

    test('Password validator handles empty and whitespace-only passwords without trimming valid passwords', () {
      expect(Validators.validateLoginPassword(null), AppMessages.passwordRequired);
      expect(Validators.validateLoginPassword(''), AppMessages.passwordRequired);
      expect(Validators.validateLoginPassword('   '), AppMessages.passwordEmptyOrWhitespace);
      expect(Validators.validateLoginPassword('secret123'), isNull);
      // Untrimmed passwords with legitimate spaces should be accepted
      expect(Validators.validateLoginPassword('my secret password'), isNull);
    });
  });

  group('Customer Login - Model Serialization Tests', () {
    test('LoginRequest serializes exact JSON keys with untrimmed password and trimmed email', () {
      const request = LoginRequest(
        email: '  test@example.com  ',
        password: '  SecretPassword123  ',
      );

      final json = request.toJson();
      expect(json['email'], 'test@example.com');
      // Password must NOT be trimmed
      expect(json['password'], '  SecretPassword123  ');
    });

    test('LoginResponse deserializes success, tokens, role, and customerProfile with null safety', () {
      final sampleJson = {
        'success': 1,
        'message': 'Login successful',
        'accessToken': 'sample_access',
        'refreshToken': 'sample_refresh',
        'role': 'CUSTOMER',
        'user': {
          'id': 'user-123',
          'email': 'user@example.com',
          'firstName': 'John',
          'lastName': 'Doe',
          'phone': null,
          'role': 'CUSTOMER',
          'status': 'ACTIVE',
          'customerProfile': {
            'id': 'prof-456',
            'userId': 'user-123',
            'displayName': 'John Doe',
            'avatarUrl': null,
            'bio': null,
            'createdAt': '2026-11-16T08:20:23.463Z',
            'updatedAt': '2026-11-16T08:20:23.463Z',
          },
          'restaurants': [],
        },
      };

      final response = LoginResponse.fromJson(sampleJson);
      expect(response.success, 1);
      expect(response.isSuccess, isTrue);
      expect(response.message, 'Login successful');
      expect(response.accessToken, 'sample_access');
      expect(response.refreshToken, 'sample_refresh');
      expect(response.role, 'CUSTOMER');
      expect(response.user?.id, 'user-123');
      expect(response.user?.phone, isNull);
      expect(response.user?.customerProfile?.displayName, 'John Doe');
      expect(response.user?.customerProfile?.avatarUrl, isNull);
      expect(response.user?.restaurants, isEmpty);
    });
  });

  group('Customer Login - SharedPreferences Session Management Tests', () {
    test('saveLoginSession stores all required keys and isLoggedIn reports true', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      expect(await storage.isLoggedIn(), isFalse);

      final saved = await storage.saveLoginSession(
        accessToken: 'saved_access_token',
        refreshToken: 'saved_refresh_token',
        userId: 'user_uuid_123',
        email: 'saved@example.com',
        firstName: 'Jane',
        lastName: 'Doe',
        phone: null,
        role: 'CUSTOMER',
        status: 'ACTIVE',
        customerProfileId: 'profile_uuid_456',
        displayName: 'Jane Doe',
        avatarUrl: null,
        bio: 'Food lover',
      );

      expect(saved, isTrue);
      expect(await storage.isLoggedIn(), isTrue);
      expect(await storage.getAccessToken(), 'saved_access_token');
      expect(await storage.getRefreshToken(), 'saved_refresh_token');
      expect(await storage.getUserId(), 'user_uuid_123');
      expect(await storage.getEmail(), 'saved@example.com');
      expect(await storage.getDisplayName(), 'Jane Doe');

      final userData = await storage.getUserData();
      expect(userData['userId'], 'user_uuid_123');
      expect(userData['email'], 'saved@example.com');
      expect(userData['customerProfileId'], 'profile_uuid_456');
      expect(userData['bio'], 'Food lover');
      expect(userData['phone'], isNull);

      // Verify clearSession clears all session keys
      await storage.clearSession();
      expect(await storage.isLoggedIn(), isFalse);
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
      expect(await storage.getUserId(), isNull);
    });
  });

  group('Customer Login - BLoC State Management Tests', () {
    test('Successful login emits LoginLoading then LoginSuccess and saves session', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final bloc = LoginBloc(
        repository: _FakeLoginRepository(),
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LoginLoading>(),
        isA<LoginSuccess>().having(
          (s) => s.response.accessToken,
          'accessToken',
          'test_access_token_jwt',
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoginSubmitted(
        email: 'keshavhardik@yopmail.com',
        password: 'Password123',
      ));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await storage.isLoggedIn(), isTrue);
      expect(await storage.getAccessToken(), 'test_access_token_jwt');

      await bloc.close();
    });

    test('Incorrect credentials (HTTP 401) emits LoginLoading then LoginFailure and preserves inputs', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final bloc = LoginBloc(
        repository: _FakeLoginRepository(
          exception: const ApiException(
            message: 'Invalid email or password',
            statusCode: 401,
          ),
        ),
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LoginLoading>(),
        isA<LoginFailure>()
            .having((s) => s.message, 'message', 'Invalid email or password')
            .having((s) => s.email, 'email', 'wrong@example.com')
            .having((s) => s.password, 'password', 'wrongPassword'),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoginSubmitted(
        email: 'wrong@example.com',
        password: 'wrongPassword',
      ));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await storage.isLoggedIn(), isFalse);

      await bloc.close();
    });

    test('Unsupported role (e.g. RESTAURANT) is rejected with clear message', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final bloc = LoginBloc(
        repository: _FakeLoginRepository(
          customResponse: const LoginResponse(
            success: 1,
            message: 'Login successful',
            accessToken: 'token_for_restaurant',
            role: 'RESTAURANT',
            user: LoginUser(
              id: 'rest_user_id',
              email: 'restaurant@example.com',
              role: 'RESTAURANT',
            ),
          ),
        ),
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          AppMessages.unsupportedRole,
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoginSubmitted(
        email: 'restaurant@example.com',
        password: 'Password123',
      ));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await storage.isLoggedIn(), isFalse);

      await bloc.close();
    });

    test('Network unavailable emits LoginLoading then LoginFailure with network message', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final bloc = LoginBloc(
        repository: _FakeLoginRepository(
          exception: const ApiException(
            message: AppMessages.networkUnavailable,
          ),
        ),
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          AppMessages.networkUnavailable,
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoginSubmitted(
        email: 'test@example.com',
        password: 'Password123',
      ));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await storage.isLoggedIn(), isFalse);

      await bloc.close();
    });
  });

  group('Customer Login - UI & Widget Interaction Tests', () {
    testWidgets('Submitting empty inputs shows inline validation errors and prevents API call', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(
              repository: _FakeLoginRepository(),
              tokenStorageService: storage,
            ),
            child: const LoginView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Log In button with empty textfields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();

      // Inline validation error messages must be visible
      expect(find.text(AppMessages.emailRequired), findsOneWidget);
      expect(find.text(AppMessages.passwordRequired), findsOneWidget);
    });

    testWidgets('Password visibility toggle toggles obscureText and suffix icon', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(
              repository: _FakeLoginRepository(),
              tokenStorageService: storage,
            ),
            child: const LoginView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially obscureText is true so visibility_off_outlined is shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      // Icon should now be visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}

