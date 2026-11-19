import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/language/bloc/language_event.dart';
import 'features/language/bloc/language_state.dart';
import 'l10n/app_localizations.dart';

class RivjuuuApp extends StatelessWidget {
  final LanguageBloc? languageBloc;

  const RivjuuuApp({super.key, this.languageBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageBloc>(
       create: (_) =>
          (languageBloc ?? LanguageBloc())..add(const LanguageInitialized()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            title: AppStrings.appName,
            locale: Locale(state.selectedLanguage),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
