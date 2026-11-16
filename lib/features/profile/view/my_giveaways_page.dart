import 'package:flutter/material.dart';
import 'my_giveaways_view.dart';

class MyGiveawaysPage extends StatelessWidget {
  final int? initialTab;
  final bool? showBackButton;
  final bool showBottomNav;

  const MyGiveawaysPage({
    super.key,
    this.initialTab,
    this.showBackButton,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return MyGiveawaysView(
      initialTab: initialTab ?? 0,
      showBackButton: showBackButton,
      showBottomNav: showBottomNav,
    );
  }
}
