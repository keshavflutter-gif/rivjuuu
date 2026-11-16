import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/api/api_exception.dart';
import 'package:rivjuuu/core/constants/app_messages.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:rivjuuu/core/utils/validators.dart';
import 'package:rivjuuu/data/models/auth/customer_register_request.dart';
import 'package:rivjuuu/data/models/auth/customer_register_response.dart';
import 'package:rivjuuu/data/repositories/auth/customer_register_repository.dart';
import 'package:rivjuuu/features/auth/register/customer/bloc/customer_register_bloc.dart';
import 'package:rivjuuu/features/auth/register/customer/bloc/customer_register_event.dart';
import 'package:rivjuuu/features/auth/register/customer/bloc/customer_register_state.dart';
import 'package:rivjuuu/features/auth/register/customer/screens/customer_register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRegisterRepository implements CustomerRegisterRepository {
  final Exception? exception;

  _FakeRegisterRepository({this.exception});

  @override
  Future<CustomerRegisterResponse> registerCustomer(
    CustomerRegisterRequest request,
  ) async {
    if (exception != null) {
      throw exception!;
    }
    return const CustomerRegisterResponse(
          success: 1,
          message: 'Customer account created successfully',
          userId: 'test-user-id',
          accessToken: 'test-access-token',
          refreshToken: 'test-refresh-token',
          user: CustomerRegisterUser(
            id: 'test-user-id',
            email: 'test@example.com',
            firstName: 'John',
            lastName: 'Doe',
            displayName: 'John Doe',
            phone: null,
            role: 'CUSTOMER',
            status: 'ACTIVE',
          ),
        );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Customer Registration - Validators Unit Tests', () {
    test('Empty and invalid Full Name validation', () {
      expect(Validators.validateFullName(null), AppMessages.fullNameRequired);
      expect(Validators.validateFullName(''), AppMessages.fullNameRequired);
      expect(Validators.validateFullName('   '), AppMessages.fullNameRequired);
      expect(Validators.validateFullName('A'), AppMessages.fullNameInvalid);
      expect(Validators.validateFullName('John Doe'), isNull);
    });

    test('Empty and invalid Email validation', () {
      expect(Validators.validateEmail(null), AppMessages.emailRequired);
      expect(Validators.validateEmail(''), AppMessages.emailRequired);
      expect(Validators.validateEmail('   '), AppMessages.emailRequired);
      expect(Validators.validateEmail('notanemail'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('test@'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('test@domain'), AppMessages.emailInvalid);
      expect(Validators.validateEmail('test@example.com'), isNull);
    });

    test('Empty and short Password validation (<8 characters)', () {
      expect(Validators.validatePassword(null), AppMessages.passwordRequired);
      expect(Validators.validatePassword(''), AppMessages.passwordRequired);
      expect(Validators.validatePassword('1234567'), AppMessages.passwordTooShort);
      expect(Validators.validatePassword('12345678'), isNull);
      expect(Validators.validatePassword('LongPassword123!'), isNull);
    });

    test('Confirm Password mismatch validation', () {
      expect(
        Validators.validateConfirmPassword('password123', null),
        AppMessages.confirmPasswordRequired,
      );
      expect(
        Validators.validateConfirmPassword('password123', ''),
        AppMessages.confirmPasswordRequired,
      );
      expect(
        Validators.validateConfirmPassword('password123', 'differentPassword'),
        AppMessages.passwordsDoNotMatch,
      );
      expect(
        Validators.validateConfirmPassword('password123', 'password123'),
        isNull,
      );
    });

    test('Terms and Conditions validation', () {
      expect(Validators.validateTerms(null), AppMessages.termsRequired);
      expect(Validators.validateTerms(false), AppMessages.termsRequired);
      expect(Validators.validateTerms(true), isNull);
    });
  });

  group('Customer Registration - Models Serialization Tests', () {
    test('CustomerRegisterRequest serializes exact JSON keys and boolean acceptTerms', () {
      const request = CustomerRegisterRequest(
        fullName: '  keshav dev  ',
        email: '  keshavdev1@yopmail.com  ',
        password: '12345678',
        confirmPassword: '12345678',
        acceptTerms: true,
      );

      final json = request.toJson();
      expect(json['fullName'], 'keshav dev');
      expect(json['email'], 'keshavdev1@yopmail.com');
      expect(json['password'], '12345678');
      expect(json['confirmPassword'], '12345678');
      expect(json['acceptTerms'], isTrue);
      expect(json['acceptTerms'], isA<bool>());
    });

    test('CustomerRegisterResponse parses success, tokens, and nullable phone safely', () {
      final json = {
        'success': 1,
        'message': 'Customer account created successfully',
        'userId': '8866e181-229d-4c6b-b6ae-200db8676ad8',
        'accessToken': 'JWT_ACCESS_TOKEN',
        'refreshToken': 'JWT_REFRESH_TOKEN',
        'user': {
          'id': '8866e181-229d-4c6b-b6ae-200db8676ad8',
          'email': 'keshavdev1@yopmail.com',
          'firstName': 'keshav',
          'lastName': 'dev',
          'displayName': 'keshav dev',
          'phone': null,
          'role': 'CUSTOMER',
          'status': 'ACTIVE',
        },
      };

      final response = CustomerRegisterResponse.fromJson(json);
      expect(response.success, 1);
      expect(response.isSuccessful, isTrue);
      expect(response.message, 'Customer account created successfully');
      expect(response.userId, '8866e181-229d-4c6b-b6ae-200db8676ad8');
      expect(response.accessToken, 'JWT_ACCESS_TOKEN');
      expect(response.user?.phone, isNull);
      expect(response.user?.role, 'CUSTOMER');
      expect(response.user?.displayName, 'keshav dev');
    });
  });

  group('Customer Registration - SharedPreferences Session Tests', () {
    test('Session saved after registration, restored on restart, and cleared on logout', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      expect(await storage.isLoggedIn(), isFalse);

      final saved = await storage.saveSession(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        userId: 'mock_user_id',
        email: 'user@example.com',
        firstName: 'John',
        lastName: 'Doe',
        displayName: 'John Doe',
        phone: null,
        role: 'CUSTOMER',
        status: 'ACTIVE',
      );

      expect(saved, isTrue);
      expect(await storage.isLoggedIn(), isTrue);
      expect(await storage.getAccessToken(), 'mock_access_token');
      expect(await storage.getRefreshToken(), 'mock_refresh_token');
      expect(await storage.getUserId(), 'mock_user_id');
      expect(await storage.getEmail(), 'user@example.com');
      expect(await storage.getDisplayName(), 'John Doe');

      final userData = await storage.getUserData();
      expect(userData['role'], 'CUSTOMER');
      expect(userData['status'], 'ACTIVE');
      expect(userData['phone'], isNull);

      // Verify logout clears authentication data
      await storage.clearSession();
      expect(await storage.isLoggedIn(), isFalse);
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getUserId(), isNull);
    });
  });

  group('Customer Registration - BLoC Tests', () {
    test('Successful registration emits Loading then Success and saves session', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final repo = _FakeRegisterRepository();
      final bloc = CustomerRegisterBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        const CustomerRegisterLoading(),
        isA<CustomerRegisterSuccess>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(
        const CustomerRegisterSubmitted(
          CustomerRegisterRequest(
            fullName: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptTerms: true,
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await storage.isLoggedIn(), isTrue);
      expect(await storage.getAccessToken(), 'test-access-token');

      await bloc.close();
    });

    test('Duplicate email or backend validation failure emits Loading then Failure', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final repo = _FakeRegisterRepository(
        exception: const ApiException(
          message: 'An account with this email already exists',
          statusCode: 409,
          fieldErrors: {'email': 'An account with this email already exists'},
        ),
      );

      final bloc = CustomerRegisterBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        const CustomerRegisterLoading(),
        isA<CustomerRegisterFailure>().having(
          (s) => s.message,
          'message',
          'An account with this email already exists',
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(
        const CustomerRegisterSubmitted(
          CustomerRegisterRequest(
            fullName: 'John Doe',
            email: 'duplicate@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptTerms: true,
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      // No tokens should be saved on failure
      expect(await storage.isLoggedIn(), isFalse);

      await bloc.close();
    });

    test('Network unavailable emits Loading then Failure with network message', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      final repo = _FakeRegisterRepository(
        exception: const ApiException(
          message: 'Network unavailable. Please check your internet connection.',
        ),
      );

      final bloc = CustomerRegisterBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        const CustomerRegisterLoading(),
        isA<CustomerRegisterFailure>().having(
          (s) => s.message,
          'message',
          contains('Network unavailable'),
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(
        const CustomerRegisterSubmitted(
          CustomerRegisterRequest(
            fullName: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            acceptTerms: true,
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await bloc.close();
    });
  });

  group('Customer Registration - UI & Form Validation Tests', () {
    testWidgets('Validation errors appear inline when submitting empty fields', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => CustomerRegisterBloc(
              repository: _FakeRegisterRepository(),
              tokenStorageService: storage,
            ),
            child: const CustomerRegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Create account button without entering data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
      await tester.pumpAndSettle();

      // Inline errors should be displayed
      expect(find.text(AppMessages.fullNameRequired), findsOneWidget);
      expect(find.text(AppMessages.emailRequired), findsOneWidget);
      expect(find.text(AppMessages.passwordRequired), findsOneWidget);
      expect(find.text(AppMessages.confirmPasswordRequired), findsOneWidget);
      expect(find.text(AppMessages.termsRequired), findsOneWidget);
    });

    testWidgets('Password and confirm password visibility toggles work properly', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => CustomerRegisterBloc(
              repository: _FakeRegisterRepository(),
              tokenStorageService: storage,
            ),
            child: const CustomerRegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially obscureText is true so visibility_off_outlined is displayed
      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityIcons, findsNWidgets(2));

      // Tap first visibility toggle
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();

      // One icon toggles to visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}
