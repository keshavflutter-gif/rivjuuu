import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String selectedLanguage; // 'en' or 'hu'

  const LanguageState({this.selectedLanguage = 'en'});

  LanguageState copyWith({String? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [selectedLanguage];
}

