import '../bloc/restaurant_signup_state.dart';

abstract class RestaurantSignupRepository {
  Future<void> submitRegistration(RestaurantSignupState state);
}

class DefaultRestaurantSignupRepository implements RestaurantSignupRepository {
  const DefaultRestaurantSignupRepository();

  @override
  Future<void> submitRegistration(RestaurantSignupState state) async {
    // Simulated network delay. If an external API client is injected, it connects here.
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}

