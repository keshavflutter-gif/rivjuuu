import 'package:equatable/equatable.dart';

/// Strongly typed response model for the Login API.
class LoginResponse extends Equatable {
  final int success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final String? role;
  final LoginUser? user;

  const LoginResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.user,
  });

  bool get isSuccess => success == 1;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] is int
          ? json['success'] as int
          : int.tryParse(json['success']?.toString() ?? '0') ?? 0,
      message: json['message'] as String? ?? '',
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      role: json['role'] as String?,
      user: json['user'] is Map<String, dynamic>
          ? LoginUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (role != null) 'role': role,
      if (user != null) 'user': user!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        success,
        message,
        accessToken,
        refreshToken,
        role,
        user,
      ];
}

class LoginUser extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? role;
  final String? status;
  final CustomerProfile? customerProfile;
  final List<dynamic>? restaurants;

  const LoginUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.role,
    this.status,
    this.customerProfile,
    this.restaurants,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      customerProfile: json['customerProfile'] is Map<String, dynamic>
          ? CustomerProfile.fromJson(
              json['customerProfile'] as Map<String, dynamic>,
            )
          : null,
      restaurants: json['restaurants'] is List
          ? json['restaurants'] as List<dynamic>
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'phone': phone,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (customerProfile != null) 'customerProfile': customerProfile!.toJson(),
      if (restaurants != null) 'restaurants': restaurants,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phone,
        role,
        status,
        customerProfile,
        restaurants,
      ];
}

class CustomerProfile extends Equatable {
  final String id;
  final String? userId;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? createdAt;
  final String? updatedAt;

  const CustomerProfile({
    required this.id,
    this.userId,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (userId != null) 'userId': userId,
      if (displayName != null) 'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        avatarUrl,
        bio,
        createdAt,
        updatedAt,
      ];
}

