import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/restaurant_bottom_nav_bar.dart';
import 'restaurant_scan_result_page.dart';

/// Full-screen restaurant QR scanner page matching [scanner.html]
class RestaurantScannerPage extends StatelessWidget {
  final bool animate;

  const RestaurantScannerPage({
    super.key,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RestaurantScannerView(isEmbedded: false, animate: animate),
    );
  }
}

/// Core scanner view with camera background simulation, viewfinder,
/// QR ghost graphic, animated laser scan line, and action controls.
class RestaurantScannerView extends StatefulWidget {
  final bool isEmbedded;
  final bool animate;

  const RestaurantScannerView({
    super.key,
    this.isEmbedded = false,
    this.animate = true,
  });

  @override
  State<RestaurantScannerView> createState() => _RestaurantScannerViewState();
}

class _RestaurantScannerViewState extends State<RestaurantScannerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanLineController;
  late final Animation<double> _scanLineAnimation;

  MobileScannerController? _scannerController;
  Timer? _validationTimer;

  bool _flashOn = false;
  bool _isValidating = false;
  bool _cameraHasError = false;

  bool get _isSimulated =>
      Platform.environment.containsKey('FLUTTER_TEST') ||
      widget.isEmbedded ||
      _cameraHasError ||
      _scannerController == null;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scanLineAnimation = CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    );

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest && !widget.isEmbedded) {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
        returnImage: false,
      );
    }

    if (widget.animate && !widget.isEmbedded && !isTest) {
      _scanLineController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant RestaurantScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (widget.animate != oldWidget.animate || widget.isEmbedded != oldWidget.isEmbedded) {
      if (widget.animate && !widget.isEmbedded && !isTest) {
        if (!_scanLineController.isAnimating) {
          _scanLineController.repeat(reverse: true);
        }
      } else {
        _scanLineController.stop();
      }
    }
  }

  @override
  void dispose() {
    _validationTimer?.cancel();
    _scanLineController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    HapticFeedback.selectionClick();
    if (_scannerController != null) {
      try {
        await _scannerController!.toggleTorch();
      } catch (_) {}
    }
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  void _onScanDetected() {
    _onRealBarcodeDetected('RV-20OFF');
  }

  void _onRealBarcodeDetected(String rawCode) {
    if (_isValidating) return;
    try {
      _scannerController?.stop();
    } catch (_) {}

    // Haptic feedback simulating QR code detection beep/vibration
    HapticFeedback.heavyImpact();

    setState(() {
      _isValidating = true;
    });

    String couponTitle = '20% off your whole bill';
    String points = '+40 points';

    final lower = rawCode.toLowerCase();
    if (lower.contains('1+1') || lower.contains('margherita')) {
      couponTitle = 'Second Margherita free';
      points = '+20 points';
    } else if (lower.contains('tiramisu') || lower.contains('gift')) {
      couponTitle = 'Free tiramisu with any main';
      points = '+25 points';
    } else if (lower.contains('huf') || lower.contains('2000') || lower.contains('2,000')) {
      couponTitle = '2,000 HUF off your bill';
      points = '+30 points';
    }

    // Simulate validation delay matching scanner-validating.html
    _validationTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.restaurantScanResult,
        arguments: RestaurantScanResultArgs(
          guestName: 'Anna K.',
          guestInitials: 'AK',
          couponTitle: couponTitle,
          minSpend: '5,000 HUF',
          validity: 'Until 31 Oct, 12:00–22:00',
          points: points,
          scannedCode: rawCode,
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _isValidating = false;
          });
          try {
            _scannerController?.start();
          } catch (_) {}
        }
      });
    });
  }

  void _openEnterCodeSheet() {
    final textController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter coupon code',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.cream,
                        shape: BoxShape.circle,
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
              const SizedBox(height: 8),
              Text(
                'Enter the 8-character code displayed under the customer’s QR code.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: textController,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: AppColors.navy,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. RV-20OFF',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.cream,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final code = textController.text.trim();
                    Navigator.pop(ctx);
                    _onRealBarcodeDetected(code.isEmpty ? 'RV-20OFF' : code);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Check coupon',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const frameSize = 248.0;

    // Viewfinder vertical position: center at ~42% of screen height
    final frameTop = screenSize.height * 0.42 - (frameSize / 2);
    final frameRect = Rect.fromLTWH(
      (screenSize.width - frameSize) / 2,
      frameTop,
      frameSize,
      frameSize,
    );

    final cornerColor = _isValidating ? const Color(0xFF49D17D) : Colors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Camera Layer (Live MobileScanner on device with fallback to simulated preview)
        Positioned.fill(
          child: _buildCameraLayer(frameRect),
        ),

        // 2. Punch-hole vignette mask outside the 248x248 viewfinder (.sframe::before)
        CustomPaint(
          size: screenSize,
          painter: _ScannerBackdropPainter(
            cutoutRect: frameRect,
            cornerRadius: const Radius.circular(28),
          ),
        ),

        // 3. Viewfinder Target Frame (.sframe)
        Positioned(
          left: frameRect.left,
          top: frameRect.top,
          width: frameSize,
          height: frameSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onScanDetected,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Rounded corner brackets
                CustomPaint(
                  size: const Size(frameSize, frameSize),
                  painter: _ViewfinderCornersPainter(
                    color: cornerColor,
                    strokeWidth: 5.0,
                    armLength: 48.0,
                    radius: 28.0,
                  ),
                ),

                // Center Ghost QR graphic (.qrghost) - only visible in simulation / test fallback
                if (_isSimulated)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(52.0),
                      child: CustomPaint(
                        painter: _QrGhostPainter(
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),

                // Animated Laser Scan Line (.sframe .line)
                if (!_isValidating)
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      final topOffset = 24.0 +
                          (_scanLineAnimation.value * (frameSize - 48.0 - 3.0));
                      return Positioned(
                        left: 20,
                        right: 20,
                        top: topOffset,
                        height: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.coral.withValues(alpha: 0.9),
                                blurRadius: 14,
                                spreadRadius: 1.5,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                // Validating Indicator (.validating)
                if (_isValidating)
                  Center(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xD118181B), // rgba(24, 24, 27, .82)
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Checking coupon…',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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

        // 4. Instructional message under viewfinder (.scan-msg)
        Positioned(
          left: 24,
          right: 24,
          top: frameRect.bottom + 26,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isValidating
                    ? 'QR code detected'
                    : 'Scan the customer’s Rivjuuu QR code',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  height: 23 / 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 290),
                child: Text(
                  _isValidating
                      ? 'Hold still for a moment.'
                      : 'Check the order meets the coupon conditions before scanning.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 19 / 13,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5. Top Bar (.scan-top)
        Positioned(
          left: 16,
          right: 16,
          top: 0,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button (.round--dark)
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Scan coupon',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Flash button (.round--dark)
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _flashOn
                            ? Colors.white.withValues(alpha: 0.35)
                            : Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: RestaurantZapIcon(
                          size: 20,
                          color: _flashOn ? AppColors.coral : Colors.white,
                          filled: _flashOn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 6. Bottom Controls (.scan-bottom)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flash action
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: _flashOn
                                ? Colors.white.withValues(alpha: 0.35)
                                : Colors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: RestaurantZapIcon(
                              size: 22,
                              color: _flashOn ? AppColors.coral : Colors.white,
                              filled: _flashOn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Flash',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // Enter code action
                  GestureDetector(
                    onTap: _openEnterCodeSheet,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: RestaurantTicketIcon(
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter code',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraLayer(Rect frameRect) {
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (isTest || widget.isEmbedded || _scannerController == null || _cameraHasError) {
      return _buildSimulatedCameraView();
    }

    return MobileScanner(
      controller: _scannerController,
      fit: BoxFit.cover,
      onDetect: (capture) {
        if (_isValidating) return;
        for (final barcode in capture.barcodes) {
          final raw = barcode.rawValue ?? barcode.displayValue;
          if (raw != null && raw.trim().isNotEmpty) {
            _onRealBarcodeDetected(raw.trim());
            break;
          }
        }
      },
      errorBuilder: (context, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_cameraHasError) {
            setState(() {
              _cameraHasError = true;
            });
          }
        });
        return _buildSimulatedCameraView();
      },
      placeholderBuilder: (context) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimulatedCameraView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onScanDetected,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Transform.scale(
              scale: 1.05,
              child: Image.asset(
                'assets/dining.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF1B1715),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: _flashOn ? 0.30 : 0.48),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom Painters for Pixel-Perfect Viewfinder, Vignette & QR Ghost
// ---------------------------------------------------------------------------

/// Paints punch-hole darkened backdrop outside the viewfinder (.sframe::before)
class _ScannerBackdropPainter extends CustomPainter {
  final Rect cutoutRect;
  final Radius cornerRadius;

  _ScannerBackdropPainter({
    required this.cutoutRect,
    this.cornerRadius = const Radius.circular(28),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, cornerRadius));

    final backdropPath =
        Path.combine(PathOperation.difference, fullScreenPath, cutoutPath);

    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    canvas.drawPath(backdropPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerBackdropPainter oldDelegate) =>
      oldDelegate.cutoutRect != cutoutRect;
}

/// Paints the 4 rounded corner brackets with exact 28px border-radius (.sframe i.c)
class _ViewfinderCornersPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double armLength;
  final double radius;

  _ViewfinderCornersPainter({
    required this.color,
    this.strokeWidth = 5.0,
    this.armLength = 48.0,
    this.radius = 28.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final half = strokeWidth / 2;
    final w = size.width;
    final h = size.height;

    // Top-Left corner (c1)
    final tl = Path()
      ..moveTo(half, armLength)
      ..lineTo(half, radius)
      ..arcToPoint(
        Offset(radius, half),
        radius: Radius.circular(radius - half),
      )
      ..lineTo(armLength, half);
    canvas.drawPath(tl, paint);

    // Top-Right corner (c2)
    final tr = Path()
      ..moveTo(w - armLength, half)
      ..lineTo(w - radius, half)
      ..arcToPoint(
        Offset(w - half, radius),
        radius: Radius.circular(radius - half),
      )
      ..lineTo(w - half, armLength);
    canvas.drawPath(tr, paint);

    // Bottom-Left corner (c3)
    final bl = Path()
      ..moveTo(half, h - armLength)
      ..lineTo(half, h - radius)
      ..arcToPoint(
        Offset(radius, h - half),
        radius: Radius.circular(radius - half),
      )
      ..lineTo(armLength, h - half);
    canvas.drawPath(bl, paint);

    // Bottom-Right corner (c4)
    final br = Path()
      ..moveTo(w - armLength, h - half)
      ..lineTo(w - radius, h - half)
      ..arcToPoint(
        Offset(w - half, h - radius),
        radius: Radius.circular(radius - half),
      )
      ..lineTo(w - half, h - armLength);
    canvas.drawPath(br, paint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderCornersPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Paints the ghost QR code graphic with 21x21 modules (.qrghost)
class _QrGhostPainter extends CustomPainter {
  final Color color;

  const _QrGhostPainter({required this.color});

  static const List<Offset> _qrDots = [
    Offset(8, 0), Offset(11, 0), Offset(12, 0), Offset(7, 1), Offset(8, 1), Offset(9, 1), Offset(10, 1), Offset(11, 1), Offset(7, 2), Offset(9, 2), Offset(7, 3), Offset(8, 3), Offset(12, 3), Offset(13, 3), Offset(8, 4), Offset(11, 4), Offset(12, 4), Offset(7, 5), Offset(8, 5), Offset(9, 5), Offset(10, 5), Offset(7, 6), Offset(9, 6), Offset(10, 6), Offset(12, 6), Offset(0, 7), Offset(2, 7), Offset(3, 7), Offset(4, 7), Offset(6, 7), Offset(7, 7), Offset(8, 7), Offset(9, 7), Offset(10, 7), Offset(11, 7), Offset(12, 7), Offset(15, 7), Offset(17, 7), Offset(18, 7), Offset(20, 7), Offset(0, 8), Offset(6, 8), Offset(7, 8), Offset(9, 8), Offset(12, 8), Offset(14, 8), Offset(15, 8), Offset(16, 8), Offset(17, 8), Offset(19, 8), Offset(2, 9), Offset(4, 9), Offset(5, 9), Offset(6, 9), Offset(11, 9), Offset(14, 9), Offset(15, 9), Offset(18, 9), Offset(3, 10), Offset(5, 10), Offset(7, 10), Offset(8, 10), Offset(10, 10), Offset(11, 10), Offset(12, 10), Offset(14, 10), Offset(15, 10), Offset(17, 10), Offset(19, 10), Offset(20, 10), Offset(1, 11), Offset(2, 11), Offset(4, 11), Offset(5, 11), Offset(6, 11), Offset(7, 11), Offset(9, 11), Offset(14, 11), Offset(16, 11), Offset(19, 11), Offset(20, 11), Offset(2, 12), Offset(3, 12), Offset(4, 12), Offset(6, 12), Offset(7, 12), Offset(9, 12), Offset(11, 12), Offset(13, 12), Offset(14, 12), Offset(16, 12), Offset(17, 12), Offset(18, 12), Offset(19, 12), Offset(20, 12), Offset(0, 13), Offset(3, 13), Offset(4, 13), Offset(7, 13), Offset(8, 13), Offset(12, 13), Offset(13, 13), Offset(14, 13), Offset(17, 13), Offset(18, 13), Offset(19, 13), Offset(20, 13), Offset(7, 14), Offset(8, 14), Offset(9, 14), Offset(11, 14), Offset(13, 14), Offset(14, 14), Offset(16, 14), Offset(17, 14), Offset(18, 14), Offset(7, 15), Offset(8, 15), Offset(9, 15), Offset(10, 15), Offset(12, 15), Offset(13, 15), Offset(14, 15), Offset(15, 15), Offset(16, 15), Offset(18, 15), Offset(9, 16), Offset(10, 16), Offset(12, 16), Offset(13, 16), Offset(14, 16), Offset(17, 16), Offset(19, 16), Offset(7, 17), Offset(9, 17), Offset(10, 17), Offset(14, 17), Offset(15, 17), Offset(16, 17), Offset(18, 17), Offset(10, 18), Offset(11, 18), Offset(12, 18), Offset(14, 18), Offset(16, 18), Offset(17, 18), Offset(18, 18), Offset(19, 18), Offset(7, 19), Offset(9, 19), Offset(10, 19), Offset(11, 19), Offset(17, 19), Offset(18, 19), Offset(7, 20), Offset(10, 20), Offset(11, 20), Offset(12, 20), Offset(16, 20), Offset(19, 20)
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 21.0;
    canvas.save();
    canvas.scale(scale, scale);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Top-Left Finder pattern
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.5, 0.5, 6, 6),
        const Radius.circular(1.4),
      ),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 3, 3),
        const Radius.circular(0.6),
      ),
      fillPaint,
    );

    // 2. Top-Right Finder pattern
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14.5, 0.5, 6, 6),
        const Radius.circular(1.4),
      ),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(16, 2, 3, 3),
        const Radius.circular(0.6),
      ),
      fillPaint,
    );

    // 3. Bottom-Left Finder pattern
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.5, 14.5, 6, 6),
        const Radius.circular(1.4),
      ),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 16, 3, 3),
        const Radius.circular(0.6),
      ),
      fillPaint,
    );

    // 4. Data Modules
    for (final dot in _qrDots) {
      canvas.drawRect(
        Rect.fromLTWH(dot.dx, dot.dy, 1.0, 1.0),
        fillPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QrGhostPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Vector Lightning / Flash Icon (.ic-zap)
class RestaurantZapIcon extends StatelessWidget {
  final double size;
  final Color color;
  final bool filled;

  const RestaurantZapIcon({
    super.key,
    this.size = 22,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ZapIconPainter(color: color, filled: filled),
    );
  }
}

class _ZapIconPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _ZapIconPainter({required this.color, this.filled = false});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final path = Path()
      ..moveTo(13, 2)
      ..lineTo(4, 14)
      ..lineTo(11, 14)
      ..lineTo(10, 22)
      ..lineTo(19, 10)
      ..lineTo(12, 10)
      ..close();

    if (filled) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ZapIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}
