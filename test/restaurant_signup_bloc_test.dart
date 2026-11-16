import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_bloc.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_event.dart';
import 'package:rivjuuu/features/restaurant_registration/bloc/restaurant_signup_state.dart';
import 'package:rivjuuu/features/restaurant_registration/repository/restaurant_signup_repository.dart';

class MockFailingRepo implements RestaurantSignupRepository {
  @override
  Future<void> submitRegistration(RestaurantSignupState state) async {
    throw Exception('Server error 500');
  }
}

class MockSuccessRepo implements RestaurantSignupRepository {
  @override
  Future<void> submitRegistration(RestaurantSignupState state) async {}
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

    test('Step navigation proceeds smoothly without validation blocks', () async {
      bloc.add(const OwnerNameChanged('John'));
      bloc.add(const EmailChanged('a'));
      await pumpEventQueue();

      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 1);

      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 2);

      bloc.add(const NextStepRequested());
      await pumpEventQueue();
      expect(bloc.state.currentStepIndex, 3);
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
  });
}
