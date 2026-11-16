import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/app_messages.dart';
import '../../../../core/storage/token_storage_service.dart';
import '../../../../data/models/auth/logout_request.dart';
import '../../../../data/repositories/auth/logout_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  static LogoutRepository? defaultRepository;
  final LogoutRepository _repository;
  final TokenStorageService? tokenStorageService;

  LogoutBloc({
    LogoutRepository? repository,
    this.tokenStorageService,
  })  : _repository = repository ?? defaultRepository ?? LogoutRepositoryImpl(),
        super(const LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    // Prevent duplicate simultaneous submissions
    if (state is LogoutLoading) return;

    emit(const LogoutLoading());

    final storage =
        tokenStorageService ?? await TokenStorageService.getInstance();
    final accessToken = await storage.getAccessToken();

    try {
      final response = await _repository.logout(
        accessToken: accessToken,
        request: LogoutRequest(deviceToken: event.deviceToken),
      );

      if (response.success == 1) {
        // Clear authentication session upon successful server logout
        await storage.clearSession();
        emit(LogoutSuccess(
          message: response.message.isNotEmpty
              ? response.message
              : AppMessages.logoutSuccess,
        ));
      } else {
        emit(LogoutFailure(
          message: response.message.isNotEmpty
              ? response.message
              : AppMessages.genericError,
        ));
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // If API returns 401 because token is invalid or expired,
        // clear local session and redirect to Login
        await storage.clearSession();
        emit(LogoutFailure(
          message: e.message.isNotEmpty ? e.message : AppMessages.sessionExpired,
          statusCode: 401,
          sessionCleared: true,
        ));
      } else {
        // For network or server failures, do not falsely claim server logout succeeded
        emit(LogoutFailure(
          message: e.message,
          statusCode: e.statusCode,
          sessionCleared: false,
        ));
      }
    } catch (e) {
      emit(LogoutFailure(
        message: e.toString(),
        sessionCleared: false,
      ));
    }
  }
}

