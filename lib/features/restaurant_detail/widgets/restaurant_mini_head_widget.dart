import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class RestaurantMiniHeadWidget extends StatelessWidget {
  final String restaurantName;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  const RestaurantMiniHeadWidget({
    super.key,
    required this.restaurantName,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 4,
        16,
        8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular Back Button
          _buildRoundButton(
            icon: Icons.arrow_back_rounded,
            iconColor: AppColors.navy,
            onTap: onBack,
          ),

          // Center Restaurant Name
          Expanded(
            child: Text(
              restaurantName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Circular Heart / Favorite Button
          _buildRoundButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: AppColors.coral,
            onTap: onFavorite,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: CircleBorder(
        side: const BorderSide(color: AppColors.line),
      ),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
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
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

