import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/extensions/localization_extension.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/core/utils/localized_messages.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_bloc.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_event.dart';
import 'package:rivjuuu/features/auth/logout/bloc/logout_state.dart';
import 'package:rivjuuu/features/language/bloc/language_bloc.dart';
import 'package:rivjuuu/features/language/bloc/language_event.dart';

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
    final l10n = context.l10n;
    String currentLangCode = 'en';
    try {
      currentLangCode = context.watch<LanguageBloc>().state.selectedLanguage;
    } catch (_) {}
    final currentLangDisplay =
        currentLangCode == 'hu' ? l10n.languageHungarian : l10n.languageEnglish;

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
                      l10n.settingsItem,
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
                    _buildSectionHeader(l10n.accountSection),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.lock_outline_rounded,
                        label: l10n.changePassword,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.newPassword);
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.language_rounded,
                        label: l10n.language,
                        value: currentLangDisplay,
                        onTap: _showLanguageSelector,
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 2: Privacy
                    _buildSectionHeader(l10n.privacySection),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.person_outline_rounded,
                        label: l10n.profileAndActivity,
                        value: _profileVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: l10n.profileAndActivity,
                          description: l10n.profileAndActivityDesc,
                          currentValue: _profileVisibility,
                          onSelected: (val) {
                            setState(() => _profileVisibility = val);
                          },
                        ),
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.location_on_outlined,
                        label: l10n.latestVisit,
                        value: _visitVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: l10n.latestVisit,
                          description: l10n.latestVisitDesc,
                          currentValue: _visitVisibility,
                          onSelected: (val) {
                            setState(() => _visitVisibility = val);
                          },
                        ),
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.edit_outlined,
                        label: l10n.reviews,
                        value: _reviewsVisibility,
                        onTap: () => _showVisibilitySheet(
                          title: l10n.reviews,
                          description: l10n.reviewsDesc,
                          currentValue: _reviewsVisibility,
                          onSelected: (val) {
                            setState(() => _reviewsVisibility = val);
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 3: Notifications
                    _buildSectionHeader(l10n.notificationsSection),
                    _buildCardGroup([
                      _buildSwitchRow(
                        icon: Icons.confirmation_number_outlined,
                        label: l10n.couponsAndOffers,
                        value: _couponNotifications,
                        onChanged: (val) {
                          setState(() => _couponNotifications = val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchRow(
                        icon: Icons.card_membership_rounded,
                        label: l10n.rewardsAndGiveaways,
                        value: _rewardNotifications,
                        onChanged: (val) {
                          setState(() => _rewardNotifications = val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchRow(
                        icon: Icons.people_outline_rounded,
                        label: l10n.friendsAndReviews,
                        value: _socialNotifications,
                        onChanged: (val) {
                          setState(() => _socialNotifications = val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Group 4: Support & legal
                    _buildSectionHeader(l10n.supportAndLegal),
                    _buildCardGroup([
                      _buildRow(
                        icon: Icons.help_outline_rounded,
                        label: l10n.helpAndContactSupport,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                LocalizedMessages.get(context, 'Support email: support@rivjuuu.com'),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: AppColors.navy,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.description_outlined,
                        label: l10n.privacyPolicy,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.legal);
                        },
                      ),
                      _buildDivider(),
                      _buildRow(
                        icon: Icons.description_outlined,
                        label: l10n.termsAndConditions,
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
                          l10n.logOutButton,
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
                      title: context.l10n.visibilityPrivate,
                      subtitle: context.l10n.visibilityPrivateSub,
                      isSelected: tempSelected == 'Private',
                      onTap: () {
                        setSheetState(() => tempSelected = 'Private');
                      },
                    ),
                    const SizedBox(height: 10),

                    // Option: Friends only
                    _buildVisibilityOption(
                      icon: Icons.people_outline_rounded,
                      title: context.l10n.visibilityFriends,
                      subtitle: context.l10n.visibilityFriendsSub,
                      isSelected: tempSelected == 'Friends only',
                      onTap: () {
                        setSheetState(() => tempSelected = 'Friends only');
                      },
                    ),
                    const SizedBox(height: 10),

                    // Option: Public
                    _buildVisibilityOption(
                      icon: Icons.language_rounded,
                      title: context.l10n.visibilityPublic,
                      subtitle: context.l10n.visibilityPublicSub,
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
                          context.l10n.done,
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
    String selectedCode = 'en';
    try {
      selectedCode = context.read<LanguageBloc>().state.selectedLanguage;
    } catch (_) {}

    final languageOptions = [
      {'code': 'en', 'name': 'English'},
      {'code': 'hu', 'name': 'Magyar (Hungarian)'},
    ];
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
              children: languageOptions.map((opt) {
                final name = opt['name']!;
                final code = opt['code']!;
                final isSelected = selectedCode == code;
                return ListTile(
                  title: Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.coral : AppColors.navy,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.coral)
                      : null,
                  onTap: () {
                    try {
                      context.read<LanguageBloc>().add(LanguageSelected(code));
                    } catch (_) {}
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
                      LocalizedMessages.get(parentContext, state.message),
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
                      LocalizedMessages.get(parentContext, state.message),
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
                  parentContext.l10n.logOutTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                content: Text(
                  parentContext.l10n.logOutConfirmation,
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
                      parentContext.l10n.cancel,
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
                            parentContext.l10n.logOutButton,
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
