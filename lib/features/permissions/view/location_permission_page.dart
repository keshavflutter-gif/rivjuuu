import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),

              // Map & Pin Illustration
              const _MapIllustration(),

              const SizedBox(height: 36),

              // Title
              Text(
                'Discover restaurants\nnear you',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Allow location access to find nearby restaurants and view them on the map.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.text,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.notificationPermission);
                  },
                  child: Text(
                    'Allow location',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.notificationPermission);
                  },
                  child: Text(
                    'Not now',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapIllustration extends StatelessWidget {
  const _MapIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base map card
          Container(
            width: 230,
            height: 178,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0EF),
              borderRadius: BorderRadius.circular(28),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              painter: _MapRoadsPainter(),
            ),
          ),

          // Ground shadow under pin
          Positioned(
            bottom: 30,
            child: Container(
              width: 44,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Pin marker
          Positioned(
            bottom: 34,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(254, 85, 46, 0.35),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: ContainerWhiteDot(),
                  ),
                ),
                CustomPaint(
                  size: const Size(18, 12),
                  painter: _PinTailPainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerWhiteDot extends StatelessWidget {
  const ContainerWhiteDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MapRoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Roads
    canvas.drawLine(const Offset(-10, 70), Offset(size.width + 10, 40), roadPaint);
    canvas.drawLine(const Offset(-10, 140), Offset(size.width + 10, 118), roadPaint);
    canvas.drawLine(const Offset(70, -10), const Offset(95, 200), roadPaint);
    canvas.drawLine(const Offset(170, -10), const Offset(150, 200), roadPaint);
    canvas.drawLine(const Offset(-10, 104), Offset(size.width + 10, 80), thinRoadPaint);

    // Green Building area
    final greenArea = Paint()..color = const Color(0xFFCDE8D3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(26, 84, 34, 30),
        const Radius.circular(6),
      ),
      greenArea,
    );

    // Blue Building blocks
    final grayBlock = Paint()..color = const Color(0xFFDFE3EA);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(186, 128, 34, 26),
        const Radius.circular(6),
      ),
      grayBlock,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(104, 18, 36, 22),
        const Radius.circular(6),
      ),
      grayBlock,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

