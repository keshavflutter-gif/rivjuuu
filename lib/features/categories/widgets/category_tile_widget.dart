import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category_tile_model.dart';

class CategoryTileWidget extends StatelessWidget {
  final CategoryTileModel category;
  final VoidCallback onTap;

  const CategoryTileWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 128,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                category.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFF4EFEA),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: Color(0xFFFE552E),
                      size: 32,
                    ),
                  ),
                ),
              ),

              // Bottom Gradient Overlay matching rv3.css .ctile::before
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromRGBO(24, 24, 27, 0.72),
                      Color.fromRGBO(24, 24, 27, 0.0),
                    ],
                    stops: [0.0, 0.6],
                  ),
                ),
              ),

              // Title and Place Count
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.placeCount} places',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

