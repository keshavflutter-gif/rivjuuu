import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_bloc.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_event.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_state.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final ScrollController _scrollController;

  // Privacy settings
  String _profileVisibility = 'Friends only';
  String _visitVisibility = 'Friends only';
  String _reviewsVisibility = 'Public';

  // Notification switches
  bool _couponNotifications = true;
  bool _rewardNotifications = true;
  bool _socialNotifications = false;

  // Language
  String _currentLanguage = 'English';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
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
                      'Settings',
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

            // Content Groups
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Group 1: Account
                    _buildSectionHeader('Account'),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change password',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.newPassword);
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.language_rounded,
                        label: 'Language',
                        value: _currentLanguage,
                        onTap: _showLanguageSelector,
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 2: Privacy
                    _buildSectionHeader('Privacy'),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Profile & activity',
                        value: _profileVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: 'Profile & activity',
                          description:
                              'Choose who can see your profile, visits and activity.',
                          currentValue: _profileVisibility,
                          onSelected: (val) {
                            setState(() => _profileVisibility = val);
                          },
                        ),
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.location_on_outlined,
                        label: 'Latest visit',
                        value: _visitVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: 'Latest visit',
                          description:
                              'Choose who can see the restaurant you visited last.',
                          currentValue: _visitVisibility,
                          onSelected: (val) {
                            setState(() => _visitVisibility = val);
                          },
                        ),
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.edit_outlined,
                        label: 'Reviews',
                        value: _reviewsVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: 'Reviews',
                          description:
                              'Choose who can read your restaurant reviews.',
                          currentValue: _reviewsVisibility,
                          onSelected: (val) {
                            setState(() => _reviewsVisibility = val);
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 3: Notifications
                    _buildSectionHeader('Notifications'),
                    _buildCardGroup([
                      _buildSwitchRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Coupons & offers',
                        value: _couponNotifications,
                        onChanged: (val) {
                          setState(() => _couponNotifications = val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchRow(
                        icon: Icons.card_membership_rounded,
                        label: 'Rewards & giveaways',
                        value: _rewardNotifications,
                        onChanged: (val) {
                          setState(() => _rewardNotifications = val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchRow(
                        icon: Icons.people_outline_rounded,
                        label: 'Friends & reviews',
                        value: _socialNotifications,
                        onChanged: (val) {
                          setState(() => _socialNotifications = val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 4: Support & legal
                    _buildSectionHeader('Support & legal'),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & contact support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Support email: support@rivjuuu.com'),
                              duration: Duration(seconds: 2),
                              backgroundColor: AppColors.navy,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.description_outlined,
                        label: 'Privacy Policy',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.legal);
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.description_outlined,
                        label: 'Terms and Conditions',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.legal);
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 5: Danger Log out
                    _buildCardGroup([
                      ListTile(
                        onTap: _confirmLogout,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: 20,
                            color: Color(0xFFFE552E),
                          ),
                        ),
                        title: Text(
                          'Log out',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFE552E),
                          ),
                        ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.line);
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.navy),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.text,
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.navy),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: AppColors.coral,
        inactiveTrackColor: const Color(0xFFE5E7EB),
      ),
    );
  }

  void _showVisibilitySheet({
    required String title,
    required String description,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    String tempSelected = currentValue;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Head
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Option: Private
                    _buildVisibilityOption(
                      icon: Icons.lock_outline_rounded,
                      title: 'Private',
                      subtitle: 'Only you',
                      isSelected: tempSelected == 'Private',
                      onTap: () {
                        setSheetState(() => tempSelected = 'Private');
                      },
                    ),
                    const SizedBox(height: 10),

                    // Option: Friends only
                    _buildVisibilityOption(
                      icon: Icons.people_outline_rounded,
                      title: 'Friends only',
                      subtitle: 'People you’ve accepted as friends',
                      isSelected: tempSelected == 'Friends only',
                      onTap: () {
                        setSheetState(() => tempSelected = 'Friends only');
                      },
                    ),
                    const SizedBox(height: 10),

                    // Option: Public
                    _buildVisibilityOption(
                      icon: Icons.language_rounded,
                      title: 'Public',
                      subtitle: 'Anyone on Rivjuuu',
                      isSelected: tempSelected == 'Public',
                      onTap: () {
                        setSheetState(() => tempSelected = 'Public');
                      },
                    ),
                    const SizedBox(height: 22),

                    // Done Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(tempSelected);
                          Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Done',
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
            );
          },
        );
      },
    );
  }

  Widget _buildVisibilityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cream : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.coral : AppColors.line,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.coral : AppColors.navy,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.coral : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.coral : AppColors.line,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, size: 14, color: Colors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Magyar (Hungarian)', 'Deutsch (German)'];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                return ListTile(
                  title: Text(
                    lang,
                    style: GoogleFonts.poppins(
                      fontWeight: _currentLanguage == lang
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _currentLanguage == lang
                          ? AppColors.coral
                          : AppColors.navy,
                    ),
                  ),
                  trailing: _currentLanguage == lang
                      ? const Icon(Icons.check, color: AppColors.coral)
                      : null,
                  onTap: () {
                    setState(() {
                      _currentLanguage = lang;
                    });
                    Navigator.of(ctx).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout() {
    LogoutBloc logoutBloc;
    try {
      logoutBloc = context.read<LogoutBloc>();
    } catch (_) {
      logoutBloc = LogoutBloc();
    }

    final parentContext = context;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return BlocProvider.value(
          value: logoutBloc,
          child: BlocConsumer<LogoutBloc, LogoutState>(
            listener: (consumerCtx, state) {
              if (state is LogoutSuccess) {
                Navigator.of(dialogCtx).pop();
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      state.message,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF1F7A45),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                Navigator.of(parentContext).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              } else if (state is LogoutFailure) {
                Navigator.of(dialogCtx).pop();
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      state.message,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFE03131),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                if (state.sessionCleared || state.statusCode == 401) {
                  // If token expired/invalid (401), session is cleared and redirected to Login
                  Navigator.of(parentContext).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              }
            },
            builder: (consumerCtx, state) {
              final isLoading = state is LogoutLoading;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Log out',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                content: Text(
                  'Are you sure you want to log out of Rivjuuu?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed:
                        isLoading ? null : () => Navigator.of(dialogCtx).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: isLoading ? AppColors.muted : AppColors.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            logoutBloc.add(const LogoutRequested());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFE552E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Log out',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
