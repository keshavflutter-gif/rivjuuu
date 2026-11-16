import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/token_storage_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final Duration splashDuration;
  final TokenStorageService? tokenStorageService;

  SplashBloc({
    this.splashDuration = const Duration(milliseconds: 2600),
    this.tokenStorageService,
  }) : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.loading));
    await Future<void>.delayed(splashDuration);

    try {
      final storage =
          tokenStorageService ?? await TokenStorageService.getInstance();
      final isLoggedIn = await storage.isLoggedIn();
      final userData = await storage.getUserData();
      final isCustomer = (userData['role'] ?? '').toUpperCase() == 'CUSTOMER';

      if (isLoggedIn && isCustomer) {
        emit(state.copyWith(status: SplashStatus.authenticated));
      } else {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
      }
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.completed));
    }
  }
}
