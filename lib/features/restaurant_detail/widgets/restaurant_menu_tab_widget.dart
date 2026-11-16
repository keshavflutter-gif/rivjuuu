import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantMenuTabWidget extends StatefulWidget {
  final List<MenuItemModel> menuItems;
  final int segmentIndex;
  final ValueChanged<int> onSegmentChanged;
  final VoidCallback? onViewFullMenu;
  final bool isFullMenuDefault;
  final VoidCallback? onViewOverview;

  const RestaurantMenuTabWidget({
    super.key,
    required this.menuItems,
    required this.segmentIndex,
    required this.onSegmentChanged,
    this.onViewFullMenu,
    this.isFullMenuDefault = false,
    this.onViewOverview,
  });

  @override
  State<RestaurantMenuTabWidget> createState() =>
      _RestaurantMenuTabWidgetState();
}

class _RestaurantMenuTabWidgetState extends State<RestaurantMenuTabWidget> {
  late bool _showFullMenu;

  @override
  void initState() {
    super.initState();
    _showFullMenu = widget.isFullMenuDefault;
  }

  @override
  void didUpdateWidget(covariant RestaurantMenuTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFullMenuDefault != widget.isFullMenuDefault) {
      _showFullMenu = widget.isFullMenuDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_showFullMenu) ...[
            // 1. Menu Photos Section (as in restaurant.html overview)
            Text(
              'Menu photos',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                children: [
                  _buildPhotoCard(AppAssets.pasta),
                  const SizedBox(width: 10),
                  _buildPhotoCard(AppAssets.tiramisu),
                  const SizedBox(width: 10),
                  _buildPdfCard(onTap: () {
                    if (widget.onViewFullMenu != null) {
                      widget.onViewFullMenu!();
                    } else {
                      setState(() {
                        _showFullMenu = true;
                      });
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 2. Popular Dishes Section (as in restaurant.html overview)
            Text(
              'Popular dishes',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  _buildDishItem(
                    name: 'Cacio e pepe',
                    desc: 'Tonnarelli, pecorino romano, black pepper',
                    price: '3,900 HUF',
                    image: AppAssets.pasta,
                    isLast: false,
                  ),
                  _buildDishItem(
                    name: 'Tiramisu della Nonna',
                    desc: 'Mascarpone, espresso, cocoa',
                    price: '1,900 HUF',
                    image: AppAssets.tiramisu,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ] else ...[
            // FULL CATEGORIZED MENU VIEW (restaurant-menu.html matching Image 2)
            // Segmented Pill Control (Menu items / Menu photos) - exactly .seg in rv3.css
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSegmentButton(
                      title: 'Menu items',
                      isSelected: widget.segmentIndex == 0,
                      onTap: () => widget.onSegmentChanged(0),
                    ),
                    const SizedBox(width: 2),
                    _buildSegmentButton(
                      title: 'Menu photos',
                      icon: Icons.image_outlined,
                      isSelected: widget.segmentIndex == 1,
                      onTap: () => widget.onSegmentChanged(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (widget.segmentIndex == 0) ...[
              _buildCategorySection(
                title: 'Starters',
                items: widget.menuItems
                    .where((i) => i.section == 'Starters')
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildCategorySection(
                title: 'Main dishes',
                items: widget.menuItems
                    .where((i) => i.section == 'Main dishes')
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildCategorySection(
                title: 'Desserts',
                items: widget.menuItems
                    .where((i) => i.section == 'Desserts')
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildCategorySection(
                title: 'Drinks',
                items: widget.menuItems
                    .where((i) => i.section == 'Drinks')
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildMenuPhotosAndPdfSection(),
            ] else ...[
              _buildFullPhotosGrid(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        assetPath,
        width: 108,
        height: 140,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 108,
          height: 140,
          color: AppColors.cream,
          child: const Icon(Icons.image, color: AppColors.muted),
        ),
      ),
    );
  }

  Widget _buildPdfCard({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 28,
              color: AppColors.coral,
            ),
            const SizedBox(height: 8),
            Text(
              'Full menu',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF · 4 pages',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPhotosAndPdfSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu photos & PDF',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            children: [
              _buildPhotoCard(AppAssets.pasta),
              const SizedBox(width: 10),
              _buildPhotoCard(AppAssets.pizza),
              const SizedBox(width: 10),
              _buildPdfCard(onTap: () {
                // PDF viewer or action
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDishItem({
    required String name,
    required String desc,
    required String price,
    required String image,
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.line, width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF71717A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String title,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<MenuItemModel> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: AppColors.line, width: 1),
                        ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                              height: 1.35,
                            ),
                          ),
                          if (item.description != null &&
                              item.description!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              item.description!,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: const Color(0xFF71717A),
                                height: 1.4,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            item.price,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                              height: 1.38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.imageUrl != null) ...[
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.imageUrl!,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 76,
                            height: 76,
                            color: AppColors.cream,
                            child: const Icon(
                              Icons.restaurant,
                              color: AppColors.muted,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFullPhotosGrid() {
    final photoList = [
      AppAssets.pasta,
      AppAssets.pizza,
      AppAssets.tiramisu,
      AppAssets.penne,
      AppAssets.bowl,
      AppAssets.interior,
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: photoList.length,
      itemBuilder: (_, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            photoList[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
