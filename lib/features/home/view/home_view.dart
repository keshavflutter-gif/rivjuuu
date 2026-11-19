import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_search_bar_widget.dart';
import '../widgets/home_promo_banner_widget.dart';
import '../widgets/home_category_chip_widget.dart';
import '../widgets/home_restaurant_card_widget.dart';
import '../widgets/home_hot_offer_widget.dart';
import '../widgets/home_giveaway_widget.dart';
import '../widgets/home_bottom_nav_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _lastBackPressTime;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBackPress() {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            context.l10n.tapAgainToExit,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SystemNavigator.pop();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: SafeArea(
            bottom: false,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  key: const PageStorageKey<String>('customer_home_scroll_view'),
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    // 1. Header (Location & Notifications)
                    const HomeHeaderWidget(),

                    const SizedBox(height: 14),

                    // 2. Search Row
                    const HomeSearchBarWidget(),

                    const SizedBox(height: 18),

                    // 3. Promo Banner
                    const HomePromoBannerWidget(),

                    const SizedBox(height: 24),

                    // 4. Categories Section
                    _buildSectionHeader(
                      title: 'Categories',
                      actionText: 'See all',
                      onActionTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.categories);
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 104,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.categories.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final cat = state.categories[index];
                          return HomeCategoryChipWidget(
                            title: cat.title,
                            imagePath: cat.imagePath,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.restaurantList,
                                arguments: '${cat.title} restaurants',
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 5. Nearby Restaurants Section
                    _buildSectionHeader(
                      title: 'Nearby restaurants',
                      actionText: 'Map',
                      onActionTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.map);
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 226,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.nearbyRestaurants.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final item = state.nearbyRestaurants[index];
                          return HomeNearbyCardWidget(
                            restaurant: item,
                            onFavoriteTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeFavoriteToggled(item.id));
                            },
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.restaurantDetail,
                                arguments: item.name,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 6. Hot Offers Section
                    _buildSectionHeader(
                      title: 'Hot offers',
                      actionText: 'See all',
                      onActionTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.restaurantTabs,
                          arguments: 1,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 104,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.hotOffers.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final offer = state.hotOffers[index];
                          return HomeHotOfferTicketWidget(
                            offer: offer,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.restaurantTabs,
                                arguments: 1,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 7. Recommended Section
                    _buildSectionHeader(
                      title: 'Recommended for you',
                      actionText: 'See all',
                      onActionTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.restaurantList);
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: List.generate(
                          state.recommendedRestaurants.length,
                          (index) {
                            final item = state.recommendedRestaurants[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: HomeRecommendedCardWidget(
                                restaurant: item,
                                onFavoriteTap: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(HomeFavoriteToggled(item.id));
                                },
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.restaurantDetail,
                                    arguments: item.name,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 8. Giveaways Section
                    _buildSectionHeader(
                      title: 'Giveaways',
                      actionText: 'See all',
                      onActionTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.restaurantTabs,
                          arguments: 3,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: List.generate(state.giveaways.length, (index) {
                          final gw = state.giveaways[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.restaurantTabs,
                                  arguments: 3,
                                );
                              },
                              child: HomeGiveawayWidget(
                                giveaway: gw,
                                onJoinTap: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(HomeGiveawayJoinToggled(gw.id));
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (prev, curr) =>
              prev.currentNavIndex != curr.currentNavIndex,
          builder: (context, state) {
            return HomeBottomNavWidget(
              currentIndex: state.currentNavIndex,
              onNavTap: (index) {
                if (index == 0) {
                  _scrollToTop();
                  context.read<HomeBloc>().add(const HomeNavChanged(0));
                } else if (index == 1) {
                  Navigator.of(context).pushNamed(AppRoutes.categories);
                } else if (index == 2) {
                  Navigator.of(context).pushNamed(AppRoutes.myRewards);
                } else if (index == 4) {
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                } else {
                  context.read<HomeBloc>().add(HomeNavChanged(index));
                }
              },
            );
          },
        ),
      ),
    ),
  );
}

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
