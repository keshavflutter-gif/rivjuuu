import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';

class ProfileMenuItem {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final String? value;
  final bool isHighlightBadge;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    this.icon,
    this.iconWidget,
    required this.label,
    this.value,
    this.isHighlightBadge = false,
    this.onTap,
  }) : assert(icon != null || iconWidget != null);
}

class ProfileMenuGroupWidget extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileMenuGroupWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (UPPERCASE with letter-spacing matching Image 2 reference)
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF71717A),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          // Card Container (.rows)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  for (int index = 0; index < items.length; index++) ...[
                    if (index > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.line,
                      ),
                    _buildRowItem(items[index], index, items.length),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(ProfileMenuItem item, int index, int count) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: index == 0
          ? const BorderRadius.vertical(top: Radius.circular(16))
          : index == count - 1
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12.5,
        ),
        child: Row(
          children: [
            // Icon
            item.iconWidget ??
                Icon(
                  item.icon,
                  size: 20,
                  color: AppColors.navy,
                ),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
            ),

            // Count badge (if any)
            if (item.value != null) ...[
              if (item.isHighlightBadge)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.value!,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  item.value!,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF71717A),
                  ),
                ),
              const SizedBox(width: 6),
            ],

            // Chevron Right
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFFA1A1AA),
            ),
          ],
        ),
      ),
    );
  }
}
