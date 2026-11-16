import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class CouponQrView extends StatefulWidget {
  final String restaurant;
  final String discount;
  final String title;
  final bool openRedemptionSuccess;

  const CouponQrView({
    super.key,
    this.restaurant = 'Trattoria Nonna Rosa',
    this.discount = '20% OFF',
    this.title = '20% off your whole bill',
    this.openRedemptionSuccess = false,
  });

  @override
  State<CouponQrView> createState() => _CouponQrViewState();
}

class _CouponQrViewState extends State<CouponQrView> {
  int _secondsLeft = 272; // 04:32
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsLeft / 300.0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
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
                      'Redeem coupon',
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

            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    // Restaurant badge (Image 2: dark slate badge + restaurant name)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E3A3F),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                widget.restaurant.length >= 2
                                    ? widget.restaurant
                                        .split(' ')
                                        .take(2)
                                        .map((w) => w[0])
                                        .join()
                                    : 'NR',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.restaurant,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Discount benefit
                    Text(
                      widget.discount,
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.coral,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // QR Card (Image 2)
                    Container(
                      width: 230,
                      height: 230,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.line, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(194, 194),
                            painter: _QrCodePainter(),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.line,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.sparkles,
                                  color: AppColors.coral,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rivjuuu',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Timer Capsule Pill (Image 2)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.clock,
                            size: 15,
                            color: AppColors.coral,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Valid for $_formattedTime',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Timer Progress Bar
                    Container(
                      width: 180,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1ECE2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Instruction
                    Text(
                      'Show this QR code to restaurant staff.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Note
                    Text(
                      'The restaurant will check that your purchase meets the coupon conditions before scanning.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF52525B),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom "Done" Button (Navigates to 3rd Reference Screen: RedemptionSuccessPage)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (widget.openRedemptionSuccess) {
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.redemptionSuccess,
                        arguments: {
                          'restaurant': widget.restaurant,
                          'coupon': widget.title,
                          'redeemed': '8 Oct 2026, 19:42',
                          'loyaltyPoints': '+40 points',
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: const BorderSide(color: AppColors.line, width: 1.5),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Corner patterns
    _drawCorner(canvas, paint, 0, 0);
    _drawCorner(canvas, paint, size.width - 50, 0);
    _drawCorner(canvas, paint, 0, size.height - 50);

    // Decorative QR data matrix blocks
    final randomBlocks = [
      const Rect.fromLTWH(60, 10, 12, 12),
      const Rect.fromLTWH(80, 10, 16, 12),
      const Rect.fromLTWH(110, 10, 14, 12),
      const Rect.fromLTWH(60, 30, 24, 12),
      const Rect.fromLTWH(100, 30, 18, 12),
      const Rect.fromLTWH(10, 60, 14, 24),
      const Rect.fromLTWH(30, 60, 20, 12),
      const Rect.fromLTWH(140, 60, 18, 14),
      const Rect.fromLTWH(165, 60, 20, 14),
      const Rect.fromLTWH(10, 90, 24, 14),
      const Rect.fromLTWH(40, 90, 14, 20),
      const Rect.fromLTWH(140, 90, 16, 20),
      const Rect.fromLTWH(165, 90, 20, 14),
      const Rect.fromLTWH(60, 140, 16, 16),
      const Rect.fromLTWH(85, 140, 20, 14),
      const Rect.fromLTWH(115, 140, 16, 20),
      const Rect.fromLTWH(60, 165, 24, 16),
      const Rect.fromLTWH(95, 165, 16, 16),
      const Rect.fromLTWH(120, 165, 20, 16),
      const Rect.fromLTWH(145, 140, 20, 20),
      const Rect.fromLTWH(170, 140, 14, 20),
      const Rect.fromLTWH(145, 165, 16, 16),
      const Rect.fromLTWH(165, 165, 20, 16),
    ];

    for (final rect in randomBlocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2.5)),
        paint,
      );
    }
  }

  void _drawCorner(Canvas canvas, Paint paint, double x, double y) {
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    // Outer frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 3.5, y + 3.5, 43, 43),
        const Radius.circular(8),
      ),
      strokePaint,
    );

    // Inner dot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 14, y + 14, 22, 22),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
