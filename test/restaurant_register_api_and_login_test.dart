import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/core/storage/token_storage_service.dart';
import 'package:rivjuuu/data/models/auth/login_request.dart';
import 'package:rivjuuu/data/models/auth/login_response.dart';
import 'package:rivjuuu/data/models/restaurant/restaurant_category_model.dart';
import 'package:rivjuuu/data/models/restaurant/restaurant_register_response.dart';
import 'package:rivjuuu/data/repositories/auth/login_repository.dart';
import 'package:rivjuuu/features/auth/bloc/login_bloc.dart';
import 'package:rivjuuu/features/auth/view/login_view.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_bloc.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_event.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_state.dart';
import 'package:rivjuuu/features/restaurant_registration/models/restaurant_registration_data.dart';
import 'package:rivjuuu/features/restaurant_registration/repository/restaurant_signup_repository.dart';
import 'package:rivjuuu/features/restaurant_registration/view/registration_rejected_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeLoginRepository implements LoginRepository {
  final LoginResponse response;

  const _FakeLoginRepository(this.response);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return response;
  }
}

class _TestRestaurantRepo implements RestaurantSignupRepository {
  final RestaurantRegisterResponse response;

  const _TestRestaurantRepo({
    required this.response,
  });

  @override
  Future<RestaurantRegisterResponse> submitRegistration(
      RestaurantSignupState state) async {
    return response;
  }

  @override
  Future<List<RestaurantCategoryModel>> getCategories() async => const [];
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TokenStorageService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  group('Restaurant Models and Serialization', () {
    test('RestaurantCategoryModel deserializes API response properly', () {
      final json = {
        'id': 'b7e2323a-90b3-4781-9642-2bf311a7eaa2',
        'slug': 'burger',
        'name': 'Burger',
        'description': 'Burgers, fries, and street food',
        'status': 'ACTIVE',
        'sortOrder': 2,
        'restaurantsCount': 0,
        'translations': [
          {
            'id': '4c05e8cd-5c05-414a-b6df-eff86954d523',
            'categoryId': 'b7e2323a-90b3-4781-9642-2bf311a7eaa2',
            'locale': 'en',
            'name': 'Burger',
            'description': 'Burgers, fries, and street food'
          }
        ]
      };

      final model = RestaurantCategoryModel.fromJson(json);
      expect(model.id, 'b7e2323a-90b3-4781-9642-2bf311a7eaa2');
      expect(model.name, 'Burger');
      expect(model.slug, 'burger');
      expect(model.translations?.length, 1);
      expect(model.translations?.first.locale, 'en');
    });

    test('RestaurantRegisterResponse deserializes exact API response format', () {
      final json = {
        'success': 1,
        'message':
            'Restaurant application submitted successfully and is pending approval',
        'userId': '836e853f-3be0-4ce6-b6d5-f2092a57f642',
        'restaurantId': 'abd0bd3a-4660-4ed7-9957-28c1f5cb9315',
        'approvalStatus': 'PENDING',
        'restaurant': {
          'name': 'Trattoria Nonna Rosa',
          'description': 'Authentic Italian kitchen',
          'address': 'Fő utca 12',
          'city': 'Budapest',
          'latitude': '47.4979',
          'longitude': '19.0402',
          'documentUrl':
              'http://server.keshavinfotechdemo2.com:4020/uploads/documents/doc.pdf'
        }
      };

      final response = RestaurantRegisterResponse.fromJson(json);
      expect(response.isSuccess, isTrue);
      expect(response.approvalStatus, 'PENDING');
      expect(response.restaurantId, 'abd0bd3a-4660-4ed7-9957-28c1f5cb9315');
      expect(response.restaurant?.name, 'Trattoria Nonna Rosa');
      expect(response.restaurant?.city, 'Budapest');
      expect(response.restaurant?.documentUrl, contains('doc.pdf'));
    });
  });

  group('RestaurantSignupBloc API Integration', () {
    test('SubmitApplicationRequested calls repository and stores approvalStatus',
        () async {
      const mockResponse = RestaurantRegisterResponse(
        success: 1,
        message:
            'Restaurant application submitted successfully and is pending approval',
        userId: 'u1',
        restaurantId: 'r1',
        approvalStatus: 'PENDING',
      );

      final repo = _TestRestaurantRepo(response: mockResponse);
      final bloc = RestaurantSignupBloc(
        initialState: const RestaurantSignupState(
          currentStepIndex: 3,
          ownerName: 'Márton Szabó',
          email: 'hello@nonnarosa.hu',
          password: 'Password123!',
          confirmPassword: 'Password123!',
          restaurantName: 'Trattoria Nonna Rosa',
          restaurantCategory: 'Italian',
          restaurantAddress: 'Fő utca 12',
          city: 'Budapest',
          businessDetails: 'Authentic Italian kitchen',
          supportingDocument: 'business_license.pdf',
          termsAccepted: true,
        ),
        repository: repo,
      );

      bloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();

      expect(bloc.state.submissionStatus, SubmissionStatus.success);
      expect(bloc.state.approvalStatus, 'PENDING');
      expect(bloc.state.registeredRestaurantId, 'r1');

      await bloc.close();
    });

    test('SubmitApplicationRequested fails with validation error if terms not accepted',
        () async {
      const mockResponse = RestaurantRegisterResponse(
        success: 1,
        message: 'Success',
      );

      final repo = _TestRestaurantRepo(response: mockResponse);
      final bloc = RestaurantSignupBloc(
        initialState: const RestaurantSignupState(
          currentStepIndex: 3,
          ownerName: 'Márton Szabó',
          email: 'hello@nonnarosa.hu',
          password: 'Password123!',
          confirmPassword: 'Password123!',
          restaurantName: 'Trattoria Nonna Rosa',
          restaurantCategory: 'Italian',
          restaurantAddress: 'Fő utca 12',
          city: 'Budapest',
          businessDetails: 'Authentic Italian kitchen',
          supportingDocument: 'business_license.pdf',
          termsAccepted: false, // NOT ACCEPTED
        ),
        repository: repo,
      );

      bloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();

      expect(bloc.state.submissionStatus, SubmissionStatus.failure);
      expect(bloc.state.validationErrors['terms'], isNotNull);

      await bloc.close();
    });
  });

  group('Login Check for Restaurant Approval Status Navigation', () {
    testWidgets('Login with RESTAURANT role and PENDING approval navigates to RegistrationPendingPage',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const loginResp = LoginResponse(
        success: 1,
        message: 'Login successful',
        accessToken: 'token_123',
        refreshToken: 'refresh_123',
        role: 'RESTAURANT',
        user: LoginUser(
          id: 'user_rest_1',
          email: 'hello@nonnarosa.hu',
          firstName: 'Márton',
          lastName: 'Szabó',
          role: 'RESTAURANT',
          restaurants: [
            {
              'id': 'rest_uuid_1',
              'name': 'Trattoria Nonna Rosa',
              'category': 'Italian',
              'address': 'Fő utca 12, Hungary',
              'approvalStatus': 'PENDING',
              'status': 'ACTIVE',
            }
          ],
        ),
      );

      final bloc = LoginBloc(
        repository: const _FakeLoginRepository(loginResp),
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginViewPageForTest(bloc: bloc),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'hello@nonnarosa.hu');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();

      // Navigates to Application under review without showing Login successful
      expect(find.text('Application under review'), findsOneWidget);
      expect(find.text('Pending review'), findsOneWidget);
      expect(find.text('Login successful'), findsNothing);
    });

    testWidgets('Login with RESTAURANT role and APPROVED approval navigates directly to Home Screen (RestaurantDashboardPage)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const loginResp = LoginResponse(
        success: 1,
        message: 'Login successful',
        accessToken: 'token_123',
        refreshToken: 'refresh_123',
        role: 'RESTAURANT',
        user: LoginUser(
          id: 'user_rest_1',
          email: 'hello@nonnarosa.hu',
          firstName: 'Márton',
          lastName: 'Szabó',
          role: 'RESTAURANT',
          restaurants: [
            {
              'id': 'rest_uuid_1',
              'name': 'Trattoria Nonna Rosa',
              'category': 'Italian',
              'address': 'Fő utca 12, Hungary',
              'approvalStatus': 'APPROVED',
              'status': 'ACTIVE',
            }
          ],
        ),
      );

      final bloc = LoginBloc(
        repository: const _FakeLoginRepository(loginResp),
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginViewPageForTest(bloc: bloc),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'hello@nonnarosa.hu');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();

      // Navigates directly to Restaurant Home Screen with Login successful snackbar
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Login successful'), findsOneWidget);
    });

    testWidgets('Login with RESTAURANT role and REJECTED approval navigates to RegistrationRejectedPage',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const loginResp = LoginResponse(
        success: 1,
        message: 'Login successful',
        accessToken: 'token_123',
        refreshToken: 'refresh_123',
        role: 'RESTAURANT',
        user: LoginUser(
          id: 'user_rest_1',
          email: 'hello@nonnarosa.hu',
          firstName: 'Márton',
          lastName: 'Szabó',
          role: 'RESTAURANT',
          restaurants: [
            {
              'id': 'rest_uuid_1',
              'name': 'Trattoria Nonna Rosa',
              'category': 'Italian',
              'address': 'Fő utca 12, Hungary',
              'approvalStatus': 'REJECTED',
              'status': 'ACTIVE',
            }
          ],
        ),
      );

      final bloc = LoginBloc(
        repository: const _FakeLoginRepository(loginResp),
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: LoginViewPageForTest(bloc: bloc),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'hello@nonnarosa.hu');
      await tester.enterText(find.byType(TextField).at(1), 'Password123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();

      // Navigates to Application not approved without showing Login successful
      expect(find.text('Application not approved'), findsOneWidget);
      expect(find.text('Not approved'), findsOneWidget);
      expect(find.text('Login successful'), findsNothing);
      expect(find.text('Message from the review team'), findsOneWidget);
      expect(find.text('Contact support'), findsOneWidget);
      expect(find.text('View submitted details'), findsOneWidget);
    });
  });

  group('RegistrationRejectedPage Widget Test', () {
    testWidgets('Renders all elements matching registration-rejected design',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final data = RestaurantRegistrationData(
        ownerName: 'Márton Szabó',
        email: 'hello@nonnarosa.hu',
        restaurantName: 'Trattoria Nonna Rosa',
        category: 'Italian',
        address: 'Fő utca 12, Hungary',
        businessDetail: 'Tax ID: HU12345678',
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: RegistrationRejectedPage(
            data: data,
            rejectionReason: 'Missing food safety certification.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Application not approved'), findsOneWidget);
      expect(find.text('Not approved'), findsOneWidget);
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('hello@nonnarosa.hu'), findsOneWidget);
      expect(find.text('Message from the review team'), findsOneWidget);
      expect(find.text('Missing food safety certification.'), findsOneWidget);
      expect(find.text('Contact support'), findsOneWidget);
      expect(find.text('View submitted details'), findsOneWidget);

      // Open submitted details bottom sheet
      await tester.tap(find.text('View submitted details'));
      await tester.pumpAndSettle();

      expect(find.text('Submitted details'), findsOneWidget);
      expect(find.text('Owner name'), findsOneWidget);
      expect(find.text('Tax ID: HU12345678'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });
  });
}

class LoginViewPageForTest extends StatelessWidget {
  final LoginBloc bloc;

  const LoginViewPageForTest({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: const LoginView(),
    );
  }
}
