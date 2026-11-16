import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantGiveawaysTabWidget extends StatelessWidget {
  final List<GiveawayModel> giveaways;
  final ValueChanged<String> onJoinGiveaway;
  final VoidCallback? onViewPrizeCoupon;

  const RestaurantGiveawaysTabWidget({
    super.key,
    required this.giveaways,
    required this.onJoinGiveaway,
    this.onViewPrizeCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: giveaways.map((gw) => _buildGiveawayCard(gw)).toList(),
      ),
    );
  }

  Widget _buildGiveawayCard(GiveawayModel gw) {
    final isWon = gw.status == GiveawayStatus.won;
    final isEnded = gw.status == GiveawayStatus.ended;
    final isFirst = gw.status == GiveawayStatus.open;
    final imgHeight = isFirst ? 140.0 : 110.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isWon ? AppColors.coral : AppColors.line,
          width: isWon ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Status Badge
          SizedBox(
            height: imgHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColorFiltered(
                  colorFilter: isEnded
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: Opacity(
                    opacity: isEnded ? 0.7 : 1.0,
                    child: Image.asset(
                      gw.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.cream,
                        child: const Icon(
                          Icons.image,
                          color: AppColors.muted,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: _buildGiveawayBadge(gw.status),
                ),
              ],
            ),
          ),

          // Body Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gw.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    height: 1.3,
                  ),
                ),
                if (gw.prize != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isWon
                            ? Icons.confirmation_number_outlined
                            : Icons.card_giftcard_rounded,
                        size: 16,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          gw.prize!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                // Meta Row (Calendar / Users / Clock)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      gw.status == GiveawayStatus.joined
                          ? Icons.access_time_rounded
                          : Icons.calendar_today_outlined,
                      size: 13,
                      color: AppColors.text,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          Text(
                            gw.dateMeta,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                          if (gw.joinedMeta != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.people_outline_rounded,
                                  size: 14,
                                  color: AppColors.text,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  gw.joinedMeta!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Action Button
                if (gw.status == GiveawayStatus.open) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => onJoinGiveaway(gw.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        gw.actionText ?? 'Join giveaway',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else if (gw.status == GiveawayStatus.won) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onViewPrizeCoupon,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.coral,
                        side: const BorderSide(
                          color: AppColors.coral,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        gw.actionText ?? 'View prize coupon',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiveawayBadge(GiveawayStatus status) {
    switch (status) {
      case GiveawayStatus.open:
        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.coral,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              'Open',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      case GiveawayStatus.joined:
        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1F7A45),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Joined',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F7A45),
                ),
              ),
            ],
          ),
        );
      case GiveawayStatus.won:
        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.coral,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                'You won',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      case GiveawayStatus.ended:
        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF52525B),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Ended',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF52525B),
                ),
              ),
            ],
          ),
        );
    }
  }
}
