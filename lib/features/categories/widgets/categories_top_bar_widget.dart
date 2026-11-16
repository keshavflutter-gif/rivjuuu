import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class CategoriesTopBarWidget extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback? onBack;

  const CategoriesTopBarWidget({
    super.key,
    required this.onSearch,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = onBack != null || Navigator.of(context).canPop();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Optional back button + "Categories" title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canPop) ...[
                GestureDetector(
                  onTap: () {
                    if (onBack != null) {
                      onBack!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
              ],
              Text(
                'Categories',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          // Right: 42x42 Search Round Button matching rv3.css .round
          GestureDetector(
            onTap: onSearch,
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
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

