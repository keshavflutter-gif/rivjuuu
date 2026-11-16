import '../../models/auth/customer_register_request.dart';
import '../../models/auth/customer_register_response.dart';
import '../../services/auth/customer_register_service.dart';

abstract class CustomerRegisterRepository {
  Future<CustomerRegisterResponse> registerCustomer(
    CustomerRegisterRequest request,
  );
}

class CustomerRegisterRepositoryImpl implements CustomerRegisterRepository {
  final CustomerRegisterService _service;

  CustomerRegisterRepositoryImpl({CustomerRegisterService? service})
      : _service = service ?? CustomerRegisterService();

  @override
  Future<CustomerRegisterResponse> registerCustomer(
    CustomerRegisterRequest request,
  ) {
    return _service.registerCustomer(request);
  }
}

