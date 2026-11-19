import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';

class RestaurantActivityItemData {
  final String initials;
  final Color avatarBg;
  final Color avatarTextColor;
  final String name;
  final String detail;
  final String points;
  final bool isEarned;
  final bool isGuest;

  const RestaurantActivityItemData({
    required this.initials,
    required this.avatarBg,
    required this.avatarTextColor,
    required this.name,
    required this.detail,
    required this.points,
    required this.isEarned,
    this.isGuest = false,
  });
}

/// Restaurant Activity Tab Content View
/// Matching batch-05-restaurant-app/html/loyalty-activity.html & Image reference
class RestaurantActivityContentView extends StatefulWidget {
  const RestaurantActivityContentView({super.key});

  @override
  State<RestaurantActivityContentView> createState() =>
      _RestaurantActivityContentViewState();
}

class _RestaurantActivityContentViewState
    extends State<RestaurantActivityContentView> {
  int _selectedFilterIndex = 0; // 0: All, 1: Earned, 2: Redeemed

  final List<RestaurantActivityItemData> _allActivities = const [
    RestaurantActivityItemData(
      initials: 'AK',
      avatarBg: Color(0xFFFFE8E0),
      avatarTextColor: Color(0xFFFE552E),
      name: 'Anna K.',
      detail: '20% off coupon · Today 19:42',
      points: '+40',
      isEarned: true,
    ),
    RestaurantActivityItemData(
      initials: 'BT',
      avatarBg: Color(0xFFFDF0D9),
      avatarTextColor: Color(0xFF7A4A00),
      name: 'Bence T.',
      detail: 'Reward · Free espresso · Today 18:15',
      points: '−150',
      isEarned: false,
    ),
    RestaurantActivityItemData(
      initials: 'ZS',
      avatarBg: Color(0xFFE6F4EA),
      avatarTextColor: Color(0xFF1F7A45),
      name: 'Zsófia B.',
      detail: 'Free tiramisu coupon · Today 13:05',
      points: '+25',
      isEarned: true,
    ),
    RestaurantActivityItemData(
      initials: 'DM',
      avatarBg: Color(0xFFE8F0FE),
      avatarTextColor: Color(0xFF1967D2),
      name: 'Dávid M.',
      detail: '1+1 pizza coupon · Yesterday',
      points: '+20',
      isEarned: true,
    ),
    RestaurantActivityItemData(
      initials: 'LK',
      avatarBg: Color(0xFFFFE8E0),
      avatarTextColor: Color(0xFFFE552E),
      name: 'Lilla K.',
      detail: 'Reward · Free dessert · Yesterday',
      points: '−400',
      isEarned: false,
    ),
    RestaurantActivityItemData(
      initials: '',
      avatarBg: Color(0xFFF1ECE2),
      avatarTextColor: AppColors.navy,
      name: 'Guest',
      detail: 'Happy hour coupon · Yesterday',
      points: '+10',
      isEarned: true,
      isGuest: true,
    ),
  ];

  List<RestaurantActivityItemData> get _filteredActivities {
    if (_selectedFilterIndex == 1) {
      return _allActivities.where((a) => a.isEarned).toList();
    }
    if (_selectedFilterIndex == 2) {
      return _allActivities.where((a) => !a.isEarned).toList();
    }
    return _allActivities;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title Bar matching loyalty-activity.html (.bar)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Text(
            context.l10n.navActivity,
            style: GoogleFonts.poppins(
              fontSize: 22,
              height: 1.36,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),

        // Scrollable Body (.scroll)
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 3 Stat KPI Cards (.statgrid)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: context.l10n.earned,
                        value: '12,480',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        label: context.l10n.redeemed,
                        value: '4,350',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        label: context.l10n.rewards,
                        value: '29',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Filter Chips (.chip2)
                Row(
                  children: [
                    _buildFilterChip(context.l10n.all, 0),
                    const SizedBox(width: 8),
                    _buildFilterChip(context.l10n.earned, 1),
                    const SizedBox(width: 8),
                    _buildFilterChip(context.l10n.redeemed, 2),
                  ],
                ),

                const SizedBox(height: 12),

                // Feed List Container (.feed)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      for (int i = 0; i < _filteredActivities.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.line,
                          ),
                        _buildFeedItem(_filteredActivities[i]),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.navy,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedItem(RestaurantActivityItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: item.isGuest
                  ? const Icon(
                      LucideIcons.user,
                      size: 20,
                      color: AppColors.navy,
                    )
                  : Text(
                      item.initials,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.avatarTextColor,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item.detail,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Points End
          Text(
            item.points,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: item.isEarned ? const Color(0xFF1F7A45) : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}


