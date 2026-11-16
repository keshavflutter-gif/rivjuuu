import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/app_messages.dart';
import '../../models/auth/logout_request.dart';
import '../../models/auth/logout_response.dart';

class LogoutService {
  final ApiClient _apiClient;

  LogoutService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Executes POST /auth/logout
  Future<LogoutResponse> logout({
    required String? accessToken,
    LogoutRequest request = const LogoutRequest(),
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.logout,
        data: request.toJson(),
        options: Options(
          headers: {
            if (accessToken != null && accessToken.isNotEmpty)
              'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = LogoutResponse.fromJson(data);
        if (parsed.success != 1) {
          throw ApiException(
            message: parsed.message.isNotEmpty
                ? parsed.message
                : AppMessages.genericError,
            statusCode: response.statusCode,
            data: data,
          );
        }
        return parsed;
      } else {
        throw const ApiException(
          message: AppMessages.unexpectedError,
        );
      }
    } on DioException catch (dioError) {
      throw ApiException.fromDioException(dioError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
      );
    }
  }
}

