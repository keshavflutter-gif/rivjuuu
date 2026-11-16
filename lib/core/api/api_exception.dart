import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final Map<String, String>? fieldErrors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.fieldErrors,
  });

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Network unavailable. Please check your internet connection.',
          statusCode: null,
        );

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;
        final responseData = response?.data;

        String extractedMessage = 'An unexpected server error occurred.';
        Map<String, String> extractedFieldErrors = {};

        if (responseData is Map<String, dynamic>) {
          // 1. Check for top-level message
          if (responseData['message'] != null &&
              responseData['message'].toString().trim().isNotEmpty) {
            extractedMessage = responseData['message'].toString().trim();
          } else if (responseData['error'] != null &&
              responseData['error'].toString().trim().isNotEmpty) {
            extractedMessage = responseData['error'].toString().trim();
          }

          // 2. Check for backend field-specific validation errors
          // Example backend returns: "errors": [{"path": "email", "message": "Email is required"}]
          if (responseData['errors'] is List) {
            final list = responseData['errors'] as List;
            for (final item in list) {
              if (item is Map) {
                final field = (item['path'] ?? item['field'] ?? item['param'])?.toString();
                final msg = item['message']?.toString();
                if (field != null && msg != null) {
                  extractedFieldErrors[field] = msg;
                }
              }
            }
          }
        } else if (responseData is String && responseData.trim().isNotEmpty) {
          if (!responseData.startsWith('<')) {
            extractedMessage = responseData.trim();
          }
        }

        // Status code fallback if message is generic
        if (extractedMessage == 'An unexpected server error occurred.') {
          switch (statusCode) {
            case 400:
              extractedMessage = 'Invalid request. Please check your details.';
              break;
            case 401:
              extractedMessage = 'Unauthorized. Please login again.';
              break;
            case 403:
              extractedMessage = 'Access denied. You do not have permission.';
              break;
            case 404:
              extractedMessage = 'Requested service not found.';
              break;
            case 409:
              extractedMessage = 'An account with this email already exists.';
              break;
            case 422:
              extractedMessage = 'Validation failed. Please check your input.';
              break;
            case 500:
            case 502:
            case 503:
              extractedMessage = 'Server error occurred. Please try again later.';
              break;
          }
        }

        return ApiException(
          message: extractedMessage,
          statusCode: statusCode,
          data: responseData,
          fieldErrors: extractedFieldErrors.isNotEmpty ? extractedFieldErrors : null,
        );

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          statusCode: null,
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Certificate verification failed.',
          statusCode: null,
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: error.message?.isNotEmpty == true &&
                  !error.message!.contains('SocketException')
              ? error.message!
              : 'Network unavailable. Please check your internet connection.',
          statusCode: null,
        );
    }
  }

  @override
  String toString() => message;
}

