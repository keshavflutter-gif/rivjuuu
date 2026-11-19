import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LanguageInitialized extends LanguageEvent {
  const LanguageInitialized();
}

class LanguageSelected extends LanguageEvent {
  final String languageCode;

  const LanguageSelected(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageConfirmed extends LanguageEvent {
  const LanguageConfirmed();
}
