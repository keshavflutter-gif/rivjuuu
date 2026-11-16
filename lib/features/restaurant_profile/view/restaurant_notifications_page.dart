import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class RestaurantNotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final String daySection;
  final bool isNew;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? routeName;
  final dynamic routeArgs;

  const RestaurantNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.daySection,
    this.isNew = false,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.routeName,
    this.routeArgs,
  });

  RestaurantNotificationItem copyWith({bool? isNew}) {
    return RestaurantNotificationItem(
      id: id,
      title: title,
      body: body,
      time: time,
      daySection: daySection,
      isNew: isNew ?? this.isNew,
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      routeName: routeName,
      routeArgs: routeArgs,
    );
  }
}

/// Restaurant Side Notifications Page matching batch-05-restaurant-app/html/notifications.html
class RestaurantNotificationsPage extends StatefulWidget {
  const RestaurantNotificationsPage({super.key});

  @override
  State<RestaurantNotificationsPage> createState() =>
      _RestaurantNotificationsPageState();
}

class _RestaurantNotificationsPageState
    extends State<RestaurantNotificationsPage> {
  late final ScrollController _scrollController;
  late List<RestaurantNotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _notifications = [
      // TODAY
      const RestaurantNotificationItem(
        id: '1',
        title: '18 coupons redeemed today',
        body: 'Your busiest Tuesday this month.',
        time: '21:00',
        daySection: 'Today',
        isNew: true,
        icon: LucideIcons.scan,
        iconBg: Color(0xFFFE552E),
        iconColor: Colors.white,
        routeName: AppRoutes.restaurantDashboard,
        routeArgs: 3, // Activity tab
      ),
      const RestaurantNotificationItem(
        id: '2',
        title: 'Giveaway ends tomorrow',
        body: 'Win dinner for two has 1,248 entries. Draw winners after 14 Oct.',
        time: '10:00',
        daySection: 'Today',
        isNew: true,
        icon: LucideIcons.gift,
        iconBg: AppColors.cream,
        iconColor: Color(0xFFFE552E),
        routeName: AppRoutes.restaurantGiveaways,
      ),

      // THIS WEEK
      const RestaurantNotificationItem(
        id: '3',
        title: 'Reward redeemed',
        body: 'Bence T. used Free espresso (150 points).',
        time: 'Mon',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.award,
        iconBg: AppColors.cream,
        iconColor: AppColors.navy,
        routeName: AppRoutes.restaurantLoyalty,
      ),
      const RestaurantNotificationItem(
        id: '4',
        title: 'Subscription renewed',
        body: 'Growth plan renewed until 14 Nov 2026.',
        time: 'Mon',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.creditCard,
        iconBg: Color(0xFFFDF0D9),
        iconColor: Color(0xFFFE552E),
        routeName: AppRoutes.restaurantSubscription,
      ),
      const RestaurantNotificationItem(
        id: '5',
        title: 'Coupon ends soon',
        body: '20% off your whole bill ends on 31 Oct.',
        time: 'Sun',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.ticket,
        iconBg: AppColors.cream,
        iconColor: AppColors.navy,
        routeName: AppRoutes.restaurantCoupons,
      ),
      const RestaurantNotificationItem(
        id: '6',
        title: 'Your restaurant is approved',
        body: 'Welcome to Rivjuuu, Trattoria Nonna Rosa.',
        time: '1 Oct',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.checkCircle,
        iconBg: Color(0xFFE6F4EA),
        iconColor: Color(0xFF1F7A45),
        routeName: AppRoutes.restaurantProfileManage,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _markAllAsRead() {
    HapticFeedback.lightImpact();
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isNew: false)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications marked as read',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNotificationTap(RestaurantNotificationItem item) {
    HapticFeedback.lightImpact();
    if (item.isNew) {
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == item.id);
        if (index != -1) {
          _notifications[index] = item.copyWith(isNew: false);
        }
      });
    }

    if (item.routeName != null) {
      if (item.routeName == AppRoutes.restaurantDashboard &&
          item.routeArgs != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.restaurantDashboard,
          (route) => false,
          arguments: item.routeArgs,
        );
      } else {
        Navigator.pushNamed(context, item.routeName!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayList =
        _notifications.where((n) => n.daySection == 'Today').toList();
    final weekList =
        _notifications.where((n) => n.daySection == 'This week').toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (.bar, style="padding-top: 4px")
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  // Back button (.round)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
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
                          LucideIcons.arrowLeft,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),

                  // Title (.bar__title)
                  Expanded(
                    child: Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),

                  // "Mark all read" Action (.link)
                  GestureDetector(
                    onTap: _markAllAsRead,
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFE552E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Notifications List
            Expanded(
              child: SingleChildScrollView(
                key: const PageStorageKey<String>(
                    'restaurant_notifications_scroll_view'),
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: TODAY
                    if (todayList.isNotEmpty) ...[
                      _buildSectionHeader('TODAY'),
                      ...todayList.map(_buildNotificationRow),
                    ],

                    // Section 2: THIS WEEK
                    if (weekList.isNotEmpty) ...[
                      _buildSectionHeader('THIS WEEK'),
                      ...weekList.map(_buildNotificationRow),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildNotificationRow(RestaurantNotificationItem item) {
    final isNew = item.isNew;

    return InkWell(
      onTap: () => _handleNotificationTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isNew ? const Color(0xFFFFF3EE) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon (.nt__icon)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  size: 20,
                  color: item.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Body (.nt__body)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (b)
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Description (span)
                  Text(
                    item.body,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Time (small)
                  Text(
                    item.time,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8B8B93),
                    ),
                  ),
                ],
              ),
            ),

            // New Dot (.nt__dot)
            if (isNew) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFE552E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

