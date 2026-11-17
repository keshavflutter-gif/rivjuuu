import 'package:equatable/equatable.dart';
import '../../../data/models/restaurant/restaurant_category_model.dart';

enum SubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class RestaurantSignupState extends Equatable {
  final int currentStepIndex; // 0: Step 1, 1: Step 2, 2: Step 3, 3: Step 4
  final String ownerName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  final String restaurantName;
  final String restaurantCategory;
  final String categoryId;
  final String restaurantAddress;
  final String city;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;

  final String businessDetails;
  final String? supportingDocument;

  final bool termsAccepted;
  final SubmissionStatus submissionStatus;
  final Map<String, String> validationErrors;
  final String? errorMessage;

  final List<RestaurantCategoryModel> categories;
  final bool isLoadingCategories;
  final String? registeredRestaurantId;
  final String? approvalStatus;

  const RestaurantSignupState({
    this.currentStepIndex = 0,
    this.ownerName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.restaurantName = '',
    this.restaurantCategory = '',
    this.categoryId = '',
    this.restaurantAddress = '',
    this.city = 'Budapest',
    this.latitude,
    this.longitude,
    this.locationLabel,
    this.businessDetails = '',
    this.supportingDocument,
    this.termsAccepted = false,
    this.submissionStatus = SubmissionStatus.initial,
    this.validationErrors = const {},
    this.errorMessage,
    this.categories = const [],
    this.isLoadingCategories = false,
    this.registeredRestaurantId,
    this.approvalStatus,
  });

  bool get isSubmitting => submissionStatus == SubmissionStatus.submitting;
  bool get isSuccess => submissionStatus == SubmissionStatus.success;
  bool get isFailure => submissionStatus == SubmissionStatus.failure;

  RestaurantSignupState copyWith({
    int? currentStepIndex,
    String? ownerName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? restaurantName,
    String? restaurantCategory,
    String? categoryId,
    String? restaurantAddress,
    String? city,
    double? latitude,
    double? longitude,
    String? locationLabel,
    String? businessDetails,
    String? supportingDocument,
    bool? clearSupportingDocument,
    bool? termsAccepted,
    SubmissionStatus? submissionStatus,
    Map<String, String>? validationErrors,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<RestaurantCategoryModel>? categories,
    bool? isLoadingCategories,
    String? registeredRestaurantId,
    String? approvalStatus,
  }) {
    return RestaurantSignupState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantCategory: restaurantCategory ?? this.restaurantCategory,
      categoryId: categoryId ?? this.categoryId,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationLabel: locationLabel ?? this.locationLabel,
      businessDetails: businessDetails ?? this.businessDetails,
      supportingDocument: clearSupportingDocument == true
          ? null
          : (supportingDocument ?? this.supportingDocument),
      termsAccepted: termsAccepted ?? this.termsAccepted,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      validationErrors: validationErrors ?? this.validationErrors,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      registeredRestaurantId:
          registeredRestaurantId ?? this.registeredRestaurantId,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }

  @override
  List<Object?> get props => [
        currentStepIndex,
        ownerName,
        email,
        password,
        confirmPassword,
        isPasswordVisible,
        isConfirmPasswordVisible,
        restaurantName,
        restaurantCategory,
        categoryId,
        restaurantAddress,
        city,
        latitude,
        longitude,
        locationLabel,
        businessDetails,
        supportingDocument,
        termsAccepted,
        submissionStatus,
        validationErrors,
        errorMessage,
        categories,
        isLoadingCategories,
        registeredRestaurantId,
        approvalStatus,
      ];
}
