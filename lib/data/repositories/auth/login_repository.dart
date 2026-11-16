import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../services/auth/login_service.dart';

abstract class LoginRepository {
  Future<LoginResponse> login(LoginRequest request);
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginService _service;

  LoginRepositoryImpl({LoginService? service})
      : _service = service ?? LoginService();

  @override
  Future<LoginResponse> login(LoginRequest request) {
    return _service.login(request);
  }
}

