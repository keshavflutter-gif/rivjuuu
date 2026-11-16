import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CircularDishWidget extends StatelessWidget {
  final String assetPath;
  final double size;
  final Alignment alignment;

  const CircularDishWidget({
    super.key,
    required this.assetPath,
    required this.size,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.dishShadow,
            blurRadius: 34,
            spreadRadius: 2,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          alignment: alignment,
        ),
      ),
    );
  }
}

