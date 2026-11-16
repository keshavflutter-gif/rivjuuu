import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantInfoSheetWidget extends StatelessWidget {
  final RestaurantDetailModel restaurant;
  final VoidCallback? onShowOnMap;

  const RestaurantInfoSheetWidget({
    super.key,
    required this.restaurant,
    this.onShowOnMap,
  });

  static Future<void> show(
    BuildContext context, {
    required RestaurantDetailModel restaurant,
    VoidCallback? onShowOnMap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RestaurantInfoSheetWidget(
        restaurant: restaurant,
        onShowOnMap: onShowOnMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 4, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3DACB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header: Title + Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'About ${restaurant.name}',
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Minimap Illustration
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 130,
                width: double.infinity,
                color: const Color(0xFFECEEE9),
                child: CustomPaint(
                  painter: _MiniMapPainter(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info rows
            // 1. Address row
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.fullAddress,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    restaurant.distanceFromYou,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.line, height: 20),

            // 2. Opening Hours row
            _buildInfoRow(
              icon: Icons.access_time_rounded,
              content: Column(
                children: restaurant.aboutHours.map((h) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            h.day,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Text(
                          h.hours,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(color: AppColors.line, height: 20),

            // 3. Description row
            _buildInfoRow(
              icon: Icons.info_outline_rounded,
              content: Text(
                restaurant.aboutDescription,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.text,
                  height: 1.45,
                ),
              ),
            ),
            const Divider(color: AppColors.line, height: 20),

            // 4. Cuisine Tags row
            _buildInfoRow(
              icon: Icons.restaurant_outlined,
              content: Text(
                restaurant.aboutTags,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ghost button: Show on map (interactive pressed state matching reference prototype)
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onShowOnMap?.call();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.coral;
                      }
                      return Colors.white;
                    },
                  ),
                  foregroundColor: WidgetStateProperty.all(AppColors.navy),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  elevation: WidgetStateProperty.all(0),
                  side: WidgetStateProperty.resolveWith<BorderSide>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const BorderSide(color: AppColors.coral, width: 1);
                      }
                      return const BorderSide(color: AppColors.line, width: 1);
                    },
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: AppColors.navy,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Show on map',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required Widget content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.text,
        ),
        const SizedBox(width: 14),
        Expanded(child: content),
      ],
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Road paint
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Road 1 (horizontal angled)
    roadPaint.strokeWidth = 12;
    canvas.drawLine(
      Offset(-10, size.height * 0.55),
      Offset(size.width + 10, size.height * 0.4),
      roadPaint,
    );

    // Road 2 (vertical 1)
    roadPaint.strokeWidth = 10;
    canvas.drawLine(
      Offset(size.width * 0.35, -10),
      Offset(size.width * 0.3, size.height + 10),
      roadPaint,
    );

    // Road 3 (vertical 2)
    roadPaint.strokeWidth = 8;
    canvas.drawLine(
      Offset(size.width * 0.75, -10),
      Offset(size.width * 0.72, size.height + 10),
      roadPaint,
    );

    // Park patch (green rounded rect)
    final parkPaint = Paint()
      ..color = const Color(0xFFD3E8D4)
      ..style = PaintingStyle.fill;
    final parkRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, size.height * 0.65, 65, 34),
      const Radius.circular(8),
    );
    canvas.drawRRect(parkRRect, parkPaint);

    // Coral Location Pin at Center
    final pinCenter = Offset(size.width * 0.5, size.height * 0.42);
    final pinPath = Path();
    pinPath.moveTo(pinCenter.dx, pinCenter.dy + 20);
    pinPath.cubicTo(
      pinCenter.dx - 12,
      pinCenter.dy + 6,
      pinCenter.dx - 14,
      pinCenter.dy - 6,
      pinCenter.dx - 14,
      pinCenter.dy - 12,
    );
    pinPath.arcToPoint(
      Offset(pinCenter.dx + 14, pinCenter.dy - 12),
      radius: const Radius.circular(14),
      clockwise: true,
    );
    pinPath.cubicTo(
      pinCenter.dx + 14,
      pinCenter.dy - 6,
      pinCenter.dx + 12,
      pinCenter.dy + 6,
      pinCenter.dx,
      pinCenter.dy + 20,
    );
    pinPath.close();

    // Shadow
    canvas.drawCircle(
      Offset(pinCenter.dx, pinCenter.dy + 21),
      4,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Pin fill
    canvas.drawPath(
      pinPath,
      Paint()..color = AppColors.coral,
    );

    // White dot inside pin
    canvas.drawCircle(
      Offset(pinCenter.dx, pinCenter.dy - 10),
      5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
