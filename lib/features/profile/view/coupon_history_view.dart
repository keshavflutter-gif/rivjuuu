import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class CouponHistoryItem {
  final String restaurant;
  final String title;
  final String date;
  final String imagePath;
  final String valueText;
  final bool isRedeemed; // true = Redeemed, false = Expired
  final String month;

  const CouponHistoryItem({
    required this.restaurant,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.valueText,
    required this.isRedeemed,
    required this.month,
  });
}

class CouponHistoryView extends StatefulWidget {
  const CouponHistoryView({super.key});

  @override
  State<CouponHistoryView> createState() => _CouponHistoryViewState();
}

class _CouponHistoryViewState extends State<CouponHistoryView> {
  int _selectedFilter = 0; // 0 = All, 1 = Redeemed, 2 = Expired

  static const List<CouponHistoryItem> _allCoupons = [
    CouponHistoryItem(
      restaurant: 'Trattoria Nonna Rosa',
      title: '20% off your whole bill',
      date: '8 Oct 2026 · 19:42',
      imagePath: AppAssets.pasta,
      valueText: '20% OFF',
      isRedeemed: true,
      month: 'October 2026',
    ),
    CouponHistoryItem(
      restaurant: 'Bamba Burger Bar',
      title: 'Second burger free',
      date: '3 Oct 2026 · 13:10',
      imagePath: AppAssets.burger,
      valueText: '1+1',
      isRedeemed: true,
      month: 'October 2026',
    ),
    CouponHistoryItem(
      restaurant: 'Café Mókus',
      title: 'Free dessert with any main',
      date: '1 Oct 2026 · 16:25',
      imagePath: AppAssets.tiramisu,
      valueText: 'FREE',
      isRedeemed: true,
      month: 'October 2026',
    ),
    CouponHistoryItem(
      restaurant: 'Trattoria Nonna Rosa',
      title: 'Truffle week',
      date: 'Ended 30 Sep 2026',
      imagePath: AppAssets.plate,
      valueText: '15% OFF',
      isRedeemed: false,
      month: 'September 2026',
    ),
    CouponHistoryItem(
      restaurant: 'Kōya Sushi & Ramen',
      title: '25% off your first visit',
      date: '21 Sep 2026 · 20:05',
      imagePath: AppAssets.sushi,
      valueText: '25% OFF',
      isRedeemed: true,
      month: 'September 2026',
    ),
  ];

  List<CouponHistoryItem> get _filteredCoupons {
    if (_selectedFilter == 1) {
      return _allCoupons.where((c) => c.isRedeemed).toList();
    }
    if (_selectedFilter == 2) {
      return _allCoupons.where((c) => !c.isRedeemed).toList();
    }
    return _allCoupons;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCoupons;
    final months = filtered.map((c) => c.month).toSet().toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Coupon history',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chips: All, Redeemed, Expired
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildChip('All', 0),
                  const SizedBox(width: 8),
                  _buildChip('Redeemed', 1),
                  const SizedBox(width: 8),
                  _buildChip('Expired', 2),
                ],
              ),
            ),

            // List of items grouped by month
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No coupons in this period',
                        style: GoogleFonts.poppins(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: months.length,
                      itemBuilder: (context, mIndex) {
                        final month = months[mIndex];
                        final itemsInMonth =
                            filtered.where((c) => c.month == month).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: mIndex == 0 ? 4 : 16,
                                bottom: 8,
                              ),
                              child: Text(
                                month,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF71717A),
                                ),
                              ),
                            ),
                            ...itemsInMonth.map((item) => _buildCouponCard(item)),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.navy,
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCard(CouponHistoryItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.couponQr,
          arguments: {
            'restaurant': item.restaurant,
            'discount': item.valueText,
            'title': item.title,
          },
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 58,
              height: 58,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.cardBg,
                  child: const Icon(Icons.restaurant, color: AppColors.muted),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Body: Restaurant, Title, Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.restaurant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // End: Value text and Status pill
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.valueText,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: item.isRedeemed ? AppColors.coral : const Color(0xFF71717A),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item.isRedeemed
                      ? const Color(0xFFE5F5E9)
                      : const Color(0xFFECE7DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.isRedeemed ? 'Redeemed' : 'Expired',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item.isRedeemed
                        ? const Color(0xFF2E9E5B)
                        : const Color(0xFF71717A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
