import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../models/restaurant/restaurant_category_model.dart';
import '../../models/restaurant/restaurant_register_request.dart';
import '../../models/restaurant/restaurant_register_response.dart';

class RestaurantService {
  final ApiClient _apiClient;

  RestaurantService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Executes POST /auth/register/restaurant
  Future<RestaurantRegisterResponse> registerRestaurant(
    RestaurantRegisterRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.registerRestaurant,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = RestaurantRegisterResponse.fromJson(data);
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
      throw ApiException(message: e.toString());
    }
  }

  /// Executes GET /restaurant-category
  Future<List<RestaurantCategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.restaurantCategory,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = RestaurantCategoriesResponse.fromJson(data);
        return parsed.data;
      } else {
        throw const ApiException(
          message: 'Invalid category response format from server.',
        );
      }
    } on DioException catch (dioError) {
      throw ApiException.fromDioException(dioError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }
}
