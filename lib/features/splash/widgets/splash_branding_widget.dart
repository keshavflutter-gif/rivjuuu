import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SplashBrandingWidget extends StatelessWidget {
  final double scale;

  const SplashBrandingWidget({
    super.key,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.logo,
          width: (230 * scale).clamp(200.0, 280.0),
          fit: BoxFit.contain,
        ),
        SizedBox(height: 28 * scale),
        Text(
          AppStrings.splashTagline,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: (19 * scale).clamp(17.0, 23.0),
            height: 1.42,
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

