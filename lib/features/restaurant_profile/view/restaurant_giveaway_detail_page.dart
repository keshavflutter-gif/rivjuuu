import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import 'restaurant_giveaways_page.dart';

/// Restaurant Giveaway Detail Page matching:
/// - giveaway-detail.html
/// - giveaway-draw.html
/// - giveaway-winners.html
/// - giveaway-participants.html
class RestaurantGiveawayDetailPage extends StatefulWidget {
  final GiveawayItem? giveaway;
  final int initialTabIndex;
  final bool initialHasDrawn;

  const RestaurantGiveawayDetailPage({
    super.key,
    this.giveaway,
    this.initialTabIndex = 0,
    this.initialHasDrawn = false,
  });

  @override
  State<RestaurantGiveawayDetailPage> createState() =>
      _RestaurantGiveawayDetailPageState();
}

class _RestaurantGiveawayDetailPageState
    extends State<RestaurantGiveawayDetailPage> {
  late int _currentTab;
  late bool _hasDrawn;
  bool _isEndedEarly = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTabIndex;
    _hasDrawn = widget.initialHasDrawn;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showDrawWinnersSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 34),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Modal Handle (.handle)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E4E7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Heading (.bsheet__head h2)
                Text(
                  'Draw 3 winners?',
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  'Winners are picked at random from 1,248 participants. Each winner gets the prize coupon and a notification. This can’t be undone.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.48,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 14),

                // Info Hint (.hint)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.info,
                        size: 18,
                        color: Color(0xFFB06B00),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'The giveaway closes when you draw. New entries won’t be accepted.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            height: 1.44,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Draw Winners Button (.btn)
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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(sheetContext);
                      setState(() {
                        _hasDrawn = true;
                        _currentTab = 2; // Transition directly to Winners tab
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(LucideIcons.shuffle, size: 20),
                    label: Text(
                      'Draw winners',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Cancel Button (.btn btn--ghost)
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(sheetContext);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.navy,
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(color: AppColors.line, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEndGiveawayConfirmation() {
    HapticFeedback.lightImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'End giveaway early?',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          'Are you sure you want to end this giveaway now? No more entries will be accepted.',
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            color: AppColors.text,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
              side: const BorderSide(color: AppColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isEndedEarly = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Giveaway ended early.',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  backgroundColor: AppColors.navy,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2380F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'End giveaway',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.giveaway?.title.isNotEmpty == true
        ? widget.giveaway!.title
        : 'Win dinner for two';
    final imagePath = widget.giveaway?.imagePath.isNotEmpty == true
        ? widget.giveaway!.imagePath
        : 'assets/table.jpg';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        key: const PageStorageKey<String>('giveaway_detail_scroll'),
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section (.gd-hero)
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.peach,
                      child: const Center(
                        child: Icon(
                          LucideIcons.gift,
                          size: 48,
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ),
                ),
                // Hero Top Gradient
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.42),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Top Action Bar (.hero__bar)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button (.round round--photo)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.94),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.14),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.arrowLeft,
                            size: 20,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      // Edit Button (.round round--photo)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.restaurantGiveawayForm,
                            arguments: widget.giveaway,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.94),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.14),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.pencil,
                            size: 18,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Sheet Top Area (.sheet-top)
            Container(
              transform: Matrix4.translationValues(0, -22, 0),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _hasDrawn
                                    ? const Color(0xFFE6F4EA)
                                    : (_isEndedEarly
                                        ? const Color(0xFFE4E4E7)
                                        : AppColors.coral),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _hasDrawn
                                    ? 'Completed'
                                    : (_isEndedEarly ? 'Ended' : 'Active'),
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _hasDrawn
                                      ? const Color(0xFF1F7A45)
                                      : (_isEndedEarly
                                          ? AppColors.text
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Facts (.facts)
                        Row(
                          children: [
                            _buildFact(
                              label: 'Entries',
                              value: widget.giveaway != null
                                  ? '${widget.giveaway!.participantsCount}'
                                  : '1,248',
                            ),
                            const SizedBox(width: 8),
                            _buildFact(
                              label: 'Winners',
                              value: widget.giveaway != null
                                  ? '${widget.giveaway!.winnersCount}'
                                  : '3',
                            ),
                            const SizedBox(width: 8),
                            _buildFact(
                              label: 'Ends',
                              value: '14 Oct',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tabs Header (.tabs)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      border: Border(
                        bottom: BorderSide(color: AppColors.line, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem(title: 'Overview', index: 0),
                        const SizedBox(width: 22),
                        _buildTabItem(title: 'Participants', index: 1),
                        const SizedBox(width: 22),
                        _buildTabItem(title: 'Winners', index: 2),
                      ],
                    ),
                  ),

                  // Tab Body
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    child: _buildCurrentTabBody(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFact({required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.text,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final bool isOn = _currentTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _currentTab = index;
        });
      },
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isOn ? AppColors.coral : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isOn ? FontWeight.w600 : FontWeight.w500,
            color: isOn ? AppColors.navy : const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabBody() {
    switch (_currentTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildParticipantsTab();
      case 2:
        return _buildWinnersTab();
      default:
        return _buildOverviewTab();
    }
  }

  // ================= TAB 1: OVERVIEW (giveaway-detail.html) =================
  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Prize Card (.prize)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.coralSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.gift,
                size: 26,
                color: AppColors.coral,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.giveaway?.prize ?? '15,000 HUF dinner coupon',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.giveaway?.prizeType ??
                          'Prize coupon valid for 30 days',
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

        // Rules Card (.sec-card)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rules',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 10),
              _buildRuleBullet('Free to join, one entry per customer.'),
              const SizedBox(height: 6),
              _buildRuleBullet('Customers aged 18+. Staff can’t take part.'),
              const SizedBox(height: 6),
              _buildRuleBullet('Winners drawn at random after 14 Oct.'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Runs Card (.sec-card)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Runs',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '1 Oct – 14 Oct 2026',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Primary Action: Draw Winners or View Winners
        if (!_hasDrawn) ...[
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
            child: ElevatedButton.icon(
              onPressed: _showDrawWinnersSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(LucideIcons.shuffle, size: 20),
              label: Text(
                'Draw winners',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Ghost Button: End giveaway early (.btn btn--ghost)
          OutlinedButton(
            onPressed: _showEndGiveawayConfirmation,
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
        ] else ...[
          // Already Drawn state
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() {
                _currentTab = 2; // view winners
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18181B),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              LucideIcons.circleCheck,
              size: 20,
              color: Color(0xFF49D17D),
            ),
            label: Text(
              'View winners (3)',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRuleBullet(String rule) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: const BoxDecoration(
            color: AppColors.text,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            rule,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.45,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  // ============= TAB 2: PARTICIPANTS (giveaway-participants.html) =============
  Widget _buildParticipantsTab() {
    final participants = [
      {'name': 'Anna K.', 'time': 'Joined today, 19:50', 'initial': 'AK', 'av': 'a'},
      {'name': 'Péter N.', 'time': 'Joined today, 18:02', 'initial': 'PN', 'av': 'b'},
      {'name': 'Eszter F.', 'time': 'Joined today, 12:44', 'initial': 'EF', 'av': 'c'},
      {'name': 'Dávid M.', 'time': 'Joined yesterday', 'initial': 'DM', 'av': 'd'},
      {'name': 'Katalin B.', 'time': 'Joined 2 days ago', 'initial': 'KB', 'av': 'a'},
      {'name': 'Tamás V.', 'time': 'Joined 3 days ago', 'initial': 'TV', 'av': 'b'},
      {'name': 'Zoltán S.', 'time': 'Joined 4 days ago', 'initial': 'ZS', 'av': 'c'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subtitle
        Text(
          '1,248 participants · newest first',
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),

        // List container (.card-plain)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(participants.length, (idx) {
              final p = participants[idx];
              final isLast = idx == participants.length - 1;
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
                  children: [
                    _buildAvatar(p['initial']!, p['av']!),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            p['time']!,
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
              );
            }),
          ),
        ),
      ],
    );
  }

  // ================= TAB 3: WINNERS (giveaway-winners.html) =================
  Widget _buildWinnersTab() {
    if (!_hasDrawn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.coralSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.shuffle,
                size: 26,
                color: AppColors.coral,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No winners drawn yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Draw 3 winners from 1,248 participants once the giveaway ends.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.text,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showDrawWinnersSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(LucideIcons.shuffle, size: 18),
              label: Text(
                'Draw winners',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final winners = [
      {'n': '1', 'name': 'Eszter F.', 'initial': 'EF', 'av': 'c'},
      {'n': '2', 'name': 'Anna K.', 'initial': 'AK', 'av': 'a'},
      {'n': '3', 'name': 'Dávid M.', 'initial': 'DM', 'av': 'd'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Toast Banner (.toast-ok)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.circleCheck,
                size: 22,
                color: Color(0xFF49D17D),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '3 winners drawn. Prize coupons have been sent.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Winners List Card (.card-plain)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(winners.length, (idx) {
              final w = winners[idx];
              final isLast = idx == winners.length - 1;
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
                  children: [
                    // Rank badge (.winner__n)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        w['n']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Avatar (.av-sm)
                    _buildAvatar(w['initial']!, w['av']!),
                    const SizedBox(width: 12),
                    // Name and info (.person__body)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            'Prize coupon awarded',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge (.st .st--ok)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Sent',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F7A45),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String initial, String avClass) {
    Color bg;
    Color fg;
    switch (avClass) {
      case 'a':
        bg = const Color(0xFFFFE8E0);
        fg = const Color(0xFFB8330F);
        break;
      case 'b':
        bg = const Color(0xFFFDF0D9);
        fg = const Color(0xFF7A4A00);
        break;
      case 'c':
        bg = const Color(0xFFE9E3D8);
        fg = const Color(0xFF3F3F46);
        break;
      case 'd':
      default:
        bg = const Color(0xFF18181B);
        fg = Colors.white;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.poppins(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

