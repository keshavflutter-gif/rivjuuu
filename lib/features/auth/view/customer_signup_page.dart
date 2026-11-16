import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../register/customer/bloc/customer_register_bloc.dart';
import '../register/customer/screens/customer_register_screen.dart';

class CustomerSignUpPage extends StatelessWidget {
  const CustomerSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerRegisterBloc(),
      child: const CustomerRegisterScreen(),
    );
  }
}
