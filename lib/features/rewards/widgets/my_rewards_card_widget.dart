import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/features/rewards/models/rewards_models.dart';

class MyRewardsCardWidget extends StatelessWidget {
  final RestaurantLoyaltyCardModel model;
  final VoidCallback onTap;

  const MyRewardsCardWidget({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: model.isReady ? AppColors.coral : AppColors.line,
            width: model.isReady ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Head: image, name + activeAgo, points
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    model.imagePath,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFFF6F2EA),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.coral,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        model.activeAgo,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatPoints(model.points),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      'points',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar (bar8)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 8,
                color: const Color(0xFFEFE9DF),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: model.progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Foot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      model.footerText,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                            model.isReady ? FontWeight.w500 : FontWeight.w400,
                        color: model.isReady ? AppColors.navy : AppColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (model.isReady)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.card_giftcard_rounded,
                          size: 13.5,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reward ready',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFFA1A1AA),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPoints(int pts) {
    if (pts >= 1000) {
      final s = pts.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return pts.toString();
  }
}
