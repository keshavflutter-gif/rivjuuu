import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../models/auth/customer_register_request.dart';
import '../../models/auth/customer_register_response.dart';

class CustomerRegisterService {
  final ApiClient _apiClient;

  CustomerRegisterService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Executes POST /auth/register/customer
  Future<CustomerRegisterResponse> registerCustomer(
    CustomerRegisterRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.registerCustomer,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = CustomerRegisterResponse.fromJson(data);
        if (parsed.success != 1) {
          throw ApiException(
            message: parsed.message.isNotEmpty
                ? parsed.message
                : 'Registration failed. Please check your details.',
            statusCode: response.statusCode,
            data: data,
          );
        }
        return parsed;
      } else {
        throw const ApiException(
          message: 'Invalid response format from server.',
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

