import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

/// Giveaway Model matching giveaways.html, giveaway-detail.html, giveaway-form.html
class GiveawayItem {
  final String id;
  final String title;
  final String description;
  final String prize;
  final String prizeType;
  final String dateRange;
  final int participantsCount;
  final int winnersCount;
  final String status; // 'Active', 'Scheduled', 'Completed'
  final Color statusColor;
  final Color statusBg;
  final String imagePath;
  final List<String> rules;

  const GiveawayItem({
    required this.id,
    required this.title,
    required this.description,
    required this.prize,
    required this.prizeType,
    required this.dateRange,
    required this.participantsCount,
    required this.winnersCount,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.imagePath,
    required this.rules,
  });
}

/// Restaurant Giveaways Page matching batch-05-restaurant-app/html/giveaways.html
class RestaurantGiveawaysPage extends StatefulWidget {
  const RestaurantGiveawaysPage({super.key});

  @override
  State<RestaurantGiveawaysPage> createState() =>
      _RestaurantGiveawaysPageState();
}

class _RestaurantGiveawaysPageState extends State<RestaurantGiveawaysPage> {
  int _selectedTabIndex = 0; // 0: Active, 1: Scheduled, 2: Completed

  final List<GiveawayItem> _allGiveaways = [
    // Active · 1
    const GiveawayItem(
      id: 'gw_1',
      title: 'Win dinner for two',
      description:
          'Celebrate autumn at Nonna Rosa. Three winners get a dinner for two.',
      prize: '15,000 HUF dinner coupon',
      prizeType: 'Prize coupon · valid 30 days',
      dateRange: '1–14 Oct',
      participantsCount: 1248,
      winnersCount: 3,
      status: 'Active',
      statusColor: Colors.white,
      statusBg: AppColors.coral,
      imagePath: 'assets/table.jpg',
      rules: [
        'Free to join, one entry per customer.',
        'Customers aged 18+. Staff can’t take part.',
        'Winners drawn at random after 14 Oct.',
      ],
    ),
    // Scheduled · 1
    const GiveawayItem(
      id: 'gw_2',
      title: 'Weekend Brunch Voucher',
      description:
          'Join us for weekend brunch specials with fresh Italian coffee and pastries.',
      prize: 'Free 2x Brunch Combo',
      prizeType: 'Prize voucher · valid 14 days',
      dateRange: '20–27 Oct',
      participantsCount: 0,
      winnersCount: 2,
      status: 'Scheduled',
      statusColor: Color(0xFF8A5300),
      statusBg: Color(0xFFFDF0D9),
      imagePath: 'assets/dining.jpg',
      rules: [
        'Valid on Saturday and Sunday brunches.',
        'One entry per registered guest.',
      ],
    ),
    // Completed · 4
    const GiveawayItem(
      id: 'gw_3',
      title: 'Summer Pizza Feast',
      description:
          'Special summer giveaway celebrate wood-fired Neapolitan pizza.',
      prize: 'Free large Margherita',
      prizeType: 'Coupon redeemed',
      dateRange: '1–15 Aug',
      participantsCount: 840,
      winnersCount: 5,
      status: 'Completed',
      statusColor: Color(0xFF52525B),
      statusBg: Color(0xFFF1ECE2),
      imagePath: 'assets/pizza.jpg',
      rules: ['Summer promotion event.'],
    ),
    const GiveawayItem(
      id: 'gw_4',
      title: 'Wine Tasting for Couples',
      description: 'Exclusive 4-course wine pairing dinner.',
      prize: 'Wine Pairing Experience',
      prizeType: 'Coupon redeemed',
      dateRange: '10–24 Jul',
      participantsCount: 620,
      winnersCount: 2,
      status: 'Completed',
      statusColor: Color(0xFF52525B),
      statusBg: Color(0xFFF1ECE2),
      imagePath: 'assets/dining.jpg',
      rules: ['Wine club reservation.'],
    ),
    const GiveawayItem(
      id: 'gw_5',
      title: 'Birthday Gift Voucher',
      description: 'Complimentary birthday dinner celebration.',
      prize: '10,000 HUF Voucher',
      prizeType: 'Coupon redeemed',
      dateRange: '1–30 Jun',
      participantsCount: 510,
      winnersCount: 3,
      status: 'Completed',
      statusColor: Color(0xFF52525B),
      statusBg: Color(0xFFF1ECE2),
      imagePath: 'assets/table.jpg',
      rules: ['Valid on birthday month.'],
    ),
    const GiveawayItem(
      id: 'gw_6',
      title: 'Gelato & Dessert Platter',
      description: 'Artisanal Italian gelato sampler.',
      prize: 'Dessert Platter for 4',
      prizeType: 'Coupon redeemed',
      dateRange: '15–31 May',
      participantsCount: 430,
      winnersCount: 4,
      status: 'Completed',
      statusColor: Color(0xFF52525B),
      statusBg: Color(0xFFF1ECE2),
      imagePath: 'assets/dessert.jpg',
      rules: ['Valid on festival weekend.'],
    ),
  ];

  List<GiveawayItem> get _filteredGiveaways {
    if (_selectedTabIndex == 0) {
      return _allGiveaways.where((g) => g.status == 'Active').toList();
    } else if (_selectedTabIndex == 1) {
      return _allGiveaways.where((g) => g.status == 'Scheduled').toList();
    } else {
      return _allGiveaways.where((g) => g.status == 'Completed').toList();
    }
  }

  Future<void> _navigateToCreateGiveaway([GiveawayItem? editItem]) async {
    HapticFeedback.lightImpact();
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.restaurantGiveawayForm,
      arguments: editItem,
    );
    if (result is GiveawayItem && mounted) {
      setState(() {
        if (editItem != null) {
          final index = _allGiveaways.indexWhere((g) => g.id == editItem.id);
          if (index != -1) {
            _allGiveaways[index] = result;
          }
        } else {
          _allGiveaways.insert(0, result);
        }
        _selectedTabIndex = 0;
      });
    }
  }

  void _showGiveawayDetailSheet(GiveawayItem item) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.90,
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Hero Image with top controls
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.peach,
                        child: const Icon(
                          LucideIcons.partyPopper,
                          size: 40,
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
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
                  ),
                  Positioned(
                    top: 14,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _navigateToCreateGiveaway(item);
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.edit2,
                            size: 18,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Sheet body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.statusBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.status == 'Active') ...[
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                                Text(
                                  item.status,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: item.statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Facts (.facts)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFact(
                              'Entries',
                              _formatNumber(item.participantsCount),
                            ),
                            Container(
                                width: 1, height: 28, color: AppColors.line),
                            _buildFact('Winners', '${item.winnersCount}'),
                            Container(
                                width: 1, height: 28, color: AppColors.line),
                            _buildFact('Ends', '14 Oct'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Prize Card (.prize)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.coralSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  LucideIcons.gift,
                                  size: 20,
                                  color: AppColors.coral,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.prize,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.prizeType,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Rules Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rules',
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...item.rules.map(
                              (r) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        r,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.5,
                                          height: 1.35,
                                          color: AppColors.navy,
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

                      const SizedBox(height: 14),

                      // Timing Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Runs',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                            Text(
                              '1 Oct – 14 Oct 2026',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action Button: Draw winners
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(254, 85, 46, 0.22),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Winners drawn successfully!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(LucideIcons.shuffle, size: 20),
                            label: Text(
                              'Draw winners',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.coral,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // End giveaway early (.btn btn--ghost)
                      OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFC2380F),
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: AppColors.line, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'End giveaway early',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFC2380F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFact(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        _allGiveaways.where((g) => g.status == 'Active').length;
    final scheduledCount =
        _allGiveaways.where((g) => g.status == 'Scheduled').length;
    final completedCount =
        _allGiveaways.where((g) => g.status == 'Completed').length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top App Bar (.bar) matching Image 1 & giveaways.html
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
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
                  Expanded(
                    child: Text(
                      'Giveaways',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCreateGiveaway(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.coral),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Underline Tabbar (.tabs) matching Image 1 & rv3.css
            _buildUnderlineTabBar(
              activeCount,
              scheduledCount,
              completedCount,
            ),

            // Giveaways list (.scroll)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._filteredGiveaways
                        .map((item) => _buildGiveawayCard(item)),

                    const SizedBox(height: 14),

                    // Create Giveaway Button (.btn btn--ghost) matching Image 1
                    OutlinedButton.icon(
                      onPressed: () => _navigateToCreateGiveaway(),
                      icon: const Icon(
                        LucideIcons.plus,
                        size: 20,
                        color: AppColors.navy,
                      ),
                      label: Text(
                        'Create giveaway',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.navy,
                        side: const BorderSide(color: AppColors.line),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
    );
  }

  /// Horizontal Underline Tab Bar matching Image 1 & batch-05-restaurant-app rv3.css
  Widget _buildUnderlineTabBar(
    int activeCount,
    int scheduledCount,
    int completedCount,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(
          bottom: BorderSide(color: AppColors.line, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildUnderlineTab(0, 'Active · $activeCount'),
            const SizedBox(width: 22),
            _buildUnderlineTab(1, 'Scheduled · $scheduledCount'),
            const SizedBox(width: 22),
            _buildUnderlineTab(2, 'Completed · $completedCount'),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderlineTab(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedTabIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.navy : const Color(0xFF71717A),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(3)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiveawayCard(GiveawayItem item) {
    return GestureDetector(
      onTap: () => _showGiveawayDetailSheet(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image with Status Badge
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.peach,
                      child: const Icon(
                        LucideIcons.gift,
                        size: 32,
                        color: AppColors.coral,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.statusBg,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.status == 'Active') ...[
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                        Text(
                          item.status,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body (.gm__body)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Prize Row (.gc__prize)
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.gift,
                        size: 16,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.prize,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Meta Info Wrap (.gc__meta)
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildMetaTag(
                        LucideIcons.calendar,
                        item.dateRange,
                      ),
                      _buildMetaTag(
                        LucideIcons.users,
                        '${_formatNumber(item.participantsCount)} joined',
                      ),
                      _buildMetaTag(
                        LucideIcons.trophy,
                        '${item.winnersCount} winners',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final lastThree = str.substring(str.length - 3);
      final rest = str.substring(0, str.length - 3);
      return '$rest,$lastThree';
    }
    return number.toString();
  }

  Widget _buildMetaTag(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.text),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

