import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class FavoriteRestaurantItem {
  final String id;
  final String name;
  final String imagePath;
  final String score;
  final String cuisine;
  final String distance;
  final String? perkText;
  final IconData? perkIcon;
  final bool hasCoupons;
  final bool isOpen;

  const FavoriteRestaurantItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.score,
    required this.cuisine,
    required this.distance,
    this.perkText,
    this.perkIcon,
    this.hasCoupons = false,
    this.isOpen = true,
  });
}

class FavoriteRestaurantsView extends StatefulWidget {
  const FavoriteRestaurantsView({super.key});

  @override
  State<FavoriteRestaurantsView> createState() =>
      _FavoriteRestaurantsViewState();
}

class _FavoriteRestaurantsViewState extends State<FavoriteRestaurantsView> {
  int _selectedChipIndex = 1; // 0 = Recently saved, 1 = All, 2 = Has coupons, 3 = Open now
  final Set<String> _favoriteIds = {'1', '2', '3', '4', '5'};
  late final ScrollController _scrollController;
  late final ScrollController _chipsScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _chipsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _chipsScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<FavoriteRestaurantItem> _items = const [
    FavoriteRestaurantItem(
      id: '1',
      name: 'Trattoria Nonna Rosa',
      imagePath: AppAssets.pasta,
      score: '8.9',
      cuisine: 'Italian',
      distance: '1.2 km',
      perkText: '3 coupons available',
      perkIcon: LucideIcons.ticket,
      hasCoupons: true,
      isOpen: true,
    ),
    FavoriteRestaurantItem(
      id: '2',
      name: 'Kōya Sushi & Ramen',
      imagePath: AppAssets.sushi,
      score: '9.2',
      cuisine: 'Asian',
      distance: '2.4 km',
      perkText: 'Reward ready',
      perkIcon: LucideIcons.gift,
      hasCoupons: false,
      isOpen: true,
    ),
    FavoriteRestaurantItem(
      id: '3',
      name: 'Café Mókus',
      imagePath: AppAssets.coffee,
      score: '9.0',
      cuisine: 'Café',
      distance: '400 m',
      perkText: '1 coupon available',
      perkIcon: LucideIcons.ticket,
      hasCoupons: true,
      isOpen: true,
    ),
    FavoriteRestaurantItem(
      id: '4',
      name: 'Bamba Burger Bar',
      imagePath: AppAssets.burger,
      score: '8.4',
      cuisine: 'Burgers',
      distance: '650 m',
      perkText: '1+1 this week',
      perkIcon: LucideIcons.ticket,
      hasCoupons: true,
      isOpen: false,
    ),
    FavoriteRestaurantItem(
      id: '5',
      name: 'Masala House',
      imagePath: AppAssets.indian,
      score: '8.7',
      cuisine: 'Indian',
      distance: '1.8 km',
      hasCoupons: false,
      isOpen: true,
    ),
  ];

  List<FavoriteRestaurantItem> get _filteredItems {
    var list = _items.where((item) => _favoriteIds.contains(item.id)).toList();
    if (_selectedChipIndex == 2) {
      list = list.where((item) => item.hasCoupons).toList();
    } else if (_selectedChipIndex == 3) {
      list = list.where((item) => item.isOpen).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar (matching favorite-restaurants.html & reference image)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
              child: Row(
                children: [
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
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Favorite restaurants',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
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
            ),

            // Chips Row (.chips)
            Container(
              height: 36,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: ListView(
                controller: _chipsScrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildChip(
                    label: 'Recently saved',
                    index: 0,
                    useSortIcon: true,
                    trailingIcon: LucideIcons.chevronDown,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(label: 'All', index: 1),
                  const SizedBox(width: 8),
                  _buildChip(
                    label: 'Has coupons',
                    index: 2,
                    leadingIcon: LucideIcons.ticket,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(label: 'Open now', index: 3),
                ],
              ),
            ),

            // Count Line (.count-line)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
              child: Text(
                '${filtered.length} restaurants',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF52525B),
                ),
              ),
            ),

            // Restaurant Rows List (.rr list on cream background)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final isFav = _favoriteIds.contains(item.id);
                  final isLast = index == filtered.length - 1;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pushNamed(
                        AppRoutes.restaurantDetail,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(
                                  color: AppColors.line,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Restaurant image with heart badge (.rr__img)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  item.imagePath,
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      if (isFav) {
                                        _favoriteIds.remove(item.id);
                                      } else {
                                        _favoriteIds.add(item.id);
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        LucideIcons.heart,
                                        size: 15,
                                        color: isFav
                                            ? AppColors.coral
                                            : const Color(0xFF71717A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Restaurant details (.rr__body)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.gauge,
                                      size: 14,
                                      color: AppColors.coral,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.score,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFB5B0A6),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.cuisine,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        color: const Color(0xFF52525B),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFB5B0A6),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.distance,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        color: const Color(0xFF52525B),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.perkText != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        item.perkIcon ?? LucideIcons.ticket,
                                        size: 14,
                                        color: AppColors.coral,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          item.perkText!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.coral,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required int index,
    bool useSortIcon = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) {
    final isSelected = _selectedChipIndex == index;
    final itemColor = isSelected ? Colors.white : AppColors.navy;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedChipIndex = index;
        });
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (useSortIcon) ...[
              CustomPaint(
                size: const Size(15, 14),
                painter: _SortIconPainter(color: itemColor),
              ),
              const SizedBox(width: 6),
            ] else if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 14,
                color: itemColor,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: itemColor,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 4),
              Icon(
                trailingIcon,
                size: 14,
                color: itemColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom painter for `ic-sort` matching rv3.css
class _SortIconPainter extends CustomPainter {
  final Color color;
  const _SortIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Up arrow line
    canvas.drawLine(const Offset(2.5, 3), const Offset(2.5, 11), paint);
    // Up arrow head
    canvas.drawLine(const Offset(0.5, 5), const Offset(2.5, 3), paint);
    canvas.drawLine(const Offset(4.5, 5), const Offset(2.5, 3), paint);

    // Down arrow line
    canvas.drawLine(const Offset(6.5, 3), const Offset(6.5, 11), paint);
    // Down arrow head
    canvas.drawLine(const Offset(4.5, 9), const Offset(6.5, 11), paint);
    canvas.drawLine(const Offset(8.5, 9), const Offset(6.5, 11), paint);

    // Two horizontal bars
    canvas.drawLine(const Offset(10, 4.5), const Offset(15, 4.5), paint);
    canvas.drawLine(const Offset(10, 9.5), const Offset(13.5, 9.5), paint);
  }

  @override
  bool shouldRepaint(covariant _SortIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
