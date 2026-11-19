import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/language_storage_service.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageStorageService? storageService;

  LanguageBloc({this.storageService}) : super(const LanguageState()) {
    on<LanguageInitialized>(_onLanguageInitialized);
    on<LanguageSelected>(_onLanguageSelected);
    on<LanguageConfirmed>(_onLanguageConfirmed);
  }

  Future<void> _onLanguageInitialized(
    LanguageInitialized event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final storage =
          storageService ?? await LanguageStorageService.getInstance();
      final lang = await storage.getLanguageCode();
      final hasSelected = await storage.hasSelectedLanguage();
      emit(state.copyWith(
        selectedLanguage: lang,
        isInitialized: true,
        hasSelectedLanguage: hasSelected,
      ));
    } catch (_) {
      emit(state.copyWith(isInitialized: true));
    }
  }

  Future<void> _onLanguageSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(selectedLanguage: event.languageCode));
    try {
      final storage =
          storageService ?? await LanguageStorageService.getInstance();
      await storage.saveLanguageCode(event.languageCode);
    } catch (_) {}
  }

  Future<void> _onLanguageConfirmed(
    LanguageConfirmed event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(hasSelectedLanguage: true));
    try {
      final storage =
          storageService ?? await LanguageStorageService.getInstance();
      await storage.setHasSelectedLanguage(true);
      await storage.saveLanguageCode(state.selectedLanguage);
    } catch (_) {}
  }
}
