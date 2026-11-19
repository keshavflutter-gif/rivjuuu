import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../extensions/localization_extension.dart';

class RestaurantBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RestaurantBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  _buildNavItem(
                    index: 0,
                    iconBuilder: (color) => RestaurantDashboardIcon(size: 22, color: color),
                    label: context.l10n.navDashboard,
                  ),
                  _buildNavItem(
                    index: 1,
                    iconBuilder: (color) => RestaurantTicketIcon(size: 22, color: color),
                    label: context.l10n.navCoupons,
                  ),
                  const Expanded(child: SizedBox()), // Center gap for raised scan
                  _buildNavItem(
                    index: 3,
                    iconBuilder: (color) => RestaurantActivityIcon(size: 22, color: color),
                    label: context.l10n.navActivity,
                  ),
                  _buildNavItem(
                    index: 4,
                    iconBuilder: (color) => RestaurantUserIcon(size: 22, color: color),
                    label: context.l10n.navProfile,
                  ),
                ],
              ),
              // Raised Scan button in center (.rnav a.scan)
              Positioned(
                top: -24,
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.coral.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: RestaurantScanIcon(
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.navScan,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          height: 1.27,
                          fontWeight: FontWeight.w600,
                          color: currentIndex == 2
                              ? AppColors.coral
                              : AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget Function(Color color) iconBuilder,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.coral : const Color(0xFF71717A);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconBuilder(color),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                height: 1.27,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vector Icons Matching Figma / HTML CSS Specifications
// ---------------------------------------------------------------------------

/// Scan viewfinder icon (.ic-scan)
class RestaurantScanIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantScanIcon({super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ScanIconPainter(color: color),
    );
  }
}

class _ScanIconPainter extends CustomPainter {
  final Color color;

  _ScanIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Top-left corner
    final tl = Path()
      ..moveTo(3, 7)
      ..lineTo(3, 5)
      ..arcToPoint(const Offset(5, 3), radius: const Radius.circular(2))
      ..lineTo(7, 3);
    canvas.drawPath(tl, paint);

    // Top-right corner
    final tr = Path()
      ..moveTo(17, 3)
      ..lineTo(19, 3)
      ..arcToPoint(const Offset(21, 5), radius: const Radius.circular(2))
      ..lineTo(21, 7);
    canvas.drawPath(tr, paint);

    // Bottom-right corner
    final br = Path()
      ..moveTo(21, 17)
      ..lineTo(21, 19)
      ..arcToPoint(const Offset(19, 21), radius: const Radius.circular(2))
      ..lineTo(17, 21);
    canvas.drawPath(br, paint);

    // Bottom-left corner
    final bl = Path()
      ..moveTo(7, 21)
      ..lineTo(5, 21)
      ..arcToPoint(const Offset(3, 19), radius: const Radius.circular(2))
      ..lineTo(3, 17);
    canvas.drawPath(bl, paint);

    // Center horizontal beam
    canvas.drawLine(const Offset(7, 12), const Offset(17, 12), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScanIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Dashboard grid icon (.ic-dashboard)
class RestaurantDashboardIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantDashboardIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DashboardIconPainter(color: color),
    );
  }
}

class _DashboardIconPainter extends CustomPainter {
  final Color color;

  _DashboardIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Top-left
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(3, 3, 8, 8), const Radius.circular(1.5)),
      paint,
    );
    // Top-right
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(13, 3, 8, 5), const Radius.circular(1.5)),
      paint,
    );
    // Bottom-right
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(13, 10, 8, 11), const Radius.circular(1.5)),
      paint,
    );
    // Bottom-left
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(3, 13, 8, 8), const Radius.circular(1.5)),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DashboardIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Ticket icon (.ic-ticket)
class RestaurantTicketIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantTicketIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TicketIconPainter(color: color),
    );
  }
}

class _TicketIconPainter extends CustomPainter {
  final Color color;

  _TicketIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final path = Path()
      ..moveTo(4, 6)
      ..lineTo(20, 6)
      ..lineTo(20, 9)
      ..arcToPoint(const Offset(20, 15), radius: const Radius.circular(3), clockwise: false)
      ..lineTo(20, 18)
      ..lineTo(4, 18)
      ..lineTo(4, 15)
      ..arcToPoint(const Offset(4, 9), radius: const Radius.circular(3), clockwise: false)
      ..close();

    canvas.drawPath(path, paint);

    // Dashes on right
    canvas.drawLine(const Offset(15, 6), const Offset(15, 8), paint);
    canvas.drawLine(const Offset(15, 11), const Offset(15, 13), paint);
    canvas.drawLine(const Offset(15, 16), const Offset(15, 18), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TicketIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Heartbeat pulse icon (.ic-activity)
class RestaurantActivityIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantActivityIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ActivityIconPainter(color: color),
    );
  }
}

class _ActivityIconPainter extends CustomPainter {
  final Color color;

  _ActivityIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Path: M3 12h4l3-8 4 16 3-8h4
    final path = Path()
      ..moveTo(3, 12)
      ..lineTo(7, 12)
      ..lineTo(10, 4)
      ..lineTo(14, 20)
      ..lineTo(17, 12)
      ..lineTo(21, 12);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ActivityIconPainter oldDelegate) => oldDelegate.color != color;
}

/// User profile outline icon (.ic-user)
class RestaurantUserIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantUserIcon({super.key, this.size = 22, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _UserIconPainter(color: color),
    );
  }
}

class _UserIconPainter extends CustomPainter {
  final Color color;

  _UserIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Head circle: cx=12, cy=8, r=4
    canvas.drawCircle(const Offset(12, 8), 4, paint);

    // Body arc: M4 21a8 8 0 0 1 16 0
    final path = Path()
      ..moveTo(4, 20)
      ..arcToPoint(const Offset(20, 20), radius: const Radius.circular(8));

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UserIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Award / Medal icon (.ic-award)
class RestaurantAwardIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantAwardIcon({super.key, this.size = 16, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AwardIconPainter(color: color),
    );
  }
}

class _AwardIconPainter extends CustomPainter {
  final Color color;

  _AwardIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Circle cx=12, cy=9, r=6
    canvas.drawCircle(const Offset(12, 9), 6, paint);

    // Ribbons: m8.5 14-1.5 7 5-3 5 3-1.5-7
    final ribbons = Path()
      ..moveTo(8.5, 14)
      ..lineTo(7, 21)
      ..lineTo(12, 18)
      ..lineTo(17, 21)
      ..lineTo(15.5, 14);

    canvas.drawPath(ribbons, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AwardIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Gift icon (.ic-gift)
class RestaurantGiftIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantGiftIcon({super.key, this.size = 16, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GiftIconPainter(color: color),
    );
  }
}

class _GiftIconPainter extends CustomPainter {
  final Color color;

  _GiftIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Box lid: rect x=3 y=8 width=18 height=4 rx=1
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(3, 8, 18, 4), const Radius.circular(1)),
      paint,
    );

    // Vertical line: M12 8 v13
    canvas.drawLine(const Offset(12, 8), const Offset(12, 21), paint);

    // Bottom box: M19 12 v8 a1 1 0 0 1-1 1 H6 a1 1 0 0 1-1-1 v-8
    final bottomBox = Path()
      ..moveTo(19, 12)
      ..lineTo(19, 20)
      ..arcToPoint(const Offset(18, 21), radius: const Radius.circular(1))
      ..lineTo(6, 21)
      ..arcToPoint(const Offset(5, 20), radius: const Radius.circular(1))
      ..lineTo(5, 12);
    canvas.drawPath(bottomBox, paint);

    // Bow: M7.5 8 a2.5 2.5 0 0 1 0-5 C10 3 12 8 12 8 s2-5 4.5-5 a2.5 2.5 0 0 1 0 5
    final bow = Path()
      ..moveTo(7.5, 8)
      ..cubicTo(5.5, 8, 5, 4.5, 7.5, 3)
      ..cubicTo(9.5, 3, 12, 8, 12, 8)
      ..cubicTo(12, 8, 14.5, 3, 16.5, 3)
      ..cubicTo(19, 4.5, 18.5, 8, 16.5, 8);
    canvas.drawPath(bow, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GiftIconPainter oldDelegate) => oldDelegate.color != color;
}

/// Eye icon (.ic-eye)
class RestaurantEyeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RestaurantEyeIcon({super.key, this.size = 16, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _EyeIconPainter(color: color),
    );
  }
}

class _EyeIconPainter extends CustomPainter {
  final Color color;

  _EyeIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.0 / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    // Eye outline: M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z
    final eye = Path()
      ..moveTo(2, 12)
      ..cubicTo(5.5, 5, 8.5, 5, 12, 5)
      ..cubicTo(15.5, 5, 18.5, 5, 22, 12)
      ..cubicTo(18.5, 19, 15.5, 19, 12, 19)
      ..cubicTo(8.5, 19, 5.5, 19, 2, 12)
      ..close();
    canvas.drawPath(eye, paint);

    // Pupil: cx=12, cy=12, r=3
    canvas.drawCircle(const Offset(12, 12), 3, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EyeIconPainter oldDelegate) => oldDelegate.color != color;
}

