import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/restaurant_bottom_nav_bar.dart';

/// Data arguments passed to [RestaurantCouponDetailPage]
class RestaurantCouponDetailArgs {
  final String title;
  final String shortTitle;
  final String typeTag;
  final String discountVal;
  final String validity;
  final String minSpend;
  final String hours;
  final String frequency;
  final String points;
  final String viewsCount;
  final String viewsDelta;
  final String redemptionsCount;
  final String redemptionsDelta;
  final String redemptionRate;
  final String repeatGuests;
  final bool initialActive;

  const RestaurantCouponDetailArgs({
    this.title = '20% off your whole bill',
    this.shortTitle = '20% off your bill',
    this.typeTag = 'Percentage discount',
    this.discountVal = '20% OFF',
    this.validity = 'Active · 1 Oct – 31 Oct 2026',
    this.minSpend = 'Minimum spend 5,000 HUF',
    this.hours = 'Mon–Sun, 12:00–22:00',
    this.frequency = 'Once per customer',
    this.points = '+40 loyalty points',
    this.viewsCount = '3,480',
    this.viewsDelta = '+18%',
    this.redemptionsCount = '142',
    this.redemptionsDelta = '+9%',
    this.redemptionRate = '4.1%',
    this.repeatGuests = '38',
    this.initialActive = true,
  });
}

class RestaurantCouponDetailPage extends StatefulWidget {
  final RestaurantCouponDetailArgs args;

  const RestaurantCouponDetailPage({
    super.key,
    this.args = const RestaurantCouponDetailArgs(),
  });

  @override
  State<RestaurantCouponDetailPage> createState() =>
      _RestaurantCouponDetailPageState();
}

class _RestaurantCouponDetailPageState
    extends State<RestaurantCouponDetailPage> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.args.initialActive;
  }

  void _toggleActiveStatus() {
    setState(() {
      _isActive = !_isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isActive
              ? 'Coupon activated successfully'
              : 'Coupon deactivated successfully',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: _isActive ? const Color(0xFF1F7A45) : const Color(0xFFFE552E),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // Top Bar (.bar in coupon-detail.html)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  // Back button
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
                  const SizedBox(width: 8),
                  // Bar title
                  Expanded(
                    child: Center(
                      child: Text(
                        args.shortTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          height: 24 / 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Edit button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.restaurantCouponForm,
                      );
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
                          Icons.edit_outlined,
                          size: 19,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Card (.cd-card)
                    _buildHeroCard(args),

                    const SizedBox(height: 12),

                    // Stat Grid (.statgrid)
                    _buildStatGrid(args),

                    const SizedBox(height: 12),

                    // Rules Card (.sec-card)
                    _buildRulesCard(args),

                    const SizedBox(height: 18),

                    // Recent Redemptions Subhead (.subhead)
                    Text(
                      'Recent redemptions',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Recent Redemptions List (.feed)
                    _buildRecentRedemptionsFeed(),

                    const SizedBox(height: 16),

                    // Deactivate / Activate Button (.btn.btn--ghost)
                    _buildDeactivateButton(),

                    // Extra space at bottom to ensure clearance above gesture / navigation bar
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(RestaurantCouponDetailArgs args) {
    final cardBg = _isActive ? AppColors.coral : const Color(0xFFD9D2C6);
    final cardTextColor = _isActive ? Colors.white : AppColors.navy;
    final tagBg = _isActive
        ? Colors.white.withValues(alpha: 0.20)
        : AppColors.navy.withValues(alpha: 0.08);
    final perfLineColor = _isActive
        ? Colors.white.withValues(alpha: 0.45)
        : AppColors.navy.withValues(alpha: 0.20);
    final subtitleColor = _isActive
        ? Colors.white.withValues(alpha: 0.90)
        : AppColors.text;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pill tag (.cd-card__type)
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.percent_rounded,
                  size: 13,
                  color: cardTextColor,
                ),
                const SizedBox(width: 5),
                Text(
                  args.typeTag,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: cardTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Val (.cd-card__val)
          Text(
            args.discountVal,
            style: GoogleFonts.poppins(
              fontSize: 54,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.6,
              color: cardTextColor,
            ),
          ),
          const SizedBox(height: 16),

          // Perforated line with notch cutouts (.cd-card__perf)
          SizedBox(
            height: 24,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _DashedLinePainter(color: perfLineColor),
                  size: const Size(double.infinity, 2),
                ),
                // Left ticket punch notch
                Positioned(
                  left: -32,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Right ticket punch notch
                Positioned(
                  right: -32,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Title (.cd-card__title)
          Text(
            args.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              height: 1.33,
              fontWeight: FontWeight.w700,
              color: cardTextColor,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle / Rest (.cd-card__rest)
          Text(
            _isActive
                ? 'Active · 1 Oct – 31 Oct 2026'
                : 'Inactive · 1 Oct – 31 Oct 2026',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(RestaurantCouponDetailArgs args) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Views',
                value: args.viewsCount,
                deltaWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: Color(0xFF1F7A45),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      args.viewsDelta,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F7A45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                label: 'Redemptions',
                value: args.redemptionsCount,
                deltaWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: Color(0xFF1F7A45),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      args.redemptionsDelta,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F7A45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Redemption rate',
                value: args.redemptionRate,
                deltaWidget: Text(
                  'of views',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                label: 'Repeat guests',
                value: args.repeatGuests,
                deltaWidget: Text(
                  'used it twice+',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Widget deltaWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              height: 1.25,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 2),
          deltaWidget,
        ],
      ),
    );
  }

  Widget _buildRulesCard(RestaurantCouponDetailArgs args) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Head (.sec-card__head)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rules',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.restaurantCouponForm);
                },
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 1: Min spend
          _buildInfoRow(
            icon: const RestaurantTicketIcon(size: 18, color: AppColors.text),
            text: args.minSpend,
          ),
          const Divider(height: 14, thickness: 1, color: AppColors.line),

          // Row 2: Hours
          _buildInfoRow(
            icon: const Icon(Icons.access_time_rounded, size: 18, color: AppColors.text),
            text: args.hours,
          ),
          const Divider(height: 14, thickness: 1, color: AppColors.line),

          // Row 3: Frequency
          _buildInfoRow(
            icon: const Icon(Icons.person_outline_rounded, size: 18, color: AppColors.text),
            text: args.frequency,
          ),
          const Divider(height: 14, thickness: 1, color: AppColors.line),

          // Row 4: Loyalty points
          _buildInfoRow(
            icon: const Icon(Icons.military_tech_outlined, size: 18, color: AppColors.coral),
            text: args.points,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required Widget icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRedemptionsFeed() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          _buildFeedItem(
            initials: 'AK',
            name: 'Anna K.',
            time: 'Today, 19:42',
            points: '+40 pts',
            avatarBg: const Color(0xFFFFE8E0),
            avatarTextColor: const Color(0xFFFE552E),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          _buildFeedItem(
            initials: 'ZS',
            name: 'Zsófia B.',
            time: 'Today, 13:05',
            points: '+40 pts',
            avatarBg: const Color(0xFFE9E3D8),
            avatarTextColor: const Color(0xFF3F3F46),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          _buildFeedItem(
            initials: 'DM',
            name: 'Dávid M.',
            time: 'Yesterday, 20:31',
            points: '+40 pts',
            avatarBg: const Color(0xFF18181B),
            avatarTextColor: Colors.white,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem({
    required String initials,
    required String name,
    required String time,
    required String points,
    required Color avatarBg,
    required Color avatarTextColor,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: avatarTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeactivateButton() {
    final color = _isActive ? const Color(0xFFFE552E) : const Color(0xFF1F7A45);
    final icon = _isActive ? Icons.pause_rounded : Icons.play_arrow_rounded;
    final label = _isActive ? 'Deactivate coupon' : 'Activate coupon';

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _toggleActiveStatus,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
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
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}



