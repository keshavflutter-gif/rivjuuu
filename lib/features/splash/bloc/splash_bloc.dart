import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/language_storage_service.dart';
import '../../../core/storage/token_storage_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final Duration splashDuration;
  final TokenStorageService? tokenStorageService;
  final LanguageStorageService? languageStorageService;

  SplashBloc({
    this.splashDuration = const Duration(milliseconds: 2600),
    this.tokenStorageService,
    this.languageStorageService,
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
      final role = (userData['role'] ?? '').toUpperCase();

      if (isLoggedIn && role == 'CUSTOMER') {
        emit(state.copyWith(status: SplashStatus.authenticated));
      } else if (isLoggedIn && role == 'RESTAURANT') {
        final restData = await storage.getRestaurantData();
        final rawStatus = (restData.approvalStatus ?? '').toUpperCase();
        if (rawStatus == 'APPROVED' || rawStatus == 'ACTIVE') {
          emit(state.copyWith(
            status: SplashStatus.authenticatedRestaurant,
            restaurantData: restData,
          ));
        } else if (rawStatus == 'REJECTED' || rawStatus == 'NOT_APPROVED') {
          emit(state.copyWith(
            status: SplashStatus.authenticatedRestaurantRejected,
            restaurantData: restData,
          ));
        } else {
          emit(state.copyWith(
            status: SplashStatus.authenticatedRestaurantPending,
            restaurantData: restData,
          ));
        }
      } else {
        final langStorage =
            languageStorageService ?? await LanguageStorageService.getInstance();
        final hasSelectedLanguage = await langStorage.hasSelectedLanguage();
        if (hasSelectedLanguage) {
          emit(state.copyWith(status: SplashStatus.unauthenticatedWithLanguage));
        } else {
          emit(state.copyWith(status: SplashStatus.unauthenticated));
        }
      }
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.completed));
    }
  }
}
