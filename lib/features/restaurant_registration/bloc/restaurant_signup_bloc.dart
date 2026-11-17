import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/restaurant_signup_repository.dart';
import 'restaurant_signup_event.dart';
import 'restaurant_signup_state.dart';

class RestaurantSignupBloc
    extends Bloc<RestaurantSignupEvent, RestaurantSignupState> {
  final RestaurantSignupRepository _repository;

  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  RestaurantSignupBloc({
    RestaurantSignupState? initialState,
    RestaurantSignupRepository? repository,
  })  : _repository = repository ?? DefaultRestaurantSignupRepository(),
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
    on<RestaurantCityChanged>(_onRestaurantCityChanged);
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
    on<FetchCategoriesRequested>(_onFetchCategoriesRequested);
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
      categoryId:
          event.categoryId.isNotEmpty ? event.categoryId : state.categoryId,
      validationErrors: errors,
    ));
  }

  void _onRestaurantCityChanged(
    RestaurantCityChanged event,
    Emitter<RestaurantSignupState> emit,
  ) {
    final errors = Map<String, String>.from(state.validationErrors)
      ..remove('city');
    emit(state.copyWith(
      city: event.city,
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
    final errors = <String, String>{};

    switch (stepIndex) {
      case 0: // Step 1: Account information
        if (state.ownerName.trim().isEmpty) {
          errors['ownerName'] = 'Owner or contact name is required';
        } else if (state.ownerName.trim().length < 2) {
          errors['ownerName'] = 'Please enter a valid full name';
        }

        if (state.email.trim().isEmpty) {
          errors['email'] = 'Email address is required';
        } else if (!_emailRegex.hasMatch(state.email.trim())) {
          errors['email'] = 'Please enter a valid email address';
        }

        if (state.password.isEmpty) {
          errors['password'] = 'Password is required';
        } else if (state.password.length < 8) {
          errors['password'] = 'Password must be at least 8 characters';
        } else if (state.password.trim().isEmpty) {
          errors['password'] = 'Password cannot be empty or only whitespace';
        }

        if (state.confirmPassword.isEmpty) {
          errors['confirmPassword'] = 'Please confirm your password';
        } else if (state.confirmPassword != state.password) {
          errors['confirmPassword'] = 'Passwords do not match';
        }
        break;

      case 1: // Step 2: Restaurant information
        if (state.restaurantName.trim().isEmpty) {
          errors['restaurantName'] = 'Restaurant name is required';
        } else if (state.restaurantName.trim().length < 2) {
          errors['restaurantName'] = 'Please enter a valid restaurant name';
        }

        if (state.restaurantCategory.trim().isEmpty) {
          errors['restaurantCategory'] = 'Please select a category';
        }

        if (state.restaurantAddress.trim().isEmpty) {
          errors['restaurantAddress'] = 'Address is required';
        }
        break;

      case 2: // Step 3: Business information
        if (state.businessDetails.trim().isEmpty) {
          errors['businessDetails'] = 'Business detail is required';
        }

        if (state.supportingDocument == null ||
            state.supportingDocument!.trim().isEmpty) {
          errors['supportingDocument'] = 'Please upload a supporting document';
        }
        break;

      case 3: // Step 4: Review and submit
        if (!state.termsAccepted) {
          errors['terms'] =
              'You must agree to the Terms and Conditions and Privacy Policy';
        }
        break;
    }

    return errors;
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
      final nextStep = state.currentStepIndex + 1;
      emit(state.copyWith(
        currentStepIndex: nextStep,
        validationErrors: const {},
      ));
      if (nextStep == 1 && state.categories.isEmpty) {
        add(const FetchCategoriesRequested());
      }
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
      if (event.stepIndex == 1 && state.categories.isEmpty) {
        add(const FetchCategoriesRequested());
      }
    }
  }

  Future<void> _onFetchCategoriesRequested(
    FetchCategoriesRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    emit(state.copyWith(isLoadingCategories: true));
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        categories: categories,
        isLoadingCategories: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingCategories: false));
    }
  }

  Future<void> _onSubmitApplicationRequested(
    SubmitApplicationRequested event,
    Emitter<RestaurantSignupState> emit,
  ) async {
    if (state.isSubmitting) return;

    final errors = <String, String>{};
    for (int step = 0; step <= 3; step++) {
      errors.addAll(_validateStep(step));
    }

    if (errors.isNotEmpty) {
      emit(state.copyWith(
        validationErrors: errors,
        submissionStatus: SubmissionStatus.failure,
        errorMessage: errors.values.first,
      ));
      return;
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submitting,
      clearErrorMessage: true,
    ));

    try {
      final response = await _repository.submitRegistration(state);
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.success,
        registeredRestaurantId: response.restaurantId,
        approvalStatus: response.approvalStatus ?? 'PENDING',
      ));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.failure,
        errorMessage: e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
      ));
    }
  }
}

