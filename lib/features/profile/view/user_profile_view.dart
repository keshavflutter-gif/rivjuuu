import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_assets.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';

class UserProfileView extends StatefulWidget {
  final String name;
  final String initials;
  final String subtitle;
  final int visits;
  final int reviews;
  final int friends;
  final bool isFriend;
  final Color? avatarBg;
  final Color? avatarColor;

  const UserProfileView({
    super.key,
    this.name = 'Bence Tóth',
    this.initials = 'BT',
    this.subtitle = 'Food lover · Joined Mar 2026',
    this.visits = 14,
    this.reviews = 9,
    this.friends = 32,
    this.isFriend = false,
    this.avatarBg,
    this.avatarColor,
  });

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late bool _isFriend;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _isFriend = widget.isFriend;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String get _firstName {
    final parts = widget.name.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final avatarBgColor = widget.avatarBg ?? const Color(0xFFFDF0D9);
    final avatarTextColor = widget.avatarColor ?? const Color(0xFF7A4A00);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (.bar from user-profile.html)
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
                  const Expanded(
                    child: SizedBox(),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showMoreActions(context);
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
                          Icons.more_horiz_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    // Profile Header Block (.prof from rv4.css)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Column(
                        children: [
                          // Large Avatar (.av-lg .av-b)
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: avatarBgColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(24, 24, 27, 0.1),
                                  blurRadius: 18,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.initials,
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: avatarTextColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Name (h1)
                          Text(
                            widget.name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              height: 1.32,
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Subtitle (p)
                          Text(
                            widget.subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF71717A),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Stats row (.stats)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStat('${widget.visits}', 'Visits'),
                              const SizedBox(width: 28),
                              _buildStat('${widget.reviews}', 'Reviews'),
                              const SizedBox(width: 28),
                              _buildStat('${widget.friends}', 'Friends'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Action button (.btn .btn--sm)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _isFriend = !_isFriend;
                              });
                            },
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 22),
                              decoration: BoxDecoration(
                                color: _isFriend
                                    ? const Color(0xFFF1ECE1)
                                    : AppColors.coral,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isFriend
                                        ? Icons.check_rounded
                                        : LucideIcons.plus,
                                    size: 16,
                                    color: _isFriend
                                        ? AppColors.navy
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isFriend ? 'Friends' : 'Add friend',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _isFriend
                                          ? AppColors.navy
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sections (Latest visit, Reviews, Private activity)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Latest visit subhead
                          Text(
                            'Latest visit',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Latest visit card (.visit from rv4.css)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.line),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    AppAssets.sushi,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kōya Sushi & Ramen',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Visited 5 Oct 2026',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFF71717A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(horizontal: 9),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.line),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        LucideIcons.gauge,
                                        size: 15,
                                        color: AppColors.coral,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '9.6',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Reviews subhead
                          Text(
                            'Reviews',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Review card (.rv from rv3.css)
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
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        AppAssets.burger,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bamba Burger Bar',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                          Text(
                                            '2 Oct 2026',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.5,
                                              color: const Color(0xFF71717A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 26,
                                      padding: const EdgeInsets.symmetric(horizontal: 9),
                                      decoration: BoxDecoration(
                                        color: AppColors.cream,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.line),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            LucideIcons.gauge,
                                            size: 15,
                                            color: AppColors.coral,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '8.4',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Juicy smash burgers and the 1+1 deal on weekdays is great value.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    height: 1.48,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Private banner (.private from rv4.css)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F1E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.lock,
                                  size: 18,
                                  color: Color(0xFF71717A),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Some of $_firstName’s activity is only visible to friends.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      height: 1.44,
                                      color: const Color(0xFF71717A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: const Color(0xFF71717A),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDanger ? const Color(0xFFFFEBE8) : AppColors.cream,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: isDanger ? const Color(0xFFC2380F) : AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: isDanger ? const Color(0xFFC2380F) : AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4CEBA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options card (.rows from rv4.css & user-profile-actions.html)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      _buildActionRow(
                        icon: LucideIcons.plus,
                        label: 'Add friend',
                        onTap: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _isFriend = true;
                          });
                        },
                      ),
                      const Divider(height: 1, color: AppColors.line),
                      _buildActionRow(
                        icon: LucideIcons.flag,
                        label: 'Report user',
                        onTap: () => Navigator.of(ctx).pop(),
                      ),
                      const Divider(height: 1, color: AppColors.line),
                      _buildActionRow(
                        icon: LucideIcons.circleAlert,
                        label: 'Block $_firstName',
                        isDanger: true,
                        onTap: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel button (.btn--ghost)
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
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
}
