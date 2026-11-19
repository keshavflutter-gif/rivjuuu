import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/restaurant_bottom_nav_bar.dart';
import '../../restaurant_coupons/view/restaurant_coupons_page.dart';
import '../../restaurant_profile/view/restaurant_account_page.dart';
import '../../restaurant_registration/models/restaurant_registration_data.dart';
import '../../restaurant_scanner/view/restaurant_scanner_page.dart';
import 'restaurant_activity_content_view.dart';

class RestaurantDashboardPage extends StatefulWidget {
  final RestaurantRegistrationData? data;
  final int initialTab;

  const RestaurantDashboardPage({super.key, this.data, this.initialTab = 0});

  @override
  State<RestaurantDashboardPage> createState() =>
      _RestaurantDashboardPageState();
}

class _RestaurantDashboardPageState extends State<RestaurantDashboardPage> {
  late int _currentNavIndex;
  late final ScrollController _scrollController;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.initialTab;
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant RestaurantDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentNavIndex = widget.initialTab;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBackPress() {
    if (_currentNavIndex != 0) {
      setState(() => _currentNavIndex = 0);
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            context.l10n.tapAgainToExit,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SystemNavigator.pop();
    }
  }

  String _formatInitials(String name) {
    if (name.trim().isEmpty) return 'NR';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    if (parts.length >= 3 && parts[0].toLowerCase() == 'trattoria') {
      return '${parts[1][0]}${parts[2][0]}'.toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data ?? RestaurantRegistrationData();
    final restaurantName = d.restaurantName.trim().isEmpty
        ? 'Trattoria Nonna Rosa'
        : d.restaurantName;
    final initials = _formatInitials(restaurantName);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentNavIndex,
            children: [
              _buildDashboardContent(restaurantName, initials),
              const RestaurantCouponsContentView(),
              _buildScanPlaceholder(),
              const RestaurantActivityContentView(),
              RestaurantAccountContentView(
                data: widget.data,
                onSelectTab: (idx) {
                  setState(() => _currentNavIndex = idx);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: RestaurantBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.pushNamed(context, AppRoutes.restaurantScanner);
            } else {
              setState(() => _currentNavIndex = index);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(String restaurantName, String initials) {
    return Column(
      children: [
        // Dashboard Header (.dhead)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E4A3A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.goodEvening,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.33,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      restaurantName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        height: 1.33,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Bell button with indicator dot (.round .dot)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(
                      context, AppRoutes.restaurantNotifications);
                },
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.bell,
                            size: 19,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero KPI: Redemptions today (.kpi.kpi--hero)
                _buildHeroKpiCard(),

                const SizedBox(height: 10),

                // 2x2 Grid KPIs (.kpis)
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        iconWidget: const RestaurantTicketIcon(
                          size: 16,
                          color: AppColors.coral,
                        ),
                        label: context.l10n.activeCoupons,
                        value: '4',
                        sub: context.l10n.oneEndsThisWeek,
                        onTap: () {
                          setState(() => _currentNavIndex = 1);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.restaurantLoyalty,
                          );
                        },
                        child: _buildKpiCard(
                          iconWidget: const RestaurantAwardIcon(
                            size: 16,
                            color: AppColors.coral,
                          ),
                          label: context.l10n.pointsGiven,
                          value: '720',
                          sub: context.l10n.thisWeek,
                          isUp: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.restaurantGiveaways,
                          );
                        },
                        child: _buildKpiCard(
                          iconWidget: const RestaurantGiftIcon(
                            size: 16,
                            color: AppColors.coral,
                          ),
                          label: context.l10n.giveawayEntries,
                          value: '1,248',
                          sub: context.l10n.drawOnDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.restaurantStatistics,
                          );
                        },
                        child: _buildKpiCard(
                          iconWidget: const RestaurantEyeIcon(
                            size: 16,
                            color: AppColors.coral,
                          ),
                          label: context.l10n.profileViews,
                          value: '2,310',
                          sub: '+12% this week',
                          isUp: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // Quick Actions Section (.sec)
                Text(
                  context.l10n.quickActions,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    height: 1.33,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.18,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          iconWidget: const RestaurantScanIcon(
                            size: 20,
                            color: Colors.white,
                          ),
                          label: context.l10n.scanQr,
                          isMain: true,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.restaurantScanner,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickAction(
                          iconWidget: const Icon(
                            LucideIcons.plus,
                            size: 20,
                            color: AppColors.coral,
                          ),
                          label: context.l10n.createCoupon,
                          isMain: false,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.restaurantCouponForm,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickAction(
                          iconWidget: const RestaurantGiftIcon(
                            size: 20,
                            color: AppColors.coral,
                          ),
                          label: context.l10n.createGiveaway,
                          isMain: false,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.restaurantGiveawayForm,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // Recent Activity Section (.sec)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.recentActivity,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          height: 1.33,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.18,
                          color: AppColors.navy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _currentNavIndex = 3);
                      },
                      child: Text(
                        context.l10n.seeAll,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRecentActivityList(),

                const SizedBox(height: 24),

                // Subscription Status Card (.subcard)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.restaurantSubscription,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const RestaurantAwardIcon(
                          size: 24,
                          color: Color(0xFFFE552E),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.growthPlan,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  height: 1.38,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                context.l10n.planRenewsText,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  height: 1.39,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          context.l10n.manage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.coral,
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
      ],
    );
  }

  Widget _buildScanPlaceholder() {
    return const RestaurantScannerView(isEmbedded: true, animate: false);
  }

  Widget _buildRecentActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          _buildActivityItem(
            avatar: 'AK',
            avatarBg: const Color(0xFFFFE8E0),
            avatarTextColor: const Color(0xFFFE552E),
            title: 'Anna K. redeemed 20%\noff',
            subtitle: '19:42 · +40 points',
            trailing: Container(
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F7A45),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.redeemed,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F7A45),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          _buildActivityItem(
            avatar: 'BT',
            avatarBg: const Color(0xFFFDF0D9),
            avatarTextColor: const Color(0xFF7A4A00),
            title: 'Bence T. used Free espresso',
            subtitle: '18:15 · −150 points',
            trailing: Text(
              context.l10n.reward,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          _buildActivityItem(
            iconWidget: const RestaurantGiftIcon(
              size: 18,
              color: AppColors.navy,
            ),
            title: '36 new giveaway entries',
            subtitle: 'Win dinner for two · today',
            trailing: Text(
              '+36',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroKpiCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RestaurantScanIcon(
                      size: 16,
                      color: Color(0xB8FFFFFF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.redemptionsToday,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.33,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xB8FFFFFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '18',
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    height: 1.18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.68,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+5 vs. last Tuesday',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    height: 1.39,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xB8FFFFFF),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.restaurantScanner);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.l10n.scanQr,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required Widget iconWidget,
    required String label,
    required String value,
    required String sub,
    bool isUp = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Row(
              children: [
                iconWidget,
                const SizedBox(width: 6),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.33,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 26,
                height: 1.23,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                letterSpacing: -0.52,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                sub,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  height: 1.39,
                  fontWeight: isUp ? FontWeight.w600 : FontWeight.w400,
                  color: isUp ? const Color(0xFF1F7A45) : AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required Widget iconWidget,
    required String label,
    required bool isMain,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isMain ? AppColors.coral : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isMain ? AppColors.coral : AppColors.line),
        ),
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isMain
                    ? Colors.white.withValues(alpha: 0.20)
                    : AppColors.coralSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 38),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.25,
                      fontWeight: isMain ? FontWeight.w600 : FontWeight.w500,
                      color: isMain ? Colors.white : AppColors.navy,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    String? avatar,
    Color? avatarBg,
    Color? avatarTextColor,
    Widget? iconWidget,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: avatarBg ?? AppColors.cream,
              borderRadius: BorderRadius.circular(avatar != null ? 19 : 12),
            ),
            child: Center(
              child: avatar != null
                  ? Text(
                      avatar,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: avatarTextColor ?? AppColors.navy,
                      ),
                    )
                  : iconWidget,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.38,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    height: 1.39,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
