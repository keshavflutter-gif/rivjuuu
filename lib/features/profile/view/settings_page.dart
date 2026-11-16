import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/logout/bloc/logout_bloc.dart';
import 'settings_view.dart';

class SettingsPage extends StatelessWidget {
  final LogoutBloc? logoutBloc;

  const SettingsPage({super.key, this.logoutBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => logoutBloc ?? LogoutBloc(),
      child: const SettingsView(),
    );
  }
}
