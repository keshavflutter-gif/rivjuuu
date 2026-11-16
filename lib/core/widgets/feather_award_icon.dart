import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FeatherAwardIcon extends StatelessWidget {
  final double size;
  final Color color;

  const FeatherAwardIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FeatherAwardPainter(color: color),
      ),
    );
  }
}

class _FeatherAwardPainter extends CustomPainter {
  final Color color;

  _FeatherAwardPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scaleX = size.width / 24.0;
    final scaleY = size.height / 24.0;
    canvas.scale(scaleX, scaleY);

    // circle cx='12' cy='9' r='6'
    canvas.drawCircle(const Offset(12, 9), 6, stroke);

    // path d='m8.5 14-1.5 7 5-3 5 3-1.5-7'
    final path = Path()
      ..moveTo(8.5, 14)
      ..lineTo(7, 21)
      ..lineTo(12, 18)
      ..lineTo(17, 21)
      ..lineTo(15.5, 14);

    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _FeatherAwardPainter oldDelegate) =>
      oldDelegate.color != color;
}

