import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class MyGiveawaysView extends StatefulWidget {
  final int initialTab;
  final bool? showBackButton;
  final bool showBottomNav;

  const MyGiveawaysView({
    super.key,
    this.initialTab = 0,
    this.showBackButton,
    this.showBottomNav = true,
  });

  @override
  State<MyGiveawaysView> createState() => _MyGiveawaysViewState();
}

class _MyGiveawaysViewState extends State<MyGiveawaysView> {
  late int _selectedTab; // 0 = Joined, 1 = Won, 2 = Ended
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
    final showBack = widget.showBackButton ?? false;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: "My giveaways" (matching my-giveaways.html & reference image)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  if (showBack) ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.arrowLeft,
                            size: 18,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                  Text(
                    'My giveaways',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs: Joined | Won | Ended (matching rv3.css .tabs specification)
            _buildTabBar(),

            // Content List
            Expanded(
              child: SingleChildScrollView(
                key: const PageStorageKey('my_giveaways_scroll'),
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    if (_selectedTab == 0) ..._buildJoinedList(),
                    if (_selectedTab == 1) ..._buildWonList(),
                    if (_selectedTab == 2) ..._buildEndedList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav ? _buildBottomNav(context) : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 46,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(
          bottom: BorderSide(
            color: AppColors.line,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildTabItem(title: 'Joined', index: 0),
          const SizedBox(width: 22),
          _buildTabItem(title: 'Won', index: 1),
          const SizedBox(width: 22),
          _buildTabItem(title: 'Ended', index: 2),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_selectedTab != index) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedTab = index;
          });
        }
      },
      child: SizedBox(
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.navy : const Color(0xFF71717A),
                  height: 1.2,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJoinedList() {
    return [
      _buildGiveawayCard(
        imagePath: AppAssets.table,
        restaurant: 'Trattoria Nonna Rosa',
        title: 'Win dinner for two',
        prize: '15,000 HUF dinner coupon',
        footText: 'Draw on 15 Oct',
        statusText: 'Joined',
        statusColor: const Color(0xFF1F7A45),
        statusBg: const Color(0xFFE6F4EA),
      ),
      const SizedBox(height: 12),
      _buildGiveawayCard(
        imagePath: AppAssets.tiramisu,
        restaurant: 'Café Mókus',
        title: 'Dessert of the day',
        prize: 'Daily prize',
        footText: 'Next draw today 20:00',
        statusText: 'Joined',
        statusColor: const Color(0xFF1F7A45),
        statusBg: const Color(0xFFE6F4EA),
      ),
    ];
  }

  List<Widget> _buildWonList() {
    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.coral, width: 2.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  AppAssets.pizza,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.trophy,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'You won',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pizzeria Forno',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: const Color(0xFF52525B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Pizza night for four',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.ticket,
                        size: 16,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Prize coupon · valid until 7 Nov',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.couponQr,
                          arguments: {
                            'restaurant': 'Pizzeria Forno',
                            'discount': 'FREE',
                            'title': 'Pizza night for four',
                          },
                        );
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
                        'View prize coupon',
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
    ];
  }

  List<Widget> _buildEndedList() {
    return [
      _buildEndedCard(
        imagePath: AppAssets.pasta,
        restaurant: 'Trattoria Nonna Rosa',
        title: 'Pasta masterclass',
        prize: 'Not selected this time',
        footText: 'Ended 30 Sep',
      ),
      const SizedBox(height: 12),
      _buildEndedCard(
        imagePath: AppAssets.ramen,
        restaurant: 'Kōya Sushi & Ramen',
        title: 'Ramen for a week',
        prize: 'Not selected this time',
        footText: 'Ended 18 Sep',
      ),
    ];
  }

  Widget _buildGiveawayCard({
    required String imagePath,
    required String restaurant,
    required String title,
    required String prize,
    required String footText,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail (96x96 matching rv4.css .gi__img)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Details column
          Expanded(
            child: SizedBox(
              height: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          height: 1.3,
                          color: const Color(0xFF52525B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
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
                          const Icon(
                            LucideIcons.gift,
                            size: 15,
                            color: AppColors.coral,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              prize,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 1.3,
                                color: AppColors.navy,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        footText,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          height: 1.3,
                          color: const Color(0xFF52525B),
                        ),
                      ),
                      _buildStatusBadge(
                        text: statusText,
                        color: statusColor,
                        backgroundColor: statusBg,
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

  Widget _buildEndedCard({
    required String imagePath,
    required String restaurant,
    required String title,
    required String prize,
    required String footText,
  }) {
    return Opacity(
      opacity: 0.85,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail (grayscale matching my-giveaways-ended.html)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image.asset(
                  imagePath,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Details column
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            height: 1.3,
                            color: const Color(0xFF52525B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          prize,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.3,
                            color: const Color(0xFF52525B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          footText,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            height: 1.3,
                            color: const Color(0xFF52525B),
                          ),
                        ),
                        _buildStatusBadge(
                          text: 'Ended',
                          color: const Color(0xFF52525B),
                          backgroundColor: const Color(0xFFF1ECE2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required String text,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.line, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(context, 0, LucideIcons.house, 'Home', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                }),
              ),
              Expanded(
                child: _buildNavItem(context, 1, LucideIcons.compass, 'Explore', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(AppRoutes.categories);
                }),
              ),
              Expanded(
                child: _buildNavItem(context, 2, LucideIcons.award, 'Rewards', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(AppRoutes.myRewards);
                }),
              ),
              Expanded(
                child: _buildNavItem(context, 3, LucideIcons.activity, 'Activity', () {
                  HapticFeedback.selectionClick();
                }),
              ),
              Expanded(
                child: _buildNavItem(context, 4, LucideIcons.user, 'Profile', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    const currentIndex = 3; // Activity is active on customer giveaways screen
    final isSelected = currentIndex == index;
    final itemColor =
        isSelected ? AppColors.coral : const Color(0xFF71717A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: itemColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
