import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._internal({Dio? customDio}) {
    _dio = customDio ??
        Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: ApiEndpoints.connectTimeout,
            receiveTimeout: ApiEndpoints.receiveTimeout,
            sendTimeout: ApiEndpoints.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            responseType: ResponseType.json,
          ),
        );

    _dio.interceptors.add(_createLoggingInterceptor());
  }

  factory ApiClient({Dio? customDio}) {
    if (customDio != null) {
      return ApiClient._internal(customDio: customDio);
    }
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          final buffer = StringBuffer();
          buffer.writeln('======================================================================');
          buffer.writeln('--> [API REQUEST] 🚀 ${options.method} ${options.uri}');
          if (options.headers.isNotEmpty) {
            buffer.writeln('Headers: ${options.headers}');
          }
          if (options.data != null) {
            buffer.writeln('Request Body:\n${_formatJson(options.data)}');
          }
          buffer.writeln('======================================================================');
          debugPrint(buffer.toString());
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          final buffer = StringBuffer();
          buffer.writeln('======================================================================');
          buffer.writeln('<-- [API RESPONSE - ${response.statusCode}] 📥 ${response.requestOptions.method} ${response.requestOptions.uri}');
          buffer.writeln('Response Body:\n${_formatJson(response.data)}');
          buffer.writeln('======================================================================');
          debugPrint(buffer.toString());
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        if (kDebugMode) {
          final buffer = StringBuffer();
          buffer.writeln('======================================================================');
          buffer.writeln('<-- [API ERROR - ${error.response?.statusCode ?? "NO_STATUS"}] ❌ ${error.requestOptions.method} ${error.requestOptions.uri}');
          buffer.writeln('Error Type: ${error.type}');
          buffer.writeln('Error Message: ${error.message}');
          if (error.response?.data != null) {
            buffer.writeln('Error Response Body:\n${_formatJson(error.response?.data)}');
          }
          buffer.writeln('======================================================================');
          debugPrint(buffer.toString());
        }
        return handler.next(error);
      },
    );
  }

  /// Formats JSON for clean, multiline console output
  String _formatJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }
}
