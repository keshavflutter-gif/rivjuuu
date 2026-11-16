import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantCouponsTabWidget extends StatelessWidget {
  final List<CouponModel> activeCoupons;
  final List<CouponModel> pastCoupons;
  final ValueChanged<CouponModel>? onCouponTap;

  const RestaurantCouponsTabWidget({
    super.key,
    required this.activeCoupons,
    required this.pastCoupons,
    this.onCouponTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Coupons
          ...activeCoupons.map((coupon) => _buildCouponTicket(coupon)),

          if (pastCoupons.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Past coupons',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            ...pastCoupons.map((coupon) => _buildCouponTicket(coupon)),
          ],
        ],
      ),
    );
  }

  Widget _buildCouponTicket(CouponModel coupon) {
    Color valBg;
    Color valTextColor;
    if (coupon.isDark) {
      valBg = AppColors.navy;
      valTextColor = Colors.white;
    } else if (coupon.isPast) {
      valBg = const Color(0xFFE9E3D8);
      valTextColor = const Color(0xFF71717A);
    } else {
      valBg = AppColors.coral;
      valTextColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => onCouponTap?.call(coupon),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Stub
                Container(
                  width: 92,
                  color: valBg,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (coupon.icon != null) ...[
                        Icon(
                          coupon.icon,
                          size: 26,
                          color: valTextColor,
                        ),
                        const SizedBox(height: 2),
                      ] else ...[
                        Text(
                          coupon.discountVal,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: valTextColor,
                            height: 1.1,
                          ),
                        ),
                      ],
                      Text(
                        coupon.discountSmall.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: valTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashed Divider Line
                CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: _DashedLinePainter(),
                ),

                // Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coupon.type.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          coupon.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: coupon.isPast
                                ? const Color(0xFF71717A)
                                : AppColors.navy,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          coupon.requirement,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Foot row with status badge & meta
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _buildStatusBadge(
                                coupon.statusType, coupon.statusText),
                            if (coupon.meta != null)
                              Text(
                                coupon.meta!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: AppColors.text,
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
          ),

          // Semicircular top cutout
          Positioned(
            left: 84,
            top: -9,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cream,
                border: Border.all(color: AppColors.line),
              ),
            ),
          ),

          // Semicircular bottom cutout
          Positioned(
            left: 84,
            bottom: -9,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cream,
                border: Border.all(color: AppColors.line),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatusBadge(CouponStatusType type, String text) {
    Color bg;
    Color color;

    switch (type) {
      case CouponStatusType.available:
        bg = const Color(0xFFE6F4EA);
        color = const Color(0xFF1F7A45);
        break;
      case CouponStatusType.wait:
        bg = const Color(0xFFFDF0D9);
        color = const Color(0xFF8A5300);
        break;
      case CouponStatusType.expired:
        bg = const Color(0xFFF1ECE2);
        color = const Color(0xFF52525B);
        break;
      case CouponStatusType.used:
        bg = const Color(0xFFE6F4EA);
        color = const Color(0xFF1F7A45);
        break;
    }

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = const Color(0xFFE3DACB)
      ..strokeWidth = 1.5;

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
