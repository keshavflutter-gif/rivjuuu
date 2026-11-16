import 'package:equatable/equatable.dart';

class CustomerRegisterResponse extends Equatable {
  final int success;
  final String message;
  final String? userId;
  final String? accessToken;
  final String? refreshToken;
  final CustomerRegisterUser? user;

  const CustomerRegisterResponse({
    required this.success,
    required this.message,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  bool get isSuccessful => success == 1 && accessToken != null && accessToken!.isNotEmpty;

  factory CustomerRegisterResponse.fromJson(Map<String, dynamic> json) {
    int parsedSuccess = 0;
    if (json['success'] is int) {
      parsedSuccess = json['success'] as int;
    } else if (json['success'] is String) {
      parsedSuccess = int.tryParse(json['success'] as String) ?? 0;
    } else if (json['success'] is bool) {
      parsedSuccess = (json['success'] as bool) ? 1 : 0;
    }

    return CustomerRegisterResponse(
      success: parsedSuccess,
      message: (json['message'] ?? '').toString(),
      userId: json['userId']?.toString(),
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? CustomerRegisterUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (userId != null) 'userId': userId,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (user != null) 'user': user!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        success,
        message,
        userId,
        accessToken,
        refreshToken,
        user,
      ];
}

class CustomerRegisterUser extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String displayName;
  final String? phone;
  final String role;
  final String status;

  const CustomerRegisterUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    this.phone,
    required this.role,
    required this.status,
  });

  factory CustomerRegisterUser.fromJson(Map<String, dynamic> json) {
    return CustomerRegisterUser(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      displayName: (json['displayName'] ?? '').toString(),
      phone: json['phone']?.toString(),
      role: (json['role'] ?? 'CUSTOMER').toString(),
      status: (json['status'] ?? 'ACTIVE').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'phone': phone,
      'role': role,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        displayName,
        phone,
        role,
        status,
      ];
}

