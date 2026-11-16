import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class ReviewDetailView extends StatelessWidget {
  final Map<String, dynamic>? reviewData;

  const ReviewDetailView({
    super.key,
    this.reviewData,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantName = reviewData?['restaurantName'] as String? ?? 'Trattoria Nonna Rosa';
    final categoryDistance = reviewData?['categoryDistance'] as String? ?? 'Italian · 1.2 km';
    final restaurantImage = reviewData?['restaurantImage'] as String? ?? AppAssets.pasta;
    final authorName = reviewData?['authorName'] as String? ?? 'Anna Kovács';
    final authorInitials = reviewData?['authorInitials'] as String? ?? 'AK';
    final date = reviewData?['date'] as String? ?? '8 Oct 2026';
    final visitedWithCoupon = reviewData?['visitedWithCoupon'] as bool? ?? true;
    final score = reviewData?['score'] as String? ?? '8.9';
    final reviewText = reviewData?['reviewText'] as String? ??
        "Best cacio e pepe I've had outside Rome. The staff scanned my coupon in seconds and the courtyard is lovely in the evening. The tiramisu was perfect, not too sweet. We'll be back for the truffle week.";
    final images = reviewData?['images'] as List<String>? ??
        [AppAssets.pasta, AppAssets.tiramisu, AppAssets.interior];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Back | Review | More (matching review-detail.html & reference image)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.arrowLeft,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Review',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showMoreOptions(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.ellipsis,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Review Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant card context link (.ctx)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pushNamed(
                          AppRoutes.restaurantDetail,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                restaurantImage,
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurantName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    categoryDistance,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF52525B),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              LucideIcons.chevronRight,
                              size: 18,
                              color: Color(0xFF71717A),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Reviewer header (.rv__head)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar AK
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE8E0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              authorInitials,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB8330F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name & Visit Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorName,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '$date · ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF71717A),
                                    ),
                                  ),
                                  if (visitedWithCoupon) ...[
                                    const Icon(
                                      LucideIcons.circleCheck,
                                      size: 13,
                                      color: Color(0xFF2E9E5B),
                                    ),
                                    const SizedBox(width: 3),
                                    Flexible(
                                      child: Text(
                                        'Visited with coupon',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF2E9E5B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Score Pill (matching score-pill: white/cream bg, border, coral gauge icon, navy bold text)
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                LucideIcons.gauge,
                                size: 15,
                                color: AppColors.coral,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                score,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Review Text Paragraph
                    Text(
                      reviewText,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColors.navy,
                        height: 1.53,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 3 Photos Grid (.rd-imgs: top wide image 190px, bottom 2 images side-by-side 150px)
                    if (images.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          images[0],
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (images.length > 1) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  images[1],
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (images.length > 2) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    images[2],
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.share2, color: AppColors.navy),
                  title: Text(
                    'Share review',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review link copied'),
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColors.navy,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.flag, color: Colors.red),
                  title: Text(
                    'Report review',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review reported'),
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColors.navy,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
