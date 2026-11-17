import 'package:equatable/equatable.dart';

class RestaurantRegisterResponse extends Equatable {
  final int success;
  final String message;
  final String? userId;
  final String? restaurantId;
  final String? approvalStatus;
  final RegisteredRestaurant? restaurant;

  const RestaurantRegisterResponse({
    required this.success,
    required this.message,
    this.userId,
    this.restaurantId,
    this.approvalStatus,
    this.restaurant,
  });

  bool get isSuccess => success == 1;

  factory RestaurantRegisterResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantRegisterResponse(
      success: json['success'] is int
          ? json['success'] as int
          : int.tryParse(json['success']?.toString() ?? '0') ?? 0,
      message: json['message'] as String? ?? '',
      userId: json['userId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      approvalStatus: json['approvalStatus'] as String?,
      restaurant: json['restaurant'] is Map<String, dynamic>
          ? RegisteredRestaurant.fromJson(
              json['restaurant'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (userId != null) 'userId': userId,
      if (restaurantId != null) 'restaurantId': restaurantId,
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
      if (restaurant != null) 'restaurant': restaurant!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        success,
        message,
        userId,
        restaurantId,
        approvalStatus,
        restaurant,
      ];
}

class RegisteredRestaurant extends Equatable {
  final String? name;
  final String? description;
  final String? address;
  final String? city;
  final String? latitude;
  final String? longitude;
  final String? documentUrl;

  const RegisteredRestaurant({
    this.name,
    this.description,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.documentUrl,
  });

  factory RegisteredRestaurant.fromJson(Map<String, dynamic> json) {
    return RegisteredRestaurant(
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      documentUrl: json['documentUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (documentUrl != null) 'documentUrl': documentUrl,
    };
  }

  @override
  List<Object?> get props => [
        name,
        description,
        address,
        city,
        latitude,
        longitude,
        documentUrl,
      ];
}

