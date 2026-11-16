import '../bloc/restaurant_signup_state.dart';

class RestaurantRegistrationData {
  String ownerName;
  String email;
  String password;
  String confirmPassword;

  String restaurantName;
  String category;
  String address;
  String locationLabel;

  String businessDetail;
  String? uploadedFileName;

  bool agreedToTerms;

  RestaurantRegistrationData({
    this.ownerName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.restaurantName = '',
    this.category = '',
    this.address = '',
    this.locationLabel = 'Set location on map',
    this.businessDetail = '',
    this.uploadedFileName,
    this.agreedToTerms = false,
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
      restaurantAddress: address,
      locationLabel: locationLabel,
      businessDetails: businessDetail,
      supportingDocument: uploadedFileName,
      termsAccepted: agreedToTerms,
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
      address: state.restaurantAddress,
      locationLabel: state.locationLabel ?? 'Set location on map',
      businessDetail: state.businessDetails,
      uploadedFileName: state.supportingDocument,
      agreedToTerms: state.termsAccepted,
    );
  }
}
