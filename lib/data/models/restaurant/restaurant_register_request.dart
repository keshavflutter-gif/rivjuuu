import 'package:equatable/equatable.dart';

class RestaurantRegisterRequest extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String restaurantName;
  final String? categoryId;
  final String address;
  final String city;
  final String? latitude;
  final String? longitude;
  final String? description;
  final String? businessDetails;
  final String? documentUrl;
  final bool acceptTerms;

  const RestaurantRegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.restaurantName,
    this.categoryId,
    required this.address,
    this.city = 'Budapest',
    this.latitude,
    this.longitude,
    this.description,
    this.businessDetails,
    this.documentUrl,
    this.acceptTerms = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'ownerName': fullName,
      'email': email.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
      'restaurantName': restaurantName.trim(),
      if (categoryId != null && categoryId!.isNotEmpty) 'categoryId': categoryId,
      'address': address.trim(),
      'city': city.trim().isNotEmpty ? city.trim() : 'Budapest',
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (businessDetails != null && businessDetails!.isNotEmpty)
        'businessDetails': businessDetails,
      if (documentUrl != null && documentUrl!.isNotEmpty)
        'documentUrl': documentUrl,
      'acceptTerms': acceptTerms,
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        restaurantName,
        categoryId,
        address,
        city,
        latitude,
        longitude,
        description,
        businessDetails,
        documentUrl,
        acceptTerms,
      ];
}

