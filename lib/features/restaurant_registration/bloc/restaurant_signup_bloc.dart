import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/restaurant_signup_repository.dart';
import 'restaurant_signup_event.dart';
import 'restaurant_signup_state.dart';

class RestaurantSignupBloc
    extends Bloc<RestaurantSignupEvent, RestaurantSignupState> {
  final RestaurantSignupRepository _repository;

  // static final RegExp _emailRegex =
  //     RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  RestaurantSignupBloc({
    RestaurantSignupState? initialState,
    RestaurantSignupRepository? repository,
  })  : _repository = repository ?? const DefaultRestaurantSignupRepository(),
        super(initialState ?? const RestaurantSignupState()) {
    on<OwnerNameChanged>(_onOwnerNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<ConfirmPasswordVisibilityToggled>(_onConfirmPasswordVisibilityToggled);
    on<RestaurantNameChanged>(_onRestaurantNameChanged);
    on<RestaurantCategoryChanged>(_onRestaurantCategoryChanged);
    on<RestaurantAddressChanged>(_onRestaurantAddressChanged);
    on<RestaurantLocationChanged>(_onRestaurantLocationChanged);
    on<BusinessDetailsChanged>(_onBusinessDetailsChanged);
    on<SupportingDocumentChanged>(_onSupportingDocumentChanged);
    on<SupportingDocumentRemoved>(_onSupportingDocumentRemoved);
    on<TermsAcceptanceChanged>(_onTermsAcceptanceChanged);
    on<ValidateStepRequested>(_onValidateStepRequested);
    on<NextStepRequested>(_onNextStepRequested);
    on<PreviousStepRequested>(_onPreviousStepRequested);
    on<GoToStepRequested>(_onGoToStepRequested);
    on<SubmitApplicationRequested>(_onSubmitApplicationRequested);
  }

  void _onOwnerNameChanged(
    OwnerNameChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('ownerName');
    emit(state.copyWith(
      ownerName: event.ownerName,
      validationErrors: errors,
    ));
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('email');
    emit(state.copyWith(
      email: event.email,
      validationErrors: errors,
    ));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('password')
      ..remove('confirmPassword');
    emit(state.copyWith(
      password: event.password,
      validationErrors: errors,
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('confirmPassword');
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      validationErrors: errors,
    ));
  }

  void _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<RestaurantSignupState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onConfirmPasswordVisibilityToggled(
    ConfirmPasswordVisibilityToggled event,
    Emitter<RestaurantSignupState> emit,
  ) {
    emit(state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    ));
  }

  void _onRestaurantNameChanged(
    RestaurantNameChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('restaurantName');
    emit(state.copyWith(
      restaurantName: event.restaurantName,
      validationErrors: errors,
    ));
  }

  void _onRestaurantCategoryChanged(
    RestaurantCategoryChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('restaurantCategory');
    emit(state.copyWith(
      restaurantCategory: event.category,
      validationErrors: errors,
    ));
  }

  void _onRestaurantAddressChanged(
    RestaurantAddressChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('restaurantAddress');
    emit(state.copyWith(
      restaurantAddress: event.address,
      validationErrors: errors,
    ));
  }

  void _onRestaurantLocationChanged(
    RestaurantLocationChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('restaurantLocation');
    emit(state.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
      locationLabel: event.locationLabel,
      validationErrors: errors,
    ));
  }

  void _onBusinessDetailsChanged(
    BusinessDetailsChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('businessDetails');
    emit(state.copyWith(
      businessDetails: event.businessDetails,
      validationErrors: errors,
    ));
  }

  void _onSupportingDocumentChanged(
    SupportingDocumentChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('supportingDocument');
    emit(state.copyWith(
      supportingDocument: event.documentPath,
      validationErrors: errors,
    ));
  }

  void _onSupportingDocumentRemoved(
    SupportingDocumentRemoved event,
    Emitter<RestaurantSignupState> emit,
  ) {
    emit(state.copyWith(clearSupportingDocument: true));
  }

  void _onTermsAcceptanceChanged(
    TermsAcceptanceChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('terms');
    emit(state.copyWith(
      termsAccepted: event.accepted,
      validationErrors: errors,
    ));
  }

  Map<String, String> _validateStep(int stepIndex) {
    // Validation temporarily disabled per user request
    return <String, String>{};
  }

  void _onValidateStepRequested(
    ValidateStepRequested event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = _validateStep(event.stepIndex);
    emit(state.copyWith(validationErrors: errors));
  }

  void _onNextStepRequested(
    NextStepRequested event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = _validateStep(state.currentStepIndex);
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }

    if (state.currentStepIndex < 3) {
      emit(state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        validationErrors: const {},
      ));
    }
  }

  void _onPreviousStepRequested(
    PreviousStepRequested event,
    Emitter<RestaurantSignupState> emit,
  ) {
    if (state.currentStepIndex > 0) {
      emit(state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
        validationErrors: const {},
      ));
    }
  }

  void _onGoToStepRequested(
    GoToStepRequested event,
    Emitter<RestaurantSignupState> emit,
  ) {
    if (event.stepIndex >= 0 && event.stepIndex <= 3) {
      emit(state.copyWith(
        currentStepIndex: event.stepIndex,
        validationErrors: const {},
      ));
    }
  }

  Future<void> _onSubmitApplicationRequested(
    SubmitApplicationRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    if (state.isSubmitting) return;

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submitting,
      clearErrorMessage: true,
    ));

    try {
      await _repository.submitRegistration(state);
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

