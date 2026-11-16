import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantReviewsTabWidget extends StatelessWidget {
  final double score;
  final int reviewCount;
  final int filterIndex;
  final ValueChanged<int> onFilterChanged;
  final List<ReviewModel> reviews;

  const RestaurantReviewsTabWidget({
    super.key,
    this.score = 8.9,
    this.reviewCount = 214,
    required this.filterIndex,
    required this.onFilterChanged,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                // Big score
                SizedBox(
                  width: 96,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: AppColors.navy,
                            height: 1.1,
                          ),
                          children: [
                            TextSpan(text: score.toStringAsFixed(1)),
                            TextSpan(
                              text: ' /10',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Excellent',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$reviewCount reviews',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Distribution Bars
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar('9–10', 0.58, 124),
                      const SizedBox(height: 5),
                      _buildRatingBar('7–8.9', 0.30, 64),
                      const SizedBox(height: 5),
                      _buildRatingBar('5–6.9', 0.08, 17),
                      const SizedBox(height: 5),
                      _buildRatingBar('3–4.9', 0.03, 6),
                      const SizedBox(height: 5),
                      _buildRatingBar('0.1–2.9', 0.02, 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips (Recent / Highest rated)
          Row(
            children: [
              _buildFilterChip('Recent', 0),
              const SizedBox(width: 8),
              _buildFilterChip('Highest rated', 1),
            ],
          ),
          const SizedBox(height: 16),

          // User Reviews List
          ...reviews.map((rv) => _buildReviewCard(rv)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String range, double fraction, int count) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            range,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.text,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECE2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = filterIndex == index;
    return GestureDetector(
      onTap: () => onFilterChanged(index),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel rv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name & meta, Score pill, More options
          Row(
            children: [
              // Avatar Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rv.avatarBg,
                ),
                child: Center(
                  child: Text(
                    rv.initials,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: rv.avatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Name & verification
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rv.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      runSpacing: 2,
                      children: [
                        Text(
                          rv.date,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: AppColors.text,
                          ),
                        ),
                        if (rv.visitedWithCoupon) ...[
                          Text(
                            '·',
                            style: GoogleFonts.poppins(color: AppColors.text),
                          ),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 12,
                            color: Color(0xFF1F7A45),
                          ),
                          Text(
                            'Visited with coupon',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF1F7A45),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Score Pill
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.speed_rounded,
                      size: 14,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rv.score.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // More options
              const Icon(
                Icons.more_vert_rounded,
                size: 20,
                color: AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review Text
          Text(
            rv.text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.navy,
            ),
          ),

          // Review photos if any
          if (rv.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: rv.images.map((img) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      img,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 72,
                        height: 72,
                        color: AppColors.cream,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
