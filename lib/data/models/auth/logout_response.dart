import 'package:equatable/equatable.dart';

/// Strongly typed response model for the Logout API.
class LogoutResponse extends Equatable {
  final int success;
  final String message;

  const LogoutResponse({
    required this.success,
    required this.message,
  });

  bool get isSuccess => success == 1;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] is int
          ? json['success'] as int
          : int.tryParse(json['success']?.toString() ?? '0') ?? 0,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [success, message];
}

