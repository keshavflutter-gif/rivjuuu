import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import 'login_view.dart';

class LoginPage extends StatelessWidget {
  final LoginBloc? bloc;

  const LoginPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc ?? LoginBloc(),
      child: const LoginView(),
    );
  }
}
