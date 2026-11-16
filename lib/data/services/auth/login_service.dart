import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/app_messages.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';

class LoginService {
  final ApiClient _apiClient;

  LoginService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Executes POST /auth/login
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = LoginResponse.fromJson(data);
        if (parsed.success != 1) {
          throw ApiException(
            message: parsed.message.isNotEmpty
                ? parsed.message
                : AppMessages.invalidCredentials,
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

