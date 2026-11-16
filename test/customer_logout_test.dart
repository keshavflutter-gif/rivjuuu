import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/api/api_endpoints.dart';
import 'package:rivjuuu/core/api/api_exception.dart';
import 'package:rivjuuu/core/constants/app_messages.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:rivjuuu/data/models/auth/logout_request.dart';
import 'package:rivjuuu/data/models/auth/logout_response.dart';
import 'package:rivjuuu/data/repositories/auth/logout_repository.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_bloc.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_event.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_state.dart';
import 'package:rivjuuu/features/profile/view/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeLogoutRepository implements LogoutRepository {
  final Exception? exception;
  final LogoutResponse? customResponse;
  String? capturedAccessToken;
  LogoutRequest? capturedRequest;

  _FakeLogoutRepository({this.exception, this.customResponse});

  @override
  Future<LogoutResponse> logout({
    required String? accessToken,
    LogoutRequest request = const LogoutRequest(),
  }) async {
    capturedAccessToken = accessToken;
    capturedRequest = request;

    if (exception != null) {
      throw exception!;
    }

    return customResponse ??
        const LogoutResponse(
          success: 1,
          message: 'Logout successful',
        );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TokenStorageService.resetForTesting();
  });

  group('Logout Feature - Configuration & Models Tests', () {
    test('ApiEndpoints defines correct logout endpoint and URL', () {
      expect(ApiEndpoints.logout, '/auth/logout');
      expect(
        ApiEndpoints.fullLogoutUrl,
        'http://server.keshavinfotechdemo2.com:4020/auth/logout',
      );
    });

    test('LogoutRequest serializes deviceToken correctly without using accessToken', () {
      const request = LogoutRequest(deviceToken: 'fcm_device_token_xyz');
      expect(request.toJson(), {'deviceToken': 'fcm_device_token_xyz'});

      const emptyRequest = LogoutRequest();
      expect(emptyRequest.toJson(), {'deviceToken': ''});
    });

    test('LogoutResponse deserializes success and message safely', () {
      final json = {'success': 1, 'message': 'Logout successful'};
      final response = LogoutResponse.fromJson(json);
      expect(response.success, 1);
      expect(response.isSuccess, isTrue);
      expect(response.message, 'Logout successful');
    });
  });

  group('Logout Feature - BLoC & Session Clearing Tests', () {
    test('Successful logout calls repository with Bearer token, clears SharedPreferences and emits LogoutSuccess', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      // Seed active session
      await storage.saveLoginSession(
        accessToken: 'valid_access_token_123',
        refreshToken: 'valid_refresh_token_123',
        userId: 'user_123',
        email: 'user@example.com',
        role: 'CUSTOMER',
        status: 'ACTIVE',
      );
      expect(await storage.isLoggedIn(), isTrue);

      final repo = _FakeLogoutRepository();
      final bloc = LogoutBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LogoutLoading>(),
        isA<LogoutSuccess>().having(
          (s) => s.message,
          'message',
          'Logout successful',
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LogoutRequested(deviceToken: 'custom_device_token'));

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Verify request arguments
      expect(repo.capturedAccessToken, 'valid_access_token_123');
      expect(repo.capturedRequest?.deviceToken, 'custom_device_token');

      // Verify SharedPreferences session is completely cleared
      expect(await storage.isLoggedIn(), isFalse);
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getUserId(), isNull);

      await bloc.close();
    });

    test('HTTP 401 (invalid/expired token) clears local session and emits LogoutFailure with sessionCleared=true', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await storage.saveLoginSession(
        accessToken: 'expired_token',
        refreshToken: 'refresh_token',
        userId: 'user_expired',
        email: 'expired@example.com',
        role: 'CUSTOMER',
        status: 'ACTIVE',
      );
      expect(await storage.isLoggedIn(), isTrue);

      final repo = _FakeLogoutRepository(
        exception: const ApiException(
          message: 'Invalid or expired token',
          statusCode: 401,
        ),
      );

      final bloc = LogoutBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LogoutLoading>(),
        isA<LogoutFailure>()
            .having((s) => s.statusCode, 'statusCode', 401)
            .having((s) => s.sessionCleared, 'sessionCleared', isTrue),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LogoutRequested());

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Local session must be cleared on 401
      expect(await storage.isLoggedIn(), isFalse);
      expect(await storage.getAccessToken(), isNull);

      await bloc.close();
    });

    test('Network failure does NOT falsely clear session or claim success', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await storage.saveLoginSession(
        accessToken: 'active_token',
        refreshToken: 'refresh_token',
        userId: 'user_active',
        email: 'active@example.com',
        role: 'CUSTOMER',
        status: 'ACTIVE',
      );
      expect(await storage.isLoggedIn(), isTrue);

      final repo = _FakeLogoutRepository(
        exception: const ApiException(
          message: AppMessages.networkUnavailable,
        ),
      );

      final bloc = LogoutBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      final expectedStates = [
        isA<LogoutLoading>(),
        isA<LogoutFailure>()
            .having((s) => s.message, 'message', AppMessages.networkUnavailable)
            .having((s) => s.sessionCleared, 'sessionCleared', isFalse),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LogoutRequested());

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Session must remain intact on network error
      expect(await storage.isLoggedIn(), isTrue);
      expect(await storage.getAccessToken(), 'active_token');

      await bloc.close();
    });
  });

  group('Logout Feature - UI Confirmation Dialog & Navigation Tests', () {
    testWidgets('Tapping Cancel in confirmation dialog does NOT trigger logout API', (tester) async {
      final repo = _FakeLogoutRepository();
      final bloc = LogoutBloc(repository: repo);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const SettingsView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to reveal Log out tile
      await tester.scrollUntilVisible(find.text('Log out'), 200);
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Are you sure you want to log out of Rivjuuu?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog dismissed, API was NOT called
      expect(find.text('Are you sure you want to log out of Rivjuuu?'), findsNothing);
      expect(repo.capturedAccessToken, isNull);
    });

    testWidgets('Confirming logout triggers API, shows loader, displays backend message and navigates to Login', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final storage = await TokenStorageService.getInstance(prefs: prefs);

      await storage.saveLoginSession(
        accessToken: 'seeded_token',
        refreshToken: 'seeded_refresh',
        userId: 'user_1',
        email: 'u1@example.com',
        role: 'CUSTOMER',
        status: 'ACTIVE',
      );

      final repo = _FakeLogoutRepository(
        customResponse: const LogoutResponse(
          success: 1,
          message: 'Logout successful',
        ),
      );
      final bloc = LogoutBloc(
        repository: repo,
        tokenStorageService: storage,
      );

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen Loaded')),
          },
          home: BlocProvider.value(
            value: bloc,
            child: const SettingsView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open logout confirmation dialog
      await tester.scrollUntilVisible(find.text('Log out'), 200);
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      // Tap confirm 'Log out' button inside dialog
      final confirmLogoutBtn = find.widgetWithText(ElevatedButton, 'Log out');
      expect(confirmLogoutBtn, findsOneWidget);
      await tester.tap(confirmLogoutBtn);
      await tester.pump(); // Advance frame to see loading state

      await tester.pumpAndSettle();

      // API was called with token
      expect(repo.capturedAccessToken, 'seeded_token');

      // Backend message displayed in SnackBar
      expect(find.text('Logout successful'), findsOneWidget);

      // Successfully navigated to Login screen
      expect(find.text('Login Screen Loaded'), findsOneWidget);

      // Session cleared
      expect(await storage.isLoggedIn(), isFalse);
    });
  });
}

