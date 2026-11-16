import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import 'profile_view.dart';

class ProfilePage extends StatelessWidget {
  final ProfileBloc? profileBloc;

  const ProfilePage({super.key, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    if (profileBloc != null) {
      return BlocProvider.value(
        value: profileBloc!,
        child: const ProfileView(),
      );
    }
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileLoaded()),
      child: const ProfileView(),
    );
  }
}
