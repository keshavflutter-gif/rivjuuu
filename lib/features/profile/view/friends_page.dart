import 'package:flutter/material.dart';
import 'friends_view.dart';

class FriendsPage extends StatelessWidget {
  final int? initialTab;

  const FriendsPage({super.key, this.initialTab});

  @override
  Widget build(BuildContext context) {
    return FriendsView(initialTab: initialTab ?? 0);
  }
}

