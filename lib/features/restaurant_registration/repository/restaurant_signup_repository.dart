import '../../../data/models/restaurant/restaurant_category_model.dart';
import '../../../data/models/restaurant/restaurant_register_request.dart';
import '../../../data/models/restaurant/restaurant_register_response.dart';
import '../../../data/services/restaurant/restaurant_service.dart';
import '../bloc/restaurant_signup_state.dart';

abstract class RestaurantSignupRepository {
  Future<RestaurantRegisterResponse> submitRegistration(
    RestaurantSignupState state,
  );
  Future<List<RestaurantCategoryModel>> getCategories();
}

class DefaultRestaurantSignupRepository implements RestaurantSignupRepository {
  final RestaurantService _service;

  DefaultRestaurantSignupRepository({RestaurantService? service})
      : _service = service ?? RestaurantService();

  @override
  Future<RestaurantRegisterResponse> submitRegistration(
    RestaurantSignupState state,
  ) async {
    final request = RestaurantRegisterRequest(
      fullName: state.ownerName,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      restaurantName: state.restaurantName,
      categoryId: state.categoryId.isNotEmpty ? state.categoryId : null,
      address: state.restaurantAddress,
      city: state.city.isNotEmpty ? state.city : 'Budapest',
      latitude: state.latitude?.toString(),
      longitude: state.longitude?.toString(),
      description:
          state.businessDetails.isNotEmpty ? state.businessDetails : null,
      businessDetails:
          state.businessDetails.isNotEmpty ? state.businessDetails : null,
      acceptTerms: state.termsAccepted,
    );

    return _service.registerRestaurant(request);
  }

  @override
  Future<List<RestaurantCategoryModel>> getCategories() async {
    return _service.getCategories();
  }
}
