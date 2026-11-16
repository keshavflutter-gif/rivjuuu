import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RestaurantHeroWidget extends StatelessWidget {
  final String heroImage;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback? onShare;

  const RestaurantHeroWidget({
    super.key,
    required this.heroImage,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Hero Image
          Image.asset(
            heroImage,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: const Color(0xFF2E4A3A),
              child: const Center(
                child: Icon(Icons.restaurant, color: Colors.white54, size: 48),
              ),
            ),
          ),
          // Subtle top gradient for contrast
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Top Bar (Back on Left, Share and Favorite on Right)
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
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.94),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? AppColors.navy,
          ),
        ),
      ),
    );
  }
}
