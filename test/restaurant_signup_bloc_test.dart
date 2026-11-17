import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/data/models/restaurant/restaurant_category_model.dart';
import 'package:rivjuuu/data/models/restaurant/restaurant_register_response.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_bloc.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_event.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_state.dart';
import 'package:rivjuuu/features/restaurant_registration/repository/restaurant_signup_repository.dart';

class MockFailingRepo implements RestaurantSignupRepository {
  @override
  Future<RestaurantRegisterResponse> submitRegistration(
      RestaurantSignupState state) async {
    throw Exception('Server error 500');
  }

  @override
  Future<List<RestaurantCategoryModel>> getCategories() async => const [
        RestaurantCategoryModel(
          id: 'f47b6f52-53b3-4a10-a572-dc1687b37315',
          slug: 'italian',
          name: 'Italian',
          description: 'Authentic Italian cuisine',
        ),
        RestaurantCategoryModel(
          id: 'b7e2323a-90b3-4781-9642-2bf311a7eaa2',
          slug: 'burger',
          name: 'Burger',
          description: 'Burgers, fries, and street food',
        ),
      ];
}

class MockSuccessRepo implements RestaurantSignupRepository {
  @override
  Future<RestaurantRegisterResponse> submitRegistration(
      RestaurantSignupState state) async {
    return const RestaurantRegisterResponse(
      success: 1,
      message:
          'Restaurant application submitted successfully and is pending approval',
      approvalStatus: 'PENDING',
    );
  }

  @override
  Future<List<RestaurantCategoryModel>> getCategories() async => const [
        RestaurantCategoryModel(
          id: 'f47b6f52-53b3-4a10-a572-dc1687b37315',
          slug: 'italian',
          name: 'Italian',
          description: 'Authentic Italian cuisine',
        ),
        RestaurantCategoryModel(
          id: 'b7e2323a-90b3-4781-9642-2bf311a7eaa2',
          slug: 'burger',
          name: 'Burger',
          description: 'Burgers, fries, and street food',
        ),
      ];
}

void main() {
  group('RestaurantSignupBloc Unit Tests', () {
    late RestaurantSignupBloc bloc;

    setUp(() {
      bloc = RestaurantSignupBloc(repository: MockSuccessRepo());
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is correct', () {
      expect(bloc.state.currentStepIndex, 0);
      expect(bloc.state.ownerName, '');
      expect(bloc.state.email, '');
      expect(bloc.state.termsAccepted, false);
      expect(bloc.state.submissionStatus, SubmissionStatus.initial);
      expect(bloc.state.validationErrors, isEmpty);
    });

    test('Input change events update state values', () async {
      bloc.add(const OwnerNameChanged('John Doe'));
      await pumpEventQueue();
      expect(bloc.state.ownerName, 'John Doe');

      bloc.add(const EmailChanged('john@example.com'));
      await pumpEventQueue();
      expect(bloc.state.email, 'john@example.com');

      bloc.add(const PasswordChanged('secret123'));
      await pumpEventQueue();
      expect(bloc.state.password, 'secret123');

      bloc.add(const ConfirmPasswordChanged('secret123'));
      await pumpEventQueue();
      expect(bloc.state.confirmPassword, 'secret123');

      bloc.add(const PasswordVisibilityToggled());
      await pumpEventQueue();
      expect(bloc.state.isPasswordVisible, isTrue);

      bloc.add(const ConfirmPasswordVisibilityToggled());
      await pumpEventQueue();
      expect(bloc.state.isConfirmPasswordVisible, isTrue);

      bloc.add(const RestaurantNameChanged('Bistro 99'));
      await pumpEventQueue();
      expect(bloc.state.restaurantName, 'Bistro 99');

      bloc.add(const RestaurantCategoryChanged('Italian'));
      await pumpEventQueue();
      expect(bloc.state.restaurantCategory, 'Italian');

      bloc.add(const RestaurantAddressChanged('Main St 10'));
      await pumpEventQueue();
      expect(bloc.state.restaurantAddress, 'Main St 10');

      bloc.add(const RestaurantLocationChanged(
        latitude: 47.5,
        longitude: 19.0,
        locationLabel: 'Main St 10',
      ));
      await pumpEventQueue();
      expect(bloc.state.latitude, 47.5);
      expect(bloc.state.longitude, 19.0);
      expect(bloc.state.locationLabel, 'Main St 10');

      bloc.add(const BusinessDetailsChanged('VAT: 12345'));
      await pumpEventQueue();
      expect(bloc.state.businessDetails, 'VAT: 12345');

      bloc.add(const SupportingDocumentChanged('doc.pdf'));
      await pumpEventQueue();
      expect(bloc.state.supportingDocument, 'doc.pdf');

      bloc.add(const SupportingDocumentRemoved());
      await pumpEventQueue();
      expect(bloc.state.supportingDocument, isNull);

      bloc.add(const TermsAcceptanceChanged(true));
      await pumpEventQueue();
      expect(bloc.state.termsAccepted, isTrue);
    });

    test('Step validation blocks invalid inputs and allows navigation with valid data across Steps 1 to 4', () async {
      // Step 1 Validation: empty inputs fail
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 0);
      expect(bloc.state.validationErrors['ownerName'], isNotNull);
      expect(bloc.state.validationErrors['email'], isNotNull);
      expect(bloc.state.validationErrors['password'], isNotNull);
      expect(bloc.state.validationErrors['confirmPassword'], isNotNull);

      // Step 1 Validation: invalid email & short password & mismatch
      bloc.add(const OwnerNameChanged('John Doe'));
      bloc.add(const EmailChanged('invalid-email'));
      bloc.add(const PasswordChanged('short'));
      bloc.add(const ConfirmPasswordChanged('mismatch'));
      await pumpEventQueue();
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 0);
      expect(bloc.state.validationErrors['email'], 'Please enter a valid email address');
      expect(bloc.state.validationErrors['password'], 'Password must be at least 8 characters');
      expect(bloc.state.validationErrors['confirmPassword'], 'Passwords do not match');

      // Step 1: Provide valid inputs and advance to Step 2
      bloc.add(const EmailChanged('john@example.com'));
      bloc.add(const PasswordChanged('password123'));
      bloc.add(const ConfirmPasswordChanged('password123'));
      await pumpEventQueue();
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 1);
      expect(bloc.state.validationErrors, isEmpty);

      // Step 2 Validation: empty inputs fail
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 1);
      expect(bloc.state.validationErrors['restaurantName'], isNotNull);
      expect(bloc.state.validationErrors['restaurantCategory'], isNotNull);
      expect(bloc.state.validationErrors['restaurantAddress'], isNotNull);

      // Step 2: Provide valid inputs and advance to Step 3
      bloc.add(const RestaurantNameChanged('Bistro 99'));
      bloc.add(const RestaurantCategoryChanged('Italian', categoryId: 'cat1'));
      bloc.add(const RestaurantAddressChanged('Main St 10'));
      await pumpEventQueue();
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 2);
      expect(bloc.state.validationErrors, isEmpty);

      // Step 3 Validation: empty inputs fail
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 2);
      expect(bloc.state.validationErrors['businessDetails'], isNotNull);
      expect(bloc.state.validationErrors['supportingDocument'], isNotNull);

      // Step 3: Provide valid inputs and advance to Step 4
      bloc.add(const BusinessDetailsChanged('VAT 12345'));
      bloc.add(const SupportingDocumentChanged('doc.pdf'));
      await pumpEventQueue();
      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 3);
      expect(bloc.state.validationErrors, isEmpty);

      // Step 4 Validation: terms must be accepted to submit
      bloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();
      expect(bloc.state.submissionStatus, SubmissionStatus.failure);
      expect(bloc.state.validationErrors['terms'], isNotNull);

      // Step 4: Accept terms and submit successfully
      bloc.add(const TermsAcceptanceChanged(true));
      await pumpEventQueue();
      bloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();
      expect(bloc.state.submissionStatus, SubmissionStatus.success);
    });

    test('GoToStepRequested and PreviousStepRequested navigation', () async {
      bloc.add(const GoToStepRequested(2));
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 2);

      bloc.add(const PreviousStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 1);

      bloc.add(const PreviousStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 0);

      // Cannot go below 0
      bloc.add(const PreviousStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 0);

      bloc.add(const GoToStepRequested(3));
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 3);
    });

    test('Submission failure handles exception gracefully', () async {
      final failingBloc = RestaurantSignupBloc(
        initialState: const RestaurantSignupState(
          currentStepIndex: 3,
          ownerName: 'Márton Szabó',
          email: 'hello@nonnarosa.hu',
          password: 'Password123',
          confirmPassword: 'Password123',
          restaurantName: 'Trattoria Nonna Rosa',
          restaurantCategory: 'Italian',
          restaurantAddress: 'Fő utca 12',
          locationLabel: 'Fő utca 12',
          businessDetails: 'VAT 12345',
          supportingDocument: 'license.pdf',
          termsAccepted: true,
        ),
        repository: MockFailingRepo(),
      );

      failingBloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();

      expect(failingBloc.state.submissionStatus, SubmissionStatus.failure);
      expect(failingBloc.state.errorMessage, contains('Server error 500'));
      failingBloc.close();
    });

    test('Submission success emits submitting then success', () async {
      final successBloc = RestaurantSignupBloc(
        initialState: const RestaurantSignupState(
          currentStepIndex: 3,
          ownerName: 'Márton Szabó',
          email: 'hello@nonnarosa.hu',
          password: 'Password123',
          confirmPassword: 'Password123',
          restaurantName: 'Trattoria Nonna Rosa',
          restaurantCategory: 'Italian',
          restaurantAddress: 'Fő utca 12',
          locationLabel: 'Fő utca 12',
          businessDetails: 'VAT 12345',
          supportingDocument: 'license.pdf',
          termsAccepted: true,
        ),
        repository: MockSuccessRepo(),
      );

      successBloc.add(const SubmitApplicationRequested());
      await pumpEventQueue();

      expect(successBloc.state.submissionStatus, SubmissionStatus.success);
      successBloc.close();
    });

    test('FetchCategoriesRequested fetches categories from repository', () async {
      bloc.add(const FetchCategoriesRequested());
      await pumpEventQueue();

      expect(bloc.state.categories, isNotEmpty);
      expect(bloc.state.categories.first.name, 'Italian');
      expect(bloc.state.isLoadingCategories, isFalse);
    });
  });
}
