import '../../models/auth/logout_request.dart';
import '../../models/auth/logout_response.dart';
import '../../services/auth/logout_service.dart';

abstract class LogoutRepository {
  Future<LogoutResponse> logout({
    required String? accessToken,
    LogoutRequest request = const LogoutRequest(),
  });
}

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutService _service;

  LogoutRepositoryImpl({LogoutService? service})
      : _service = service ?? LogoutService();

  @override
  Future<LogoutResponse> logout({
    required String? accessToken,
    LogoutRequest request = const LogoutRequest(),
  }) {
    return _service.logout(accessToken: accessToken, request: request);
  }
}

