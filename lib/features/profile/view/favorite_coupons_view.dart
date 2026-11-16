import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class FavoriteCouponItem {
  final String valText;
  final String subText;
  final IconData? icon;
  final String type;
  final String title;
  final String req;
  final String statusText;
  final Color statusBg;
  final Color statusColor;
  final String? dateText;
  final bool isDark;
  final String restaurant;

  const FavoriteCouponItem({
    required this.valText,
    required this.subText,
    this.icon,
    required this.type,
    required this.title,
    required this.req,
    required this.statusText,
    required this.statusBg,
    required this.statusColor,
    this.dateText,
    this.isDark = false,
    required this.restaurant,
  });
}

class FavoriteCouponsView extends StatelessWidget {
  const FavoriteCouponsView({super.key});

  static const List<FavoriteCouponItem> _coupons = [
    FavoriteCouponItem(
      valText: '20%',
      subText: 'OFF',
      type: 'Discount',
      title: '20% off your whole bill',
      req: 'Trattoria Nonna Rosa · Min. 5,000 HUF',
      statusText: 'Available',
      statusBg: Color(0xFFE6F4EA),
      statusColor: Color(0xFF1F7A45),
      dateText: 'Until 31 Oct',
      isDark: false,
      restaurant: 'Trattoria Nonna Rosa',
    ),
    FavoriteCouponItem(
      valText: '',
      subText: 'FREE',
      icon: LucideIcons.gift,
      type: 'Gift item',
      title: 'Free dessert with any main',
      req: 'Café Mókus',
      statusText: 'Available',
      statusBg: Color(0xFFE6F4EA),
      statusColor: Color(0xFF1F7A45),
      dateText: 'Until 31 Oct',
      isDark: false,
      restaurant: 'Café Mókus',
    ),
    FavoriteCouponItem(
      valText: '',
      subText: 'HAPPY HOUR',
      icon: LucideIcons.clock,
      type: 'Happy hour',
      title: 'Two cocktails for one',
      req: 'Smoke & Fire Grill · Mon–Fri',
      statusText: 'Available from 16:00',
      statusBg: Color(0xFFFDF0D9),
      statusColor: Color(0xFF8A5300),
      isDark: true,
      restaurant: 'Smoke & Fire Grill',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Favorite coupons',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Count Line
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
              child: Text(
                '${_coupons.length} saved coupons',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                ),
              ),
            ),

            // Coupon Cards List
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: _coupons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final coupon = _coupons[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pushNamed(
                        AppRoutes.couponQr,
                        arguments: {
                          'restaurant': coupon.restaurant,
                          'discount': coupon.valText.isNotEmpty
                              ? '${coupon.valText} ${coupon.subText}'.toUpperCase()
                              : coupon.subText.toUpperCase(),
                          'title': coupon.title,
                          'openRedemptionSuccess': true,
                        },
                      );
                    },
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              // Left Ticket Stub (.tk__val)
                              Container(
                                width: 92,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: coupon.isDark
                                      ? AppColors.navy
                                      : AppColors.coral,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (coupon.icon != null) ...[
                                      Icon(
                                        coupon.icon,
                                        size: 26,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 4),
                                    ] else ...[
                                      Text(
                                        coupon.valText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                    Text(
                                      coupon.subText,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Dashed perforated line
                              CustomPaint(
                                size: const Size(1, 110),
                                painter: _DashedLinePainter(
                                  color: const Color(0xFFE3DACB),
                                ),
                              ),

                              // Right Ticket Body (.tk__body)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coupon.type.toUpperCase(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF52525B),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            coupon.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.navy,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            coupon.req,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: const Color(0xFF52525B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 22,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: coupon.statusBg,
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: coupon.statusColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  coupon.statusText,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: coupon.statusColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (coupon.dateText != null)
                                            Text(
                                              coupon.dateText!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.5,
                                                color: const Color(0xFF52525B),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Top Notch (.tk__val::before)
                          Positioned(
                            left: 84,
                            top: -8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.line),
                              ),
                            ),
                          ),

                          // Bottom Notch (.tk__val::after)
                          Positioned(
                            left: 84,
                            bottom: -8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.line),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
