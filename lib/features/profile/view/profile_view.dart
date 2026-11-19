import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/extensions/localization_extension.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/core/widgets/feather_award_icon.dart';
import 'package:rivjuuu/features/home/widgets/home_bottom_nav_widget.dart';
import 'package:rivjuuu/features/profile/bloc/profile_bloc.dart';
import 'package:rivjuuu/features/profile/bloc/profile_state.dart';
import 'package:rivjuuu/features/profile/widgets/profile_header_widget.dart';
import 'package:rivjuuu/features/profile/widgets/profile_menu_group_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ScrollController _scrollController;

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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar: "Profile" title + Notification icon with dot
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profileTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: -0.2,
                    ),
                  ),

                  // Notification Round Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.notifications);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 20,
                            color: AppColors.navy,
                          ),
                          // Unread Coral Dot
                          Positioned(
                            top: 10,
                            right: 11,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.coral,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
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

            // Scrollable Menu Content
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final profile = state.profile;

                  return SingleChildScrollView(
                    key: const PageStorageKey<String>('customer_profile_scroll_view'),
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User Header Card
                        ProfileHeaderWidget(
                          profile: profile,
                          onEdit: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.editProfile,
                              arguments: context.read<ProfileBloc>(),
                            );
                          },
                        ),

                        // Group 1: My activity
                        ProfileMenuGroupWidget(
                          title: l10n.myActivitySection,
                          items: [
                            ProfileMenuItem(
                              icon: Icons.confirmation_number_outlined,
                              label: l10n.couponHistoryItem,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.couponHistory);
                              },
                            ),
                            ProfileMenuItem(
                              iconWidget: const FeatherAwardIcon(size: 20),
                              label: l10n.myRewardsItem,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.myRewards);
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.card_giftcard_rounded,
                              label: l10n.myGiveawaysItem,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.myGiveaways);
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.edit_outlined,
                              label: l10n.myReviewsItem,
                              value: '${profile.reviewCount}',
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.reviewDetail);
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.favorite_border_rounded,
                              label: l10n.favoriteRestaurantsItem,
                              value: '${profile.favoriteRestaurantCount}',
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.favoriteRestaurants);
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.percent_rounded,
                              label: l10n.favoriteCouponsItem,
                              value: '${profile.favoriteCouponCount}',
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.favoriteCoupons);
                              },
                            ),
                          ],
                        ),

                        // Group 2: Social
                        ProfileMenuGroupWidget(
                          title: l10n.socialSection,
                          items: [
                            ProfileMenuItem(
                              icon: Icons.people_outline_rounded,
                              label: l10n.friendsItem,
                              value: '${profile.friendsCount}',
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                   AppRoutes.friends,
                                   arguments: 0,
                                );
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.person_outline_rounded,
                              label: l10n.friendRequestsItem,
                              value: '${profile.friendRequestsCount}',
                              isHighlightBadge: true,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.friendRequests);
                              },
                            ),
                          ],
                        ),

                        // Group 3: Account
                        ProfileMenuGroupWidget(
                          title: l10n.accountSectionProfile,
                          items: [
                            ProfileMenuItem(
                              icon: Icons.notifications_none_rounded,
                              label: l10n.notificationsItem,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.notifications);
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.settings_outlined,
                              label: l10n.settingsItem,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.settings);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavWidget(
        currentIndex: 4, // Profile tab is active
        onNavTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.categories);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.myRewards);
          }
        },
      ),
    );
  }
}
