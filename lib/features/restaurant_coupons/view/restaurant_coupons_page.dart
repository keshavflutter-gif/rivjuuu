import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/restaurant_bottom_nav_bar.dart';
import '../../restaurant_dashboard/view/restaurant_dashboard_page.dart';
import 'restaurant_coupon_detail_page.dart';

class RestaurantCouponsPage extends StatelessWidget {
  final int initialTab;

  const RestaurantCouponsPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return RestaurantDashboardPage(initialTab: 1);
  }
}

class RestaurantCouponsContentView extends StatefulWidget {
  final int initialTab;

  const RestaurantCouponsContentView({super.key, this.initialTab = 0});

  @override
  State<RestaurantCouponsContentView> createState() => _RestaurantCouponsContentViewState();
}

class _RestaurantCouponsContentViewState extends State<RestaurantCouponsContentView> {
  late int _selectedTab;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            // Top Bar (.bar)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.navCoupons,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      height: 1.36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.restaurantCouponForm);
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: Text(
                        context.l10n.createCoupon,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs (.tabs)
            Container(
              decoration: const BoxDecoration(
                color: AppColors.cream,
                border: Border(bottom: BorderSide(color: AppColors.line)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildTab(0, context.l10n.activeCouponsTab),
                    const SizedBox(width: 22),
                    _buildTab(1, context.l10n.scheduledCouponsTab),
                    const SizedBox(width: 22),
                    _buildTab(2, context.l10n.expiredCouponsTab),
                  ],
                ),
              ),
            ),

            // Scrollable Content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                child: _buildTabContent(),
              ),
            ),
          ],
        );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
      },
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.coral,
                    width: 3,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.navy : const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildActiveCouponsList();
      case 1:
        return _buildScheduledCouponsList();
      case 2:
        return _buildExpiredCouponsList();
      default:
        return _buildActiveCouponsList();
    }
  }

  Widget _buildActiveCouponsList() {
    return Column(
      children: [
        _buildCouponCard(
          valWidget: Text(
            '20%',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          valBg: AppColors.coral,
          category: 'Percentage discount',
          title: '20% off your whole bill',
          desc: '1 Oct – 31 Oct · Min. 5,000 HUF',
          status: 'Active',
          statusType: _CouponStatusType.active,
          redeemedCount: '142',
          ptsText: '+40 pts each',
        ),
        const SizedBox(height: 10),
        _buildCouponCard(
          valWidget: const RestaurantGiftIcon(size: 24, color: Colors.white),
          valBg: AppColors.coral,
          category: 'Gift item',
          title: 'Free tiramisu with any main',
          desc: 'Until 31 Oct · One per table',
          status: 'Active',
          statusType: _CouponStatusType.active,
          redeemedCount: '88',
          ptsText: '+25 pts each',
        ),
        const SizedBox(height: 10),
        _buildCouponCard(
          valWidget: Text(
            '1+1',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          valBg: AppColors.coral,
          category: 'Buy one, get one',
          title: 'Second Margherita free',
          desc: 'Weekends · Sat–Sun',
          status: 'Active',
          statusType: _CouponStatusType.active,
          redeemedCount: '51',
          ptsText: '+20 pts each',
        ),
        const SizedBox(height: 10),
        _buildCouponCard(
          valWidget: const Icon(
            Icons.access_time_rounded,
            size: 24,
            color: Colors.white,
          ),
          valBg: AppColors.navy,
          category: 'Happy hour',
          title: 'Aperol spritz for 1,500 HUF',
          desc: 'Mon–Fri, 16:00–18:00',
          status: 'Active',
          statusType: _CouponStatusType.active,
          redeemedCount: '36',
          ptsText: '+10 pts each',
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 20),
          child: Text(
            '4 of 10 active coupons on your Growth plan',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledCouponsList() {
    return Column(
      children: [
        _buildCouponCard(
          valWidget: Text(
            '10%',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          valBg: AppColors.coral,
          category: 'Halloween special',
          title: 'Spooky cocktail & dessert combo',
          desc: 'Starts 28 Oct · 4 days left',
          status: 'Scheduled',
          statusType: _CouponStatusType.scheduled,
          redeemedCount: '0',
          ptsText: '+50 pts each',
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 20),
          child: Text(
            'Scheduled coupons will automatically activate on their start date.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiredCouponsList() {
    return Column(
      children: [
        _buildCouponCard(
          valWidget: Text(
            '15%',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF71717A),
            ),
          ),
          valBg: const Color(0xFFE9E3D8),
          category: 'Seasonal',
          title: 'Truffle week',
          desc: 'Ended 30 Sep 2026',
          status: 'Expired',
          statusType: _CouponStatusType.expired,
          redeemedCount: '64',
          actionText: 'Reuse',
          onActionTap: () {},
        ),
        const SizedBox(height: 10),
        _buildCouponCard(
          valWidget: const Icon(
            Icons.lock_outline_rounded,
            size: 22,
            color: Color(0xFF71717A),
          ),
          valBg: const Color(0xFFE9E3D8),
          category: 'Secret menu',
          title: 'Nonna’s off-menu lasagne',
          desc: 'Deactivated 12 Sep 2026',
          status: 'Inactive',
          statusType: _CouponStatusType.inactive,
          redeemedCount: '19',
          actionText: 'Activate',
          onActionTap: () {},
        ),
      ],
    );
  }

  Widget _buildCouponCard({
    required Widget valWidget,
    required Color valBg,
    required String category,
    required String title,
    required String desc,
    required String status,
    required _CouponStatusType statusType,
    required String redeemedCount,
    String? ptsText,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.restaurantCouponDetail,
          arguments: RestaurantCouponDetailArgs(
            title: title,
            shortTitle: (title.trim() == '20% off your whole bill' ||
                    title.toLowerCase() == '20% off your whole bill')
                ? '20% off your bill'
                : (title.length > 25 ? '${title.substring(0, 24)}...' : title),
            typeTag: category.toLowerCase().contains('percent')
                ? 'Percentage discount'
                : category,
            discountVal: category.toLowerCase().contains('percent')
                ? '20% OFF'
                : (title.toLowerCase().contains('free') ? 'FREE' : '1+1'),
            validity: '$status · $desc',
            minSpend: 'Minimum spend 5,000 HUF',
            hours: 'Mon–Sun, 12:00–22:00',
            frequency: 'Once per customer',
            points: ptsText != null ? '$ptsText loyalty points' : '+40 loyalty points',
            viewsCount: '3,480',
            viewsDelta: '+18%',
            redemptionsCount: redeemedCount,
            redemptionsDelta: '+9%',
            redemptionRate: '4.1%',
            repeatGuests: '38',
            initialActive: statusType == _CouponStatusType.active,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row (.mc__top)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: valBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: valWidget),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        height: 1.36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.55,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        height: 1.38,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.42,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusPill(status, statusType),
            ],
          ),

          const SizedBox(height: 10),

          // Bottom stats row (.mc__stats)
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                    children: [
                      TextSpan(
                        text: redeemedCount,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontSize: 13,
                        ),
                      ),
                      const TextSpan(text: ' redeemed'),
                    ],
                  ),
                ),
                if (ptsText != null) ...[
                  const SizedBox(width: 16),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.text,
                      ),
                      children: [
                        TextSpan(
                          text: ptsText.split(' ').first,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: ' ${ptsText.split(' ').skip(1).join(' ')}',
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                if (actionText != null)
                  GestureDetector(
                    onTap: onActionTap,
                    child: Text(
                      actionText,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.coral,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.navy,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildStatusPill(String status, _CouponStatusType type) {
    Color bg;
    Color fg;

    switch (type) {
      case _CouponStatusType.active:
        bg = const Color(0xFFE6F4EA);
        fg = const Color(0xFF1F7A45);
        break;
      case _CouponStatusType.scheduled:
        bg = const Color(0xFFFDF0D9);
        fg = const Color(0xFF8A5300);
        break;
      case _CouponStatusType.expired:
      case _CouponStatusType.inactive:
        bg = const Color(0xFFF1ECE2);
        fg = const Color(0xFF52525B);
        break;
    }

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

enum _CouponStatusType {
  active,
  scheduled,
  expired,
  inactive,
}

