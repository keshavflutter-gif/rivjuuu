import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_model.dart';

class HomeNearbyCardWidget extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const HomeNearbyCardWidget({
    super.key,
    required this.restaurant,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 236,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 144,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(restaurant.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (restaurant.badgeText != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          restaurant.badgeText!,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            restaurant.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: restaurant.isFavorite
                                ? AppColors.coral
                                : AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              restaurant.name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(
                  Icons.speed_rounded,
                  size: 15,
                  color: AppColors.coral,
                ),
                const SizedBox(width: 3),
                Text(
                  restaurant.rating,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                _buildDotSeparator(),
                Flexible(
                  child: Text(
                    restaurant.cuisine,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildDotSeparator(),
                Text(
                  restaurant.distance,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: Color(0xFFB5B0A6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class HomeRecommendedCardWidget extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const HomeRecommendedCardWidget({
    super.key,
    required this.restaurant,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                image: AssetImage(restaurant.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                if (restaurant.badgeText != null)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: restaurant.badgeText == 'Featured'
                            ? Colors.white
                            : AppColors.coral,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: restaurant.badgeText == 'Featured'
                            ? const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.12),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        restaurant.badgeText!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: restaurant.badgeText == 'Featured'
                              ? AppColors.navy
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          restaurant.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 17,
                          color: restaurant.isFavorite
                              ? AppColors.coral
                              : AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            restaurant.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                size: 15,
                color: AppColors.coral,
              ),
              const SizedBox(width: 3),
              Text(
                restaurant.rating,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              _buildDotSeparator(),
              Text(
                restaurant.cuisine,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.text,
                ),
              ),
              _buildDotSeparator(),
              Text(
                restaurant.distance,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          if (restaurant.perkText != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 15,
                  color: AppColors.coral,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    restaurant.perkText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: Color(0xFFB5B0A6),
        shape: BoxShape.circle,
      ),
    );
  }
}

