import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/map_pin_model.dart';

class MapVectorCanvasWidget extends StatelessWidget {
  final List<MapPinModel> pins;
  final String selectedPinId;
  final Offset userLocation;
  final ValueChanged<String> onPinSelected;

  const MapVectorCanvasWidget({
    super.key,
    required this.pins,
    required this.selectedPinId,
    required this.userLocation,
    required this.onPinSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Base design resolution: 390 x 844
        final scaleX = w / 390.0;
        final scaleY = h / 844.0;

        return Stack(
          children: [
            // 1. Vector Map Background Painter
            Positioned.fill(
              child: CustomPaint(
                painter: _MapCanvasPainter(
                  scaleX: scaleX,
                  scaleY: scaleY,
                ),
              ),
            ),

            // 2. User Location 'Me' Pin
            Positioned(
              left: userLocation.dx * scaleX - 18,
              top: userLocation.dy * scaleY - 18,
              child: _buildMeDot(),
            ),

            // 3. Restaurant Pins
            ...pins.map((pin) {
              final isSelected = pin.id == selectedPinId;
              final posX = pin.dx * scaleX;
              final posY = pin.dy * scaleY;

              return Positioned(
                left: isSelected ? posX - 25 : posX - 19,
                top: isSelected ? posY - 50 : posY - 38,
                child: GestureDetector(
                  onTap: () => onPinSelected(pin.id),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Floating label for selected pin
                      if (isSelected)
                        Positioned(
                          top: -34,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(24, 24, 27, 0.25),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              pin.name,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      // Teardrop Pin
                      _buildPinShape(isSelected: isSelected),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildMeDot() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3D7BF5).withValues(alpha: 0.18),
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF3D7BF5),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(61, 123, 245, 0.35),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinShape({required bool isSelected}) {
    final size = isSelected ? 50.0 : 38.0;
    final iconSize = isSelected ? 22.0 : 18.0;
    final bgColor = isSelected ? AppColors.navy : AppColors.coral;
    final shadowColor = isSelected
        ? const Color.fromRGBO(24, 24, 27, 0.35)
        : const Color.fromRGBO(254, 85, 46, 0.35);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isSelected ? 16 : 10,
            offset: Offset(0, isSelected ? 6 : 4),
          ),
        ],
      ),
      child: Transform.rotate(
        angle: -math.pi / 4,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size / 2),
              topRight: Radius.circular(size / 2),
              bottomLeft: Radius.circular(size / 2),
              bottomRight: Radius.zero,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Icon(
                Icons.restaurant_rounded,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double scaleX;
  final double scaleY;

  _MapCanvasPainter({required this.scaleX, required this.scaleY});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background fill
    final bgPaint = Paint()..color = const Color(0xFFECEEE9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. River / Water Path (right curved blue river)
    final riverPaint = Paint()
      ..color = const Color(0xFFD4E6F3)
      ..style = PaintingStyle.fill;
    final riverPath = Path();
    riverPath.moveTo(250 * scaleX, 0);
    riverPath.cubicTo(
      230 * scaleX,
      160 * scaleY,
      300 * scaleX,
      260 * scaleY,
      290 * scaleX,
      420 * scaleY,
    );
    riverPath.cubicTo(
      340 * scaleX,
      700 * scaleY,
      320 * scaleX,
      844 * scaleY,
      320 * scaleX,
      844 * scaleY,
    );
    riverPath.lineTo(size.width, size.height);
    riverPath.lineTo(size.width, 0);
    riverPath.close();
    canvas.drawPath(riverPath, riverPaint);

    // 3. Green Parks
    final parkPaint = Paint()
      ..color = const Color(0xFFD3E8D4)
      ..style = PaintingStyle.fill;

    // Park 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          22 * scaleX,
          300 * scaleY,
          120 * scaleX,
          96 * scaleY,
        ),
        Radius.circular(14 * scaleX),
      ),
      parkPaint,
    );

    // Park 2
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          170 * scaleX,
          560 * scaleY,
          90 * scaleX,
          70 * scaleY,
        ),
        Radius.circular(12 * scaleX),
      ),
      parkPaint,
    );

    // 4. Building Blocks
    final buildingPaint = Paint()
      ..color = const Color(0xFFE3E3DD)
      ..style = PaintingStyle.fill;

    final buildings = [
      Rect.fromLTWH(30 * scaleX, 140 * scaleY, 80 * scaleX, 60 * scaleY),
      Rect.fromLTWH(140 * scaleX, 150 * scaleY, 70 * scaleX, 80 * scaleY),
      Rect.fromLTWH(40 * scaleX, 440 * scaleY, 90 * scaleX, 70 * scaleY),
      Rect.fromLTWH(160 * scaleX, 430 * scaleY, 70 * scaleX, 90 * scaleY),
      Rect.fromLTWH(30 * scaleX, 660 * scaleY, 100 * scaleX, 70 * scaleY),
      Rect.fromLTWH(150 * scaleX, 680 * scaleY, 80 * scaleX, 80 * scaleY),
    ];

    for (final b in buildings) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(b, Radius.circular(8 * scaleX)),
        buildingPaint,
      );
    }

    // 5. White Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawRoad(double x1, double y1, double x2, double y2, double stroke) {
      roadPaint.strokeWidth = stroke * scaleX;
      canvas.drawLine(
        Offset(x1 * scaleX, y1 * scaleY),
        Offset(x2 * scaleX, y2 * scaleY),
        roadPaint,
      );
    }

    drawRoad(-10, 250, 400, 220, 16);
    drawRoad(-10, 540, 400, 600, 14);
    drawRoad(150, -10, 120, 860, 16);
    drawRoad(-10, 410, 260, 400, 9);
    drawRoad(60, -10, 80, 860, 8);
    drawRoad(240, -10, 230, 860, 9);
    drawRoad(-10, 120, 300, 100, 7);
    drawRoad(-10, 760, 300, 740, 7);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.scaleX != scaleX || oldDelegate.scaleY != scaleY;
  }
}

