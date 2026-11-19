import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String selectedLanguage; // 'en' or 'hu'
  final bool isInitialized;
  final bool hasSelectedLanguage;

  const LanguageState({
    this.selectedLanguage = 'en',
    this.isInitialized = false,
    this.hasSelectedLanguage = false,
  });

  LanguageState copyWith({
    String? selectedLanguage,
    bool? isInitialized,
    bool? hasSelectedLanguage,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isInitialized: isInitialized ?? this.isInitialized,
      hasSelectedLanguage: hasSelectedLanguage ?? this.hasSelectedLanguage,
    );
  }

  @override
  List<Object?> get props => [selectedLanguage, isInitialized, hasSelectedLanguage];
}
