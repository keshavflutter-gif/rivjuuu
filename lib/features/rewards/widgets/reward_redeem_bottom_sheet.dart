import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/rewards_models.dart';

class RewardRedeemBottomSheet extends StatelessWidget {
  final String restaurantName;
  final LoyaltyRewardItemModel reward;
  final int currentPoints;
  final VoidCallback onConfirm;

  const RewardRedeemBottomSheet({
    super.key,
    required this.restaurantName,
    required this.reward,
    required this.currentPoints,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String restaurantName,
    required LoyaltyRewardItemModel reward,
    required int currentPoints,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RewardRedeemBottomSheet(
        restaurantName: restaurantName,
        reward: reward,
        currentPoints: currentPoints,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pointsLeft = (currentPoints - reward.points).clamp(0, 99999);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD6D0C4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Sheet Hero
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  reward.imagePath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: AppColors.cardBg,
                    child: const Icon(
                      Icons.coffee_rounded,
                      color: AppColors.coral,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Use ${reward.points} points for a ${reward.title.toLowerCase()}?',
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Sheet Points Breakdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _buildPointsRow('Your points', '$currentPoints'),
                const Divider(height: 14, color: AppColors.line),
                _buildPointsRow(
                  'Reward',
                  '−${reward.points}',
                  valueColor: AppColors.coral,
                ),
                const Divider(height: 14, color: AppColors.line),
                _buildPointsRow('Points left', '$pointsLeft'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Hint box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.text,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Show the reward to staff at $restaurantName. Points can\'t be used at other restaurants.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF5A626A),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Redeem Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Redeem reward',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Cancel Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              foregroundColor: AppColors.text,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            color: AppColors.text,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.navy,
          ),
        ),
      ],
    );
  }
}

