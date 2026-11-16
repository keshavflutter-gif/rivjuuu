import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'core/utils/app_bloc_observer.dart';

Future<void> _preloadPoppinsFonts() async {
  final fontMap = {
    'Poppins_regular': 'assets/fonts/Poppins-Regular.ttf',
    'Poppins_500': 'assets/fonts/Poppins-Medium.ttf',
    'Poppins_600': 'assets/fonts/Poppins-SemiBold.ttf',
    'Poppins_700': 'assets/fonts/Poppins-Bold.ttf',
    'Poppins_800': 'assets/fonts/Poppins-ExtraBold.ttf',
  };

  for (final entry in fontMap.entries) {
    try {
      final loader = FontLoader(entry.key);
      loader.addFont(rootBundle.load(entry.value));
      await loader.load();
    } catch (_) {}
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  await _preloadPoppinsFonts();
  Bloc.observer = const AppBlocObserver();
  runApp(const RivjuuuApp());
}
