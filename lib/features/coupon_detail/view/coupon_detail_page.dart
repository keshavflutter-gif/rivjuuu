import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../restaurant_detail/models/restaurant_detail_models.dart';

class CouponDetailPage extends StatefulWidget {
  final String title;
  final String discountVal;
  final String typeName;
  final IconData? typeIcon;
  final String restaurantName;
  final String distance;
  final String logoText;
  final bool isAvailable;
  final String statusText;
  final String unavailableReason;
  final String unavailableSubtext;
  final String infoDescription;
  final String requirement;
  final String validDateText;
  final String hoursText;
  final String pointsText;
  final List<String> terms;
  final String hintText;

  const CouponDetailPage({
    super.key,
    this.title = '20% off your whole bill',
    this.discountVal = '20% OFF',
    this.typeName = 'Percentage discount',
    this.typeIcon,
    this.restaurantName = 'Trattoria Nonna Rosa',
    this.distance = '1.2 km',
    this.logoText = 'NR',
    this.isAvailable = true,
    this.statusText = 'Available',
    this.unavailableReason = 'Available from 12:00',
    this.unavailableSubtext = 'This coupon can be redeemed Mon–Sun, 12:00–22:00.',
    this.infoDescription = 'Get 20% off the food on your bill when you dine in.',
    this.requirement = 'Minimum spend 5,000 HUF',
    this.validDateText = 'Valid 1 Oct – 31 Oct 2026',
    this.hoursText = 'Available Mon–Sun, 12:00–22:00',
    this.pointsText = 'Earn 40 loyalty points',
    this.terms = const [
      'Dine-in only.',
      'Cannot be combined with other coupons or rewards.',
      'Drinks are not included in the discount.',
      'The restaurant may decline the coupon if the conditions are not met.',
    ],
    this.hintText =
        'Restaurant staff will check that your purchase meets the coupon conditions before scanning your QR code.',
  });

  factory CouponDetailPage.fromCoupon(
    CouponModel coupon, {
    String restaurantName = 'Trattoria Nonna Rosa',
    String distance = '1.2 km',
    String logoText = 'NR',
  }) {
    final bool available =
        coupon.statusType == CouponStatusType.available && !coupon.isPast;

    String formattedVal = coupon.discountVal.trim();
    if (coupon.discountSmall.isNotEmpty &&
        !formattedVal
            .toLowerCase()
            .contains(coupon.discountSmall.toLowerCase())) {
      formattedVal = '$formattedVal ${coupon.discountSmall}'.toUpperCase();
    } else {
      formattedVal = formattedVal.toUpperCase();
    }

    IconData? tIcon;
    if (coupon.icon != null) {
      tIcon = coupon.icon;
    } else if (coupon.discountVal.contains('%')) {
      tIcon = Icons.percent_rounded;
    } else {
      tIcon = Icons.local_offer_outlined;
    }

    String typeLabel = coupon.type;
    if (coupon.discountVal.contains('%') &&
        (typeLabel.isEmpty || typeLabel.toLowerCase() == 'discount')) {
      typeLabel = 'Percentage discount';
    }

    String unavailReason = coupon.statusText;
    if (unavailReason.isEmpty || unavailReason.toLowerCase() == 'wait') {
      unavailReason = 'Available from 12:00';
    }

    String unavailSub = coupon.isPast
        ? 'This coupon ended on ${coupon.requirement}.'
        : 'This coupon can be redeemed Mon–Sun, 12:00–22:00.';

    String statusLabel;
    if (available) {
      statusLabel = 'Available';
    } else if (coupon.statusType == CouponStatusType.wait) {
      statusLabel = 'Not available right now';
    } else {
      statusLabel = coupon.statusText;
    }

    return CouponDetailPage(
      title: coupon.title,
      discountVal: formattedVal,
      typeName: typeLabel,
      typeIcon: tIcon,
      restaurantName: restaurantName,
      distance: distance,
      logoText: logoText,
      isAvailable: available,
      statusText: statusLabel,
      unavailableReason: unavailReason,
      unavailableSubtext: unavailSub,
      requirement: coupon.requirement,
      validDateText: coupon.meta != null && coupon.meta!.isNotEmpty
          ? coupon.meta!
          : 'Valid 1 Oct – 31 Oct 2026',
    );
  }

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  void _onRedeem() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushNamed(
      AppRoutes.couponQr,
      arguments: {
        'restaurant': widget.restaurantName,
        'discount': widget.discountVal,
        'title': widget.title,
        'openRedemptionSuccess': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Top Bar (.bar in coupon.html / coupon-unavailable.html)
              _buildTopBar(context),

              // 2. Scrollable Body (.scroll)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Big Coupon Ticket Card (.cd-card / .cd-card--muted)
                      _buildBigCouponCard(),

                      const SizedBox(height: 14),

                      // Status Row
                      _buildStatusRow(),

                      const SizedBox(height: 14),

                      // Info List Card (.cd-list)
                      _buildInfoListCard(),

                      const SizedBox(height: 18),

                      // Terms and Conditions (.subhead + .terms)
                      Text(
                        'Terms and conditions',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.terms
                              .map((term) => _buildBulletItem(term))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Hint Box (.hint)
                      _buildHintBox(),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // 3. Sticky Bottom CTA (.stickycta)
              _buildStickyCta(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular Back Button
          _buildCircleButton(
            icon: Icons.arrow_back_rounded,
            iconColor: AppColors.navy,
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),

          // Title
          Text(
            'Coupon',
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),

          // Circular Share Button
          _buildCircleButton(
            icon: Icons.ios_share_rounded,
            iconColor: AppColors.navy,
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sharing coupon link...',
                    style: GoogleFonts.poppins(),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.line),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigCouponCard() {
    final bool isAvailable = widget.isAvailable;
    final Color cardBg =
        isAvailable ? AppColors.coral : const Color(0xFFD9D2C6);
    final Color textColor = isAvailable ? Colors.white : AppColors.navy;
    final Color typeBg = isAvailable
        ? Colors.white.withValues(alpha: 0.2)
        : const Color(0x1418181B); // rgba(24, 24, 27, .08)
    final Color typeColor = isAvailable ? Colors.white : AppColors.navy;
    final Color perfColor = isAvailable
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0x3318181B); // rgba(24, 24, 27, .2)
    final Color logoBg =
        isAvailable ? Colors.white : const Color(0xFF2E4A3A);
    final Color logoTextColor =
        isAvailable ? const Color(0xFF2E4A3A) : Colors.white;
    final Color restTextColor =
        isAvailable ? Colors.white.withValues(alpha: 0.9) : AppColors.text;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Badge (.cd-card__type)
                Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: typeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.typeIcon ?? Icons.percent_rounded,
                        size: 13,
                        color: typeColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.typeName,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Discount Value (.cd-card__val: font-size 54px, line-height 56px, weight 800)
                Text(
                  widget.discountVal,
                  style: GoogleFonts.poppins(
                    fontSize: 54,
                    height: 56 / 54,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -1.6,
                  ),
                ),
                const SizedBox(height: 16),

                // Perforated Dashed Line (.cd-card__perf)
                CustomPaint(
                  size: const Size(double.infinity, 2),
                  painter: _HorizontalDashedLinePainter(color: perfColor),
                ),
                const SizedBox(height: 16),

                // Title (.cd-card__title: 18px, line-height 24px, 700)
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    height: 24 / 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Restaurant & Distance (.cd-card__rest)
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: logoBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.logoText,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: logoTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.restaurantName} · ${widget.distance}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: restTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Left Semicircular Notch (.cd-card::before)
          Positioned(
            left: -12,
            top: 124,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cream,
              ),
            ),
          ),

          // Right Semicircular Notch (.cd-card::after)
          Positioned(
            right: -12,
            top: 124,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cream,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    final bool isAvailable = widget.isAvailable;
    final Color badgeBg =
        isAvailable ? const Color(0xFFE6F4EA) : const Color(0xFFFDF0D9);
    final Color badgeColor =
        isAvailable ? const Color(0xFF1F7A45) : const Color(0xFF8A5300);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status Badge
        Flexible(
          flex: 2,
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: badgeBg,
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
                    color: badgeColor,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.statusText,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Dine-in · Restaurant
        Flexible(
          flex: 3,
          child: Text(
            'Dine-in · ${widget.restaurantName}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.text,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoListCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.info_outline_rounded,
            title: widget.infoDescription,
          ),
          const Divider(color: AppColors.line, height: 1),
          _buildInfoRow(
            icon: Icons.confirmation_number_outlined,
            title: widget.requirement,
            subtitle: 'Checked by restaurant staff',
          ),
          const Divider(color: AppColors.line, height: 1),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: widget.validDateText,
          ),
          const Divider(color: AppColors.line, height: 1),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            title: widget.hoursText,
          ),
          const Divider(color: AppColors.line, height: 1),
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            title: 'Once per customer',
          ),
          const Divider(color: AppColors.line, height: 1),
          _buildInfoRow(
            icon: Icons.emoji_events_outlined,
            iconColor: AppColors.coral,
            title: widget.pointsText,
            subtitle: 'Points can only be used at ${widget.restaurantName}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? AppColors.text,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.text,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.text,
                height: 19 / 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0D9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Color(0xFFB06B00),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.hintText,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.navy,
                height: 18 / 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCta(BuildContext context) {
    final bool isAvailable = widget.isAvailable;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isAvailable ? AppColors.coral : const Color(0xFFE9E3D8),
                foregroundColor:
                    isAvailable ? Colors.white : const Color(0xFF71717A),
                disabledBackgroundColor: const Color(0xFFE9E3D8),
                disabledForegroundColor: const Color(0xFF71717A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: isAvailable ? _onRedeem : null,
              child: Text(
                isAvailable ? 'Redeem coupon' : widget.unavailableReason,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (!isAvailable) ...[
            const SizedBox(height: 6),
            Text(
              widget.unavailableSubtext,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: AppColors.text,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HorizontalDashedLinePainter extends CustomPainter {
  final Color color;

  _HorizontalDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalDashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
