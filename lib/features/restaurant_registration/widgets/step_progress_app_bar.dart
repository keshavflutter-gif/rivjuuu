import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class StepProgressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int step; // 1, 2, 3, 4
  final VoidCallback? onBack;

  const StepProgressAppBar({
    super.key,
    required this.step,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final progress = step / 4.0;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.navy),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Step $step of 4',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 140,
            height: 4.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(color: AppColors.line),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(color: AppColors.coral),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: const [
        SizedBox(width: 48), // Balances the 48px leading icon button
      ],
    );
  }
}

