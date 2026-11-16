import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantHeaderWidget extends StatelessWidget {
  final RestaurantDetailModel restaurant;
  final VoidCallback onViewCoupons;
  final VoidCallback onMoreInfo;

  const RestaurantHeaderWidget({
    super.key,
    required this.restaurant,
    required this.onViewCoupons,
    required this.onMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Name (with right padding so it doesn't overlap avatar)
              Padding(
                padding: const EdgeInsets.only(right: 70),
                child: Text(
                  restaurant.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColors.navy,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Rating & Cuisine Line
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
              const SizedBox(height: 6),

              // Open status & distance Line
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(
                    restaurant.openStatus,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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

              // Description with 'More info' link
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
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons: View coupons (3) & Pin Button
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  // Pin Location Button
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
                        width: 48,
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

          // Floating Logo Avatar at Top-Right
          Positioned(
            right: 0,
            top: -46,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3B2B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cream, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
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
    );
  }
}
