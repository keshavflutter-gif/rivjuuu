import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

/// Arguments for [RestaurantScanResultPage]
class RestaurantScanResultArgs {
  final String guestName;
  final String guestInitials;
  final String couponTitle;
  final String minSpend;
  final String validity;
  final String points;
  final String? scannedCode;

  const RestaurantScanResultArgs({
    this.guestName = 'Anna K.',
    this.guestInitials = 'AK',
    this.couponTitle = '20% off your whole bill',
    this.minSpend = '5,000 HUF',
    this.validity = 'Until 31 Oct, 12:00–22:00',
    this.points = '+40 points',
    this.scannedCode,
  });
}

/// Screen displayed after a coupon QR code is scanned matching [scan-valid.html]
class RestaurantScanResultPage extends StatefulWidget {
  final RestaurantScanResultArgs args;

  const RestaurantScanResultPage({
    super.key,
    this.args = const RestaurantScanResultArgs(),
  });

  String get guestName => args.guestName;
  String get guestInitials => args.guestInitials;
  String get couponTitle => args.couponTitle;
  String get minSpend => args.minSpend;
  String get validity => args.validity;
  String get points => args.points;
  String? get scannedCode => args.scannedCode;

  @override
  State<RestaurantScanResultPage> createState() => _RestaurantScanResultPageState();
}

class _RestaurantScanResultPageState extends State<RestaurantScanResultPage> {
  bool _isRedeemed = false;

  void _onConfirmRedemption() {
    setState(() {
      _isRedeemed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (.bar)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _isRedeemed ? 'Redemption confirmed' : 'Scan result',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42), // Balance back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: _isRedeemed
                    ? _buildSuccessView()
                    : _buildValidCouponView(),
              ),
            ),

            // Sticky Bottom CTA Buttons
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: _isRedeemed
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Return to scanner
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.coral,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.qr_code_scanner_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Scan next',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName(AppRoutes.restaurantDashboard),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.line),
                              foregroundColor: AppColors.navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Done',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _onConfirmRedemption,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.coral,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Confirm redemption',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.line),
                              foregroundColor: AppColors.navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidCouponView() {
    return Column(
      children: [
        const SizedBox(height: 10),

        // Big Check Icon (.res__icon)
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F4EA),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF2E9E5B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Valid coupon',
          style: GoogleFonts.poppins(
            fontSize: 23,
            height: 30 / 23,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 16),

        // Guest Card (.cust)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECE5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.guestInitials,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.guestName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    'First visit with this coupon',
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

        const SizedBox(height: 14),

        // Details Card (.res__rows)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildDetailRow('Coupon', widget.couponTitle),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow('Minimum spend', widget.minSpend),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow('Valid', widget.validity),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow(
                'Points to award',
                widget.points,
                isHighlight: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Checklist Box (.check-list)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.peach,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3C7B6).withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Before you confirm',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              _buildCheckItem('The order meets the minimum spend'),
              const SizedBox(height: 6),
              _buildCheckItem('Dine-in only, drinks not included'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        const SizedBox(height: 18),

        // Green success badge
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F4EA),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF2E9E5B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Coupon redeemed',
          style: GoogleFonts.poppins(
            fontSize: 23,
            height: 30 / 23,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'The guest’s coupon is used and their points are added.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 19 / 13,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 20),

        // Result rows card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildDetailRow('Guest', widget.guestName),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow('Coupon', widget.couponTitle),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow('Time', '14 Oct 2026, 19:42'),
              const Divider(color: AppColors.line, height: 1),
              _buildDetailRow(
                'Points awarded',
                widget.points,
                isHighlight: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.text,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
              color: isHighlight ? AppColors.coral : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 16,
          color: AppColors.coral,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              height: 18 / 12.5,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}

