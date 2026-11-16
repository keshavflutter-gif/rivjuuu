import 'package:flutter/material.dart';
import 'user_profile_view.dart';

class UserProfilePage extends StatelessWidget {
  final String? name;
  final String? initials;
  final String? subtitle;
  final Color? avatarBg;
  final Color? avatarColor;

  const UserProfilePage({
    super.key,
    this.name,
    this.initials,
    this.subtitle,
    this.avatarBg,
    this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return UserProfileView(
      name: name ?? 'Bence Tóth',
      initials: initials ?? 'BT',
      subtitle: subtitle ?? 'Food lover · Joined Mar 2026',
      avatarBg: avatarBg,
      avatarColor: avatarColor,
    );
  }
}
