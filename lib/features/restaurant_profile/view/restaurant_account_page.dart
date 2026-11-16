import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../restaurant_dashboard/view/restaurant_dashboard_page.dart';
import '../../restaurant_registration/models/restaurant_registration_data.dart';

class RestaurantAccountPage extends StatelessWidget {
  final RestaurantRegistrationData? data;

  const RestaurantAccountPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return RestaurantDashboardPage(data: data, initialTab: 4);
  }
}

class RestaurantAccountContentView extends StatefulWidget {
  final RestaurantRegistrationData? data;
  final ValueChanged<int>? onSelectTab;

  const RestaurantAccountContentView({
    super.key,
    this.data,
    this.onSelectTab,
  });

  @override
  State<RestaurantAccountContentView> createState() => _RestaurantAccountContentViewState();
}

class _RestaurantAccountContentViewState extends State<RestaurantAccountContentView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final restaurantName =
        d.restaurantName.trim().isEmpty ? 'Trattoria Nonna Rosa' : d.restaurantName;
    final initials = _formatInitials(restaurantName);

    return Container(
      color: AppColors.cream,
      child: Column(
        children: [
          // Top Bar (.bar)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      height: 1.36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  // Bell button with dot (.round .dot)
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

            // Scrollable Content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Restaurant Identity (.me-head)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.restaurantProfileManage);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E4A3A),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A18181B),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  restaurantName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    height: 1.3,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
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
                                            'Approved',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF1F7A45),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '· Growth plan',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                    const SizedBox(height: 22),

                    // Section: Restaurant
                    _buildSection(
                      title: 'Restaurant',
                      rows: [
                        _buildRowItem(
                          icon: LucideIcons.store,
                          label: 'Restaurant profile',
                          value: '85%',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pushNamed(context, AppRoutes.restaurantProfileManage);
                          },
                        ),
                        _buildRowItem(
                          icon: LucideIcons.bookOpen,
                          label: 'Menu',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.restaurantMenuManage);
                          },
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Section: Business
                    _buildSection(
                      title: 'Business',
                      rows: [
                        _buildRowItem(
                          icon: LucideIcons.creditCard,
                          label: 'Subscription',
                          value: 'Growth',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.restaurantSubscription);
                          },
                        ),
                        _buildRowItem(
                          icon: LucideIcons.barChart2,
                          label: 'Statistics',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.restaurantStatistics);
                          },
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Section: Engagement
                    _buildSection(
                      title: 'Engagement',
                      rows: [
                        _buildRowItem(
                          icon: LucideIcons.award,
                          label: 'Loyalty',
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                                context, AppRoutes.restaurantLoyalty);
                            if (result == 3) {
                              if (widget.onSelectTab != null) {
                                widget.onSelectTab!(3);
                              } else if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.restaurantDashboard,
                                  (route) => false,
                                  arguments: 3,
                                );
                              }
                            }
                          },
                        ),
                        _buildRowItem(
                          icon: LucideIcons.gift,
                          label: 'Giveaways',
                          value: '1 active',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.restaurantGiveaways);
                          },
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Section: Account
                    _buildSection(
                      title: 'Account',
                      rows: [
                        _buildRowItem(
                          icon: LucideIcons.bell,
                          label: 'Notifications',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.restaurantNotifications);
                          },
                        ),
                        _buildRowItem(
                          icon: LucideIcons.settings,
                          label: 'Settings',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.restaurantSettings);
                          },
                          isLast: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> rows,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.33,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({
    IconData? icon,
    Widget? iconWidget,
    required String label,
    String? value,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: iconWidget ??
                        Icon(
                          icon,
                          size: 18,
                          color: AppColors.navy,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (value != null) ...[
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Color(0xFFA1A1AA),
                ),
              ],
            ),
          ),
          if (!isLast)
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.line,
            ),
        ],
      ),
    );
  }
}

