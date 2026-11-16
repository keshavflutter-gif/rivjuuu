import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/map_pin_model.dart';

class MapBottomCardWidget extends StatelessWidget {
  final MapPinModel restaurant;
  final VoidCallback onViewRestaurant;

  const MapBottomCardWidget({
    super.key,
    required this.restaurant,
    required this.onViewRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(24, 24, 27, 0.18),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD3C2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Restaurant Row: Image (96x96) + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 96x96 Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    restaurant.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.peach,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: AppColors.coral,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Restaurant Name
                    Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Meta Row 1: Score · Cuisine · Distance
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          size: 14,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.coral,
                          ),
                        ),
                        _buildDot(),
                        Flexible(
                          child: Text(
                            restaurant.cuisine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        _buildDot(),
                        Text(
                          restaurant.distance,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Meta Row 2: Open · until 23:00
                    Row(
                      children: [
                        Text(
                          'Open',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        _buildDot(),
                        Flexible(
                          child: Text(
                            restaurant.openStatus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Perk Row: Tickets
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 14,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${restaurant.couponCount} coupons available',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.coral,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // View restaurant CTA button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onViewRestaurant,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'View restaurant',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        '·',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
