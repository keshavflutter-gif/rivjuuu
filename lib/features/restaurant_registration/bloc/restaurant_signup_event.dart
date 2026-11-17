import 'package:equatable/equatable.dart';

abstract class RestaurantSignupEvent extends Equatable {
  const RestaurantSignupEvent();

  @override
  List<Object?> get props => [];
}

class OwnerNameChanged extends RestaurantSignupEvent {
  final String ownerName;
  const OwnerNameChanged(this.ownerName);

  @override
  List<Object?> get props => [ownerName];
}

class EmailChanged extends RestaurantSignupEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RestaurantSignupEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends RestaurantSignupEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class PasswordVisibilityToggled extends RestaurantSignupEvent {
  const PasswordVisibilityToggled();
}

class ConfirmPasswordVisibilityToggled extends RestaurantSignupEvent {
  const ConfirmPasswordVisibilityToggled();
}

class RestaurantNameChanged extends RestaurantSignupEvent {
  final String restaurantName;
  const RestaurantNameChanged(this.restaurantName);

  @override
  List<Object?> get props => [restaurantName];
}

class RestaurantCategoryChanged extends RestaurantSignupEvent {
  final String category;
  final String categoryId;
  const RestaurantCategoryChanged(this.category, {this.categoryId = ''});

  @override
  List<Object?> get props => [category, categoryId];
}

class RestaurantCityChanged extends RestaurantSignupEvent {
  final String city;
  const RestaurantCityChanged(this.city);

  @override
  List<Object?> get props => [city];
}

class FetchCategoriesRequested extends RestaurantSignupEvent {
  const FetchCategoriesRequested();
}

class RestaurantAddressChanged extends RestaurantSignupEvent {
  final String address;
  const RestaurantAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}

class RestaurantLocationChanged extends RestaurantSignupEvent {
  final double latitude;
  final double longitude;
  final String? locationLabel;

  const RestaurantLocationChanged({
    required this.latitude,
    required this.longitude,
    this.locationLabel,
  });

  @override
  List<Object?> get props => [latitude, longitude, locationLabel];
}

class BusinessDetailsChanged extends RestaurantSignupEvent {
  final String businessDetails;
  const BusinessDetailsChanged(this.businessDetails);

  @override
  List<Object?> get props => [businessDetails];
}

class SupportingDocumentChanged extends RestaurantSignupEvent {
  final String documentPath;
  const SupportingDocumentChanged(this.documentPath);

  @override
  List<Object?> get props => [documentPath];
}

class SupportingDocumentRemoved extends RestaurantSignupEvent {
  const SupportingDocumentRemoved();
}

class TermsAcceptanceChanged extends RestaurantSignupEvent {
  final bool accepted;
  const TermsAcceptanceChanged(this.accepted);

  @override
  List<Object?> get props => [accepted];
}

class ValidateStepRequested extends RestaurantSignupEvent {
  final int stepIndex;
  const ValidateStepRequested(this.stepIndex);

  @override
  List<Object?> get props => [stepIndex];
}

class NextStepRequested extends RestaurantSignupEvent {
  const NextStepRequested();
}

class PreviousStepRequested extends RestaurantSignupEvent {
  const PreviousStepRequested();
}

class GoToStepRequested extends RestaurantSignupEvent {
  final int stepIndex;
  const GoToStepRequested(this.stepIndex);

  @override
  List<Object?> get props => [stepIndex];
}

class SubmitApplicationRequested extends RestaurantSignupEvent {
  const SubmitApplicationRequested();
}

