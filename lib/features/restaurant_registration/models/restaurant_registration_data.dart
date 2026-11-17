import '../bloc/restaurant_signup_state.dart';

class RestaurantRegistrationData {
  String ownerName;
  String email;
  String password;
  String confirmPassword;

  String restaurantName;
  String category;
  String categoryId;
  String address;
  String city;
  String locationLabel;

  String businessDetail;
  String? uploadedFileName;

  bool agreedToTerms;
  String? restaurantId;
  String? approvalStatus;

  RestaurantRegistrationData({
    this.ownerName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.restaurantName = '',
    this.category = '',
    this.categoryId = '',
    this.address = '',
    this.city = 'Budapest',
    this.locationLabel = 'Set location on map',
    this.businessDetail = '',
    this.uploadedFileName,
    this.agreedToTerms = false,
    this.restaurantId,
    this.approvalStatus,
  });

  RestaurantSignupState toBlocState({int stepIndex = 0}) {
    return RestaurantSignupState(
      currentStepIndex: stepIndex,
      ownerName: ownerName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      restaurantName: restaurantName,
      restaurantCategory: category,
      categoryId: categoryId,
      restaurantAddress: address,
      city: city,
      locationLabel: locationLabel,
      businessDetails: businessDetail,
      supportingDocument: uploadedFileName,
      termsAccepted: agreedToTerms,
      registeredRestaurantId: restaurantId,
      approvalStatus: approvalStatus,
    );
  }

  static RestaurantRegistrationData fromBlocState(RestaurantSignupState state) {
    return RestaurantRegistrationData(
      ownerName: state.ownerName,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      restaurantName: state.restaurantName,
      category: state.restaurantCategory,
      categoryId: state.categoryId,
      address: state.restaurantAddress,
      city: state.city,
      locationLabel: state.locationLabel ?? 'Set location on map',
      businessDetail: state.businessDetails,
      uploadedFileName: state.supportingDocument,
      agreedToTerms: state.termsAccepted,
      restaurantId: state.registeredRestaurantId,
      approvalStatus: state.approvalStatus,
    );
  }
}
