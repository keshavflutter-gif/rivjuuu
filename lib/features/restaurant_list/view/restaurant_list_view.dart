import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/restaurant_list_bloc.dart';
import '../bloc/restaurant_list_event.dart';
import '../bloc/restaurant_list_state.dart';
import '../models/restaurant_item_model.dart';

/// Exact ic-sort icon from rv2.css:
/// `<path d='M3 7h10M3 12h7M3 17h4M17 4v16M14 17l3 3 3-3'/>`
class SortIcon extends StatelessWidget {
  final Color color;
  final double size;

  const SortIcon({
    super.key,
    this.color = AppColors.navy,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SortIconPainter(color: color),
      ),
    );
  }
}

class _SortIconPainter extends CustomPainter {
  final Color color;

  _SortIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0 * (size.width / 24.0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final s = size.width / 24.0;

    // Horizontal bars
    canvas.drawLine(Offset(3 * s, 7 * s), Offset(13 * s, 7 * s), paint);
    canvas.drawLine(Offset(3 * s, 12 * s), Offset(10 * s, 12 * s), paint);
    canvas.drawLine(Offset(3 * s, 17 * s), Offset(7 * s, 17 * s), paint);

    // Vertical arrow pointing down
    canvas.drawLine(Offset(17 * s, 4 * s), Offset(17 * s, 20 * s), paint);
    final path = Path()
      ..moveTo(14 * s, 17 * s)
      ..lineTo(17 * s, 20 * s)
      ..lineTo(20 * s, 17 * s);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SortIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Restaurant List View matching design/customer - home/restaurant-list.html
/// and reference image media_1794575601383_a25db386.jpg
class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            return Column(
              children: [
                // 1. Top Bar (.bar)
                _buildTopBar(context, state.title),

                // 2. Filter Chips Horizontal Bar (.chips)
                _buildFilterChips(context, state.selectedFilterIndex),

                // 3. Count line (.count-line)
                _buildCountLine(state.totalCount),

                // 4. Restaurant List View (.scroll .rr)
                Expanded(
                  child: ListView.separated(
                    key: const PageStorageKey<String>('restaurant_list_scroll'),
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
                    itemCount: state.restaurants.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.line,
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = state.restaurants[index];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pushNamed(
                            AppRoutes.restaurantDetail,
                            arguments: item.name,
                          );
                        },
                        child: _buildRestaurantRow(item),
                      );
                    },
                  ),
                ),

                // 5. Bottom Navigation Bar (.nav)
                _buildBottomNav(context, state.currentNavIndex),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      constraints: const BoxConstraints(minHeight: 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Round Back Button (.round)
          GestureDetector(
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
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Map Round Button (.round)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pushNamed(AppRoutes.map);
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
                  LucideIcons.map,
                  size: 20,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, int selectedIndex) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(top: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildChip(
            context: context,
            index: 0,
            isSelected: selectedIndex == 0,
            customIcon: SortIcon(
              size: 16,
              color: selectedIndex == 0 ? Colors.white : AppColors.navy,
            ),
            label: 'Distance',
            suffixIcon: LucideIcons.chevronDown,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            index: 1,
            isSelected: selectedIndex == 1,
            icon: LucideIcons.slidersHorizontal,
            label: 'Filters',
            badgeCount: 2,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            index: 2,
            isSelected: selectedIndex == 2,
            icon: LucideIcons.ticket,
            label: 'Has coupons',
          ),
          const SizedBox(width: 8),
          _buildChip(
            context: context,
            index: 3,
            isSelected: selectedIndex == 3,
            label: 'Open now',
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required int index,
    required bool isSelected,
    required String label,
    IconData? icon,
    Widget? customIcon,
    IconData? suffixIcon,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context
            .read<RestaurantListBloc>()
            .add(RestaurantListFilterSelected(index));
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (customIcon != null) ...[
              customIcon,
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ),
            if (badgeCount != null) ...[
              const SizedBox(width: 6),
              Container(
                constraints: const BoxConstraints(minWidth: 18),
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            if (suffixIcon != null) ...[
              const SizedBox(width: 4),
              Icon(
                suffixIcon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCountLine(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$count restaurants',
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.text,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantRow(RestaurantItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 92x92 Rounded Image (.rr__img)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              item.imagePath,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 92,
                height: 92,
                color: AppColors.peach,
                child: const Icon(
                  LucideIcons.utensils,
                  size: 28,
                  color: AppColors.coral,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Restaurant Body (.rr__body)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name (.rr__name)
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Meta Line (.meta)
                Row(
                  children: [
                    // Score (.score)
                    const Icon(
                      LucideIcons.gauge,
                      size: 15,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item.rating,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    _buildDotSeparator(),
                    Flexible(
                      child: Text(
                        item.cuisine,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: AppColors.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildDotSeparator(),
                    Text(
                      item.distance,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Perk Line or Badge Line
                if (item.perkText != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.perkIcon != null) ...[
                        Icon(
                          item.perkIcon,
                          size: 16,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          item.perkText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.coral,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (item.badgeText != null)
                  // Compact mini-badge (.mini-badge) - never stretches full width
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppColors.peach,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.badgeText!,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7A4A00),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFB5B0A6),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
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
                }, currentIndex),
              ),
              Expanded(
                child: _buildNavItem(context, 1, LucideIcons.compass, 'Explore', () {
                  HapticFeedback.selectionClick();
                  context
                      .read<RestaurantListBloc>()
                      .add(const RestaurantListNavChanged(1));
                }, currentIndex),
              ),
              Expanded(
                child: _buildNavItem(context, 2, LucideIcons.award, 'Rewards', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(AppRoutes.myRewards);
                }, currentIndex),
              ),
              Expanded(
                child: _buildNavItem(context, 3, LucideIcons.activity, 'Activity', () {
                  HapticFeedback.selectionClick();
                  context
                      .read<RestaurantListBloc>()
                      .add(const RestaurantListNavChanged(3));
                }, currentIndex),
              ),
              Expanded(
                child: _buildNavItem(context, 4, LucideIcons.user, 'Profile', () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                }, currentIndex),
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
    int currentIndex,
  ) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: isSelected ? AppColors.coral : const Color(0xFF71717A),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.coral : const Color(0xFF71717A),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
