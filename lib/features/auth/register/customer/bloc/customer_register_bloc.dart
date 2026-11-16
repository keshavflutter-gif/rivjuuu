import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api/api_exception.dart';
import '../../../../../../core/constants/app_messages.dart';
import '../../../../../../core/storage/token_storage_service.dart';
import '../../../../../../data/repositories/auth/customer_register_repository.dart';
import 'customer_register_event.dart';
import 'customer_register_state.dart';

class CustomerRegisterBloc
    extends Bloc<CustomerRegisterEvent, CustomerRegisterState> {
  final CustomerRegisterRepository _repository;
  final TokenStorageService? tokenStorageService;

  CustomerRegisterBloc({
    CustomerRegisterRepository? repository,
    this.tokenStorageService,
  })  : _repository = repository ?? CustomerRegisterRepositoryImpl(),
        super(const CustomerRegisterInitial()) {
    on<CustomerRegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    CustomerRegisterSubmitted event,
    Emitter<CustomerRegisterState> emit,
  ) async {
    // Prevent duplicate submissions
    if (state is CustomerRegisterLoading) return;

    emit(const CustomerRegisterLoading());

    try {
      final response = await _repository.registerCustomer(event.request);

      // Verify success == 1, valid tokens, and user data
      if (response.success == 1 &&
          response.accessToken != null &&
          response.accessToken!.isNotEmpty &&
          response.user != null) {
        // Save complete session in SharedPreferences
        final storage =
            tokenStorageService ?? await TokenStorageService.getInstance();
        final user = response.user!;

        final saved = await storage.saveSession(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? '',
          userId: response.userId ?? user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          displayName: user.displayName,
          phone: user.phone,
          role: user.role,
          status: user.status,
        );

        if (!saved) {
          emit(const CustomerRegisterFailure(
            message: 'Failed to securely store session credentials.',
          ));
          return;
        }

        emit(CustomerRegisterSuccess(
          response: response,
          message: response.message.isNotEmpty
              ? response.message
              : AppMessages.registrationSuccess,
        ));
      } else {
        emit(CustomerRegisterFailure(
          message: response.message.isNotEmpty
              ? response.message
              : AppMessages.genericError,
        ));
      }
    } on ApiException catch (e) {
      emit(CustomerRegisterFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
      ));
    } catch (e) {
      emit(CustomerRegisterFailure(
        message: e.toString(),
      ));
    }
  }
}
