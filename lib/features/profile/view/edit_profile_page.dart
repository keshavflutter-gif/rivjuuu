import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'edit_profile_view.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileBloc? profileBloc;

  const EditProfilePage({super.key, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    if (profileBloc != null) {
      return BlocProvider.value(
        value: profileBloc!,
        child: const EditProfileView(),
      );
    }
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: const EditProfileView(),
    );
  }
}
