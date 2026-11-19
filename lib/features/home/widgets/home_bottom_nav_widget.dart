import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/feather_award_icon.dart';

class HomeBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavTap;

  const HomeBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.line, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  context,
                  0,
                  icon: Icons.home_outlined,
                  label: l10n.navHome,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  1,
                  icon: Icons.explore_outlined,
                  label: l10n.navExplore,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  2,
                  icon: Icons.workspace_premium_outlined,
                  customIconBuilder: (color) => FeatherAwardIcon(
                    size: 22,
                    color: color,
                  ),
                  label: l10n.navRewards,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  3,
                  icon: Icons.show_chart_rounded,
                  label: l10n.navActivity,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  4,
                  icon: Icons.person_outline_rounded,
                  label: l10n.navProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index, {
    IconData? icon,
    Widget Function(Color color)? customIconBuilder,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final itemColor =
        isSelected ? AppColors.coral : const Color(0xFF71717A);

    return InkWell(
      onTap: () {
        if (index == currentIndex) {
          onNavTap(index);
          return;
        }

        if (index == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
          return;
        }

        if (index == 1) {
          Navigator.of(context).pushNamed(AppRoutes.categories);
          return;
        }

        if (index == 2) {
          Navigator.of(context).pushNamed(AppRoutes.myRewards);
          return;
        }

        if (index == 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Activity coming soon'),
              duration: Duration(seconds: 1),
              backgroundColor: AppColors.navy,
            ),
          );
          onNavTap(index);
          return;
        }

        if (index == 4) {
          Navigator.of(context).pushNamed(AppRoutes.profile);
          return;
        }

        onNavTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customIconBuilder != null)
              customIconBuilder(itemColor)
            else if (icon != null)
              Icon(
                icon,
                size: 23,
                color: itemColor,
              ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

