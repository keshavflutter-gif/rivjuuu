import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

/// Restaurant Settings Screen
/// Matching batch-05-restaurant-app/html/settings.html & settings-language.html
class RestaurantSettingsPage extends StatefulWidget {
  const RestaurantSettingsPage({super.key});

  @override
  State<RestaurantSettingsPage> createState() => _RestaurantSettingsPageState();
}

class _RestaurantSettingsPageState extends State<RestaurantSettingsPage> {
  String _selectedLanguage = 'English';

  // Notification Preferences matching settings.html
  bool _couponRedemptions = true;
  bool _giveawayUpdates = true;
  bool _loyaltyRewards = false;
  bool _subscriptionBilling = true;

  void _showChangePasswordSheet() {
    HapticFeedback.lightImpact();
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.line,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change password',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.line),
                              ),
                              child: const Center(
                                child: Icon(
                                  LucideIcons.x,
                                  size: 18,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // 1. Current password
                      _buildFieldLabel('Current password'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: currentPassController,
                        obscureText: obscureCurrent,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.navy,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Enter current password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureCurrent
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              size: 18,
                              color: AppColors.text,
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureCurrent = !obscureCurrent;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 2. New password
                      _buildFieldLabel('New password'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: newPassController,
                        obscureText: obscureNew,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.navy,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Enter new password (min. 8 characters)',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureNew
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              size: 18,
                              color: AppColors.text,
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureNew = !obscureNew;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 3. Confirm new password
                      _buildFieldLabel('Confirm new password'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: confirmPassController,
                        obscureText: obscureConfirm,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.navy,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Re-enter new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              size: 18,
                              color: AppColors.text,
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureConfirm = !obscureConfirm;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Submit Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            final current = currentPassController.text.trim();
                            final next = newPassController.text.trim();
                            final confirm = confirmPassController.text.trim();

                            if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please fill in all password fields.',
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.navy,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            if (next != confirm) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'New passwords do not match.',
                                    style: GoogleFonts.poppins(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFFFE552E),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Password changed successfully!',
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                backgroundColor: AppColors.navy,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Update password',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
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
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Head
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Language',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.line),
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.x,
                                size: 18,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // English Option
                    _buildLanguageItem(
                      name: 'English',
                      isSelected: _selectedLanguage == 'English',
                      flagWidget: _buildEnglishFlag(),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedLanguage = 'English';
                        });
                        setModalState(() {});
                        Navigator.pop(ctx);
                      },
                    ),

                    const SizedBox(height: 10),

                    // Hungarian Option
                    _buildLanguageItem(
                      name: 'Hungarian',
                      isSelected: _selectedLanguage == 'Hungarian',
                      flagWidget: _buildHungarianFlag(),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedLanguage = 'Hungarian';
                        });
                        setModalState(() {});
                        Navigator.pop(ctx);
                      },
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Changes apply straight away.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showInfoDialog(String title, String content) {
    HapticFeedback.lightImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.navy,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Log out',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your restaurant account?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.accountType,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE552E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Log out',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top App Bar (.bar, style="padding-top: 4px") matching settings.html
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
                      'Settings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Account
                    _buildSectionHeader('Account'),
                    const SizedBox(height: 8),
                    _buildRowsContainer([
                      _buildRowItem(
                        icon: LucideIcons.lock,
                        label: 'Change password',
                        onTap: _showChangePasswordSheet,
                        showChevron: true,
                      ),
                      _buildRowDivider(),
                      _buildRowItem(
                        icon: LucideIcons.globe,
                        label: 'Language',
                        value: _selectedLanguage,
                        onTap: _showLanguageSheet,
                        showChevron: true,
                      ),
                    ]),

                    const SizedBox(height: 22),

                    // Section 2: Notification preferences
                    _buildSectionHeader('Notification preferences'),
                    const SizedBox(height: 8),
                    _buildRowsContainer([
                      _buildSwitchRow(
                        icon: LucideIcons.scan,
                        label: 'Coupon redemptions',
                        value: _couponRedemptions,
                        onChanged: (val) {
                          setState(() => _couponRedemptions = val);
                        },
                      ),
                      _buildRowDivider(),
                      _buildSwitchRow(
                        icon: LucideIcons.gift,
                        label: 'Giveaway updates',
                        value: _giveawayUpdates,
                        onChanged: (val) {
                          setState(() => _giveawayUpdates = val);
                        },
                      ),
                      _buildRowDivider(),
                      _buildSwitchRow(
                        icon: LucideIcons.award,
                        label: 'Loyalty rewards',
                        value: _loyaltyRewards,
                        onChanged: (val) {
                          setState(() => _loyaltyRewards = val);
                        },
                      ),
                      _buildRowDivider(),
                      _buildSwitchRow(
                        icon: LucideIcons.creditCard,
                        label: 'Subscription & billing',
                        value: _subscriptionBilling,
                        onChanged: (val) {
                          setState(() => _subscriptionBilling = val);
                        },
                      ),
                    ]),

                    const SizedBox(height: 22),

                    // Section 3: Support & legal
                    _buildSectionHeader('Support & legal'),
                    const SizedBox(height: 8),
                    _buildRowsContainer([
                      _buildRowItem(
                        icon: LucideIcons.helpCircle,
                        label: 'Help & contact support',
                        onTap: () {
                          _showInfoDialog(
                            'Support',
                            'Need help with your restaurant profile, coupons, or billing?\n\nReach our merchant team at support@rivjuuu.com or via live chat during business hours (9:00 - 18:00 CET).',
                          );
                        },
                        showChevron: true,
                      ),
                      _buildRowDivider(),
                      _buildRowItem(
                        icon: LucideIcons.fileText,
                        label: 'Privacy Policy',
                        onTap: () {
                          _showInfoDialog(
                            'Privacy Policy',
                            'Rivjuuu protects your restaurant and customer data in accordance with GDPR and applicable EU privacy laws. We never sell your business or consumer data to third parties.',
                          );
                        },
                        showChevron: true,
                      ),
                      _buildRowDivider(),
                      _buildRowItem(
                        icon: LucideIcons.fileText,
                        label: 'Terms and Conditions',
                        onTap: () {
                          _showInfoDialog(
                            'Terms and Conditions',
                            'By using Rivjuuu Restaurant Merchant portal, you agree to fulfill redeemed coupons, loyalty rewards, and giveaways in good faith. Standard merchant service terms apply.',
                          );
                        },
                        showChevron: true,
                      ),
                    ]),

                    const SizedBox(height: 22),

                    // Section 4: Log out (.row.row--danger)
                    _buildRowsContainer([
                      _buildRowItem(
                        icon: LucideIcons.logOut,
                        label: 'Log out',
                        onTap: _confirmLogout,
                        isDanger: true,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildRowsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildRowDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.line);
  }

  Widget _buildRowItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? value,
    bool showChevron = false,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Icon in 34x34 box (.row__icon)
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDanger
                    ? const Color(0xFFFFE8E0)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: isDanger ? const Color(0xFFFE552E) : AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Label (.row__label)
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: isDanger ? FontWeight.w600 : FontWeight.w400,
                  color: isDanger ? const Color(0xFFFE552E) : AppColors.navy,
                ),
              ),
            ),
            // Value (.row__value)
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
            // Chevron
            if (showChevron)
              const Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: Color(0xFFA1A1AA),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Icon in 34x34 box
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Label
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
          const SizedBox(width: 10),
          // Switch matching rv4.css:192 (.switch)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(!value);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? AppColors.coral : const Color(0xFFE4DDD0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required String name,
    required bool isSelected,
    required Widget flagWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.coral : AppColors.line,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: flagWidget,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
            ),
            // Radio button (.radio)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.coral : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.coral : const Color(0xFFCFCBC5),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnglishFlag() {
    return Container(
      color: const Color(0xFF012169),
      child: Stack(
        children: [
          // White diagonal cross
          Center(
            child: Container(
              width: 28,
              height: 4,
              color: Colors.white,
            ),
          ),
          Center(
            child: Container(
              width: 4,
              height: 20,
              color: Colors.white,
            ),
          ),
          // Red cross
          Center(
            child: Container(
              width: 28,
              height: 2.5,
              color: const Color(0xFFC8102E),
            ),
          ),
          Center(
            child: Container(
              width: 2.5,
              height: 20,
              color: const Color(0xFFC8102E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHungarianFlag() {
    return Column(
      children: [
        Expanded(child: Container(color: const Color(0xFFCD2A3E))),
        Expanded(child: Container(color: Colors.white)),
        Expanded(child: Container(color: const Color(0xFF436F4D))),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.navy,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: AppColors.text.withValues(alpha: 0.5),
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
      ),
    );
  }
}


