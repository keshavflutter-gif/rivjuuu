import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final String daySection;
  final bool isNew;
  final IconData? icon;
  final Color? iconBg;
  final Color? iconColor;
  final String? imagePath;
  final String? avatarInitials;
  final Color? avatarBg;
  final Color? avatarColor;
  final String routeName;
  final dynamic routeArgs;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.daySection,
    this.isNew = false,
    this.icon,
    this.iconBg,
    this.iconColor,
    this.imagePath,
    this.avatarInitials,
    this.avatarBg,
    this.avatarColor,
    required this.routeName,
    this.routeArgs,
  });

  NotificationItemModel copyWith({bool? isNew}) {
    return NotificationItemModel(
      id: id,
      title: title,
      body: body,
      time: time,
      daySection: daySection,
      isNew: isNew ?? this.isNew,
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      imagePath: imagePath,
      avatarInitials: avatarInitials,
      avatarBg: avatarBg,
      avatarColor: avatarColor,
      routeName: routeName,
      routeArgs: routeArgs,
    );
  }
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late List<NotificationItemModel> _notifications;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _notifications = [
      const NotificationItemModel(
        id: '1',
        title: 'You won a giveaway',
        body:
            'Pizza night for four at Pizzeria Forno. Your prize coupon is ready.',
        time: '2 h ago',
        daySection: 'Today',
        isNew: true,
        icon: LucideIcons.trophy,
        iconBg: AppColors.coral,
        iconColor: Colors.white,
        routeName: AppRoutes.myGiveaways,
        routeArgs: 1, // Won tab
      ),
      const NotificationItemModel(
        id: '2',
        title: 'Péter Nagy sent you a friend request',
        body: '4 mutual friends',
        time: '3 h ago',
        daySection: 'Today',
        isNew: true,
        avatarInitials: 'PN',
        avatarBg: Color(0xFFFDF0D9),
        avatarColor: Color(0xFF7A4A00),
        routeName: AppRoutes.friends,
        routeArgs: 1, // Requests tab
      ),
      const NotificationItemModel(
        id: '3',
        title: '+40 points at Trattoria Nonna Rosa',
        body: 'You’re 80 points away from a free dessert.',
        time: 'Yesterday, 19:43',
        daySection: 'Today',
        isNew: false,
        icon: LucideIcons.award,
        iconBg: Color(0xFFF1ECE1),
        iconColor: AppColors.coral,
        routeName: AppRoutes.loyaltyDetail,
      ),
      const NotificationItemModel(
        id: '4',
        title: 'New coupon at Café Mókus',
        body: 'Free dessert with any main, until 31 Oct.',
        time: 'Mon',
        daySection: 'This week',
        isNew: false,
        imagePath: AppAssets.coffee,
        routeName: AppRoutes.favoriteCoupons,
      ),
      const NotificationItemModel(
        id: '5',
        title: 'How was Bamba Burger Bar?',
        body: 'Rate your visit and add photos.',
        time: 'Sun',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.pencil,
        iconBg: Color(0xFFF1ECE1),
        iconColor: AppColors.navy,
        routeName: AppRoutes.reviewDetail,
      ),
      const NotificationItemModel(
        id: '6',
        title: 'Your password was changed',
        body: 'If this wasn’t you, contact support.',
        time: 'Sat',
        daySection: 'This week',
        isNew: false,
        icon: LucideIcons.lock,
        iconBg: Color(0xFFF1ECE1),
        iconColor: AppColors.navy,
        routeName: AppRoutes.settings,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    HapticFeedback.lightImpact();
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isNew: false)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.navy,
      ),
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar (.bar from notifications.html)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
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
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _markAllRead,
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coral,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content List (.scroll)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todayList.isNotEmpty) ...[
                      _buildDayHeader('TODAY'),
                      ...todayList.map(_buildNotificationTile),
                    ],
                    if (weekList.isNotEmpty) ...[
                      _buildDayHeader('THIS WEEK'),
                      ...weekList.map(_buildNotificationTile),
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

  Widget _buildDayHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.72,
          color: const Color(0xFF71717A),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItemModel item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          final idx = _notifications.indexWhere((n) => n.id == item.id);
          if (idx != -1) {
            _notifications[idx] = item.copyWith(isNew: false);
          }
        });
        Navigator.of(context).pushNamed(
          item.routeName,
          arguments: item.routeArgs,
        );
      },
      child: Container(
        color: item.isNew ? const Color(0xFFFFF3EE) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon or Avatar (.nt__icon)
            if (item.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  item.imagePath!,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              )
            else if (item.avatarInitials != null)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.avatarBg ?? const Color(0xFFFDF0D9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.avatarInitials!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: item.avatarColor ?? const Color(0xFF7A4A00),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBg ?? const Color(0xFFF1ECE1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.iconColor ?? AppColors.navy,
                  ),
                ),
              ),
            const SizedBox(width: 12),

            // Content Body (.nt__body)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    item.body,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: const Color(0xFF71717A),
                      height: 1.44,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.time,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: const Color(0xFF8B8B93),
                    ),
                  ),
                ],
              ),
            ),

            // Unread Dot (.nt__dot)
            if (item.isNew)
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: 6, left: 8),
                decoration: const BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
