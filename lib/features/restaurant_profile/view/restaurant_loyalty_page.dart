import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

/// Loyalty Reward Model matching loyalty.html & reward-form.html
class LoyaltyRewardItem {
  final String id;
  final String title;
  final String description;
  final int points;
  final int redeemedCount;
  final String imagePath;
  bool isActive;
  final String? validUntil;

  LoyaltyRewardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.redeemedCount,
    required this.imagePath,
    this.isActive = true,
    this.validUntil,
  });
}

/// Loyalty Activity Model matching loyalty-activity.html
class LoyaltyActivityItem {
  final String initials;
  final Color avatarBg;
  final Color avatarTextColor;
  final String name;
  final String detail;
  final String points;
  final bool isEarned;

  const LoyaltyActivityItem({
    required this.initials,
    required this.avatarBg,
    required this.avatarTextColor,
    required this.name,
    required this.detail,
    required this.points,
    required this.isEarned,
  });
}

/// Restaurant Loyalty Screen matching batch-05-restaurant-app/html/loyalty.html
class RestaurantLoyaltyPage extends StatefulWidget {
  const RestaurantLoyaltyPage({super.key});

  @override
  State<RestaurantLoyaltyPage> createState() => _RestaurantLoyaltyPageState();
}

class _RestaurantLoyaltyPageState extends State<RestaurantLoyaltyPage> {
  final List<LoyaltyRewardItem> _rewards = [
    LoyaltyRewardItem(
      id: 'rew_1',
      title: 'Free espresso',
      description: 'Single or double espresso shot with any order.',
      points: 150,
      redeemedCount: 21,
      imagePath: 'assets/coffee.jpg',
      isActive: true,
    ),
    LoyaltyRewardItem(
      id: 'rew_2',
      title: 'Free dessert',
      description: 'Any dessert from the menu, dine-in only.',
      points: 400,
      redeemedCount: 8,
      imagePath: 'assets/tiramisu.jpg',
      isActive: true,
    ),
    LoyaltyRewardItem(
      id: 'rew_3',
      title: '10% bonus on your bill',
      description: 'Discount applies to your full bill before service charge.',
      points: 700,
      redeemedCount: 0,
      imagePath: 'assets/table.jpg',
      isActive: false,
    ),
  ];

  Future<void> _openAddRewardSheet({LoyaltyRewardItem? existingReward}) async {
    HapticFeedback.lightImpact();
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.restaurantRewardForm,
      arguments: existingReward,
    );
    if (result != null && result is LoyaltyRewardItem && mounted) {
      setState(() {
        if (existingReward != null) {
          final idx = _rewards.indexWhere((r) => r.id == result.id);
          if (idx != -1) {
            _rewards[idx] = result;
          }
        } else {
          _rewards.insert(0, result);
        }
      });
    }
  }

  void _navigateToActivity() {
    HapticFeedback.lightImpact();
    if (Navigator.canPop(context)) {
      Navigator.pop(context, 3);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.restaurantDashboard,
        (route) => false,
        arguments: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top App Bar (.bar)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.arrowLeft,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Loyalty',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openAddRewardSheet(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.coral),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // KPIs Section (.kpis)
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            icon: LucideIcons.award,
                            label: 'Points awarded',
                            value: '12,480',
                            sub: 'Last 30 days',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildKpiCard(
                            icon: LucideIcons.gift,
                            label: 'Points redeemed',
                            value: '4,350',
                            sub: '29 rewards used',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Earning Rules Card (.sec-card)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Earning rules',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Earning rules updated'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.coral,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, thickness: 1, color: AppColors.line),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            icon: LucideIcons.ticket,
                            title: 'Points are set per coupon',
                            subtitle: 'e.g. 20% off = +40 points',
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1, thickness: 1, color: AppColors.line),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            icon: LucideIcons.store,
                            title:
                                'Points can only be used at Trattoria Nonna Rosa',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Rewards Header (.cat-head)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rewards',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openAddRewardSheet(),
                          child: Text(
                            'Add reward',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coral,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rewards Items List
                    ..._rewards.map((item) => _buildRewardCard(item)),

                    const SizedBox(height: 16),

                    // View Loyalty Activity Button (.btn btn--ghost)
                    OutlinedButton.icon(
                      onPressed: _navigateToActivity,
                      icon: const Icon(
                        LucideIcons.activity,
                        size: 20,
                        color: AppColors.navy,
                      ),
                      label: Text(
                        'View loyalty activity',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.navy,
                        side: const BorderSide(color: AppColors.line),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.text),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.text),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.35,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.text,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(LoyaltyRewardItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 58,
              height: 58,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.coralSoft,
                  child: const Icon(
                    LucideIcons.coffee,
                    size: 26,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.points} points · ${item.redeemedCount} redeemed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status Badge (.st--ok or .st--off)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.isActive
                  ? const Color(0xFFE6F4EA)
                  : const Color(0xFFF1ECE2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: item.isActive
                        ? const Color(0xFF1F7A45)
                        : const Color(0xFF52525B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item.isActive ? 'Active' : 'Paused',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item.isActive
                        ? const Color(0xFF1F7A45)
                        : const Color(0xFF52525B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Edit icon button
          GestureDetector(
            onTap: () => _openAddRewardSheet(existingReward: item),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.edit2,
                  size: 17,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
