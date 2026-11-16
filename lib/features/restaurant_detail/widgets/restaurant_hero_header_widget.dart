import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantHeroHeaderWidget extends StatelessWidget {
  final RestaurantDetailModel restaurant;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback? onShare;
  final VoidCallback onViewCoupons;
  final VoidCallback onMoreInfo;

  const RestaurantHeroHeaderWidget({
    super.key,
    required this.restaurant,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    this.onShare,
    required this.onViewCoupons,
    required this.onMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    const double heroHeight = 272.0;
    const double sheetOverlap = 22.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Hero Image Background (.hero in rv3.css)
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                restaurant.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF2E4A3A),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
              // Gradient at top for contrast behind buttons
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 110,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Top Bar with Back, Share, and Favorite buttons
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRoundButton(
                      icon: Icons.arrow_back_rounded,
                      iconColor: AppColors.navy,
                      onTap: onBack,
                    ),
                    Row(
                      children: [
                        _buildRoundButton(
                          icon: Icons.ios_share_rounded,
                          iconColor: AppColors.navy,
                          onTap: onShare ?? () {},
                        ),
                        const SizedBox(width: 10),
                        _buildRoundButton(
                          icon: isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          iconColor: AppColors.coral,
                          onTap: onFavorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. Sheet Top (.sheet-top in rv3.css)
        // Starts at heroHeight - sheetOverlap = 250px so it overlaps the hero seamlessly
        Padding(
          padding: const EdgeInsets.only(top: heroHeight - sheetOverlap),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Info Content Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name (Single Line matching Image 2)
                    Padding(
                      padding: const EdgeInsets.only(right: 68),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          restaurant.name,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: AppColors.navy,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating & Cuisine Line (Wrap to prevent overflow on 360px)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.speed_rounded,
                              size: 16,
                              color: AppColors.coral,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '(${restaurant.reviewCount} reviews)',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.text,
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          restaurant.cuisine,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Open Status & Address Line (Wrap to prevent overflow on 360px)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Open',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F7A45),
                          ),
                        ),
                        Text(
                          restaurant.openTimeText,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.text,
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          '${restaurant.distance} · ${restaurant.address}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description with Inline 'More info' link
                    Wrap(
                      children: [
                        Text(
                          '${restaurant.description} ',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: AppColors.text,
                            height: 1.45,
                          ),
                        ),
                        GestureDetector(
                          onTap: onMoreInfo,
                          child: Text(
                            'More info',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.5,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // CTA Row: View coupons (3) + Location Pin Button
                    Row(
                      children: [
                        // View coupons button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: onViewCoupons,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.coral,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.confirmation_number_outlined,
                                    size: 19,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'View coupons (${restaurant.couponCount})',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Pin Location Button (50x50)
                        Material(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: AppColors.line),
                          ),
                          child: InkWell(
                            onTap: onMoreInfo,
                            borderRadius: BorderRadius.circular(14),
                            child: const SizedBox(
                              width: 50,
                              height: 48,
                              child: Center(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Floating Logo Avatar at Top-Right (.rd__logo in rv3.css)
                // Positioned at top: -30 relative to sheet top, zero clipping
                Positioned(
                  right: 0,
                  top: -30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E4A3A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cream, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        restaurant.logoText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.line),
      ),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: iconColor ?? AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
