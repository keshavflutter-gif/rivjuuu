import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../bloc/restaurant_detail_event.dart';
import '../bloc/restaurant_detail_state.dart';
import '../widgets/restaurant_mini_head_widget.dart';
import '../widgets/restaurant_tabs_bar_widget.dart';
import '../widgets/restaurant_menu_tab_widget.dart';
import '../widgets/restaurant_coupons_tab_widget.dart';
import '../widgets/restaurant_loyalty_tab_widget.dart';
import '../widgets/restaurant_giveaways_tab_widget.dart';
import '../widgets/restaurant_reviews_tab_widget.dart';

class RestaurantTabbedView extends StatefulWidget {
  const RestaurantTabbedView({super.key});

  @override
  State<RestaurantTabbedView> createState() => _RestaurantTabbedViewState();
}

class _RestaurantTabbedViewState extends State<RestaurantTabbedView> {
  late final ScrollController _menuScrollController;
  late final ScrollController _couponsScrollController;
  late final ScrollController _loyaltyScrollController;
  late final ScrollController _giveawaysScrollController;
  late final ScrollController _reviewsScrollController;

  @override
  void initState() {
    super.initState();
    _menuScrollController = ScrollController();
    _couponsScrollController = ScrollController();
    _loyaltyScrollController = ScrollController();
    _giveawaysScrollController = ScrollController();
    _reviewsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    _couponsScrollController.dispose();
    _loyaltyScrollController.dispose();
    _giveawaysScrollController.dispose();
    _reviewsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
        builder: (context, state) {
          final bottomPadding = MediaQuery.of(context).padding.bottom + 24;

          return Column(
            children: [
              // 1. Top Mini-Header (Back on left, Restaurant name in center, Heart on right)
              RestaurantMiniHeadWidget(
                restaurantName: state.restaurant.name,
                isFavorite: state.isFavorite,
                onBack: () => Navigator.of(context).pop(),
                onFavorite: () {
                  context
                      .read<RestaurantDetailBloc>()
                      .add(const RestaurantDetailFavoriteToggled());
                },
              ),

              // 2. Sticky Horizontal 5-Tabs Bar
              RestaurantTabsBarWidget(
                selectedIndex: state.selectedTabIndex,
                onTabSelected: (tab) {
                  context
                      .read<RestaurantDetailBloc>()
                      .add(RestaurantDetailTabChanged(tab));
                },
              ),

              // 3. Independent Scrollable Tab Screens (IndexedStack preserves per-tab scroll state & eliminates jumping)
              Expanded(
                child: IndexedStack(
                  index: state.selectedTabIndex.clamp(0, 4),
                  children: [
                    // Tab 0: Full Categorized Menu (restaurant-menu.html)
                    SingleChildScrollView(
                      key: const PageStorageKey('restaurant_tab_menu_scroll'),
                      controller: _menuScrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          RestaurantMenuTabWidget(
                            menuItems: state.menuItems,
                            segmentIndex: state.menuSegmentIndex,
                            isFullMenuDefault: true,
                            onSegmentChanged: (idx) {
                              context
                                  .read<RestaurantDetailBloc>()
                                  .add(RestaurantDetailMenuSegmentChanged(idx));
                            },
                            onViewOverview: () {
                              if (_menuScrollController.hasClients) {
                                _menuScrollController.jumpTo(0.0);
                              }
                            },
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),

                    // Tab 1: Coupons Screen (restaurant-coupons.html / Image 3)
                    SingleChildScrollView(
                      key: const PageStorageKey('restaurant_tab_coupons_scroll'),
                      controller: _couponsScrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          RestaurantCouponsTabWidget(
                            activeCoupons: state.coupons,
                            pastCoupons: state.pastCoupons,
                            onCouponTap: (coupon) {
                              Navigator.of(context).pushNamed(
                                AppRoutes.couponDetail,
                                arguments: coupon,
                              );
                            },
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),

                    // Tab 2: Loyalty Screen (restaurant-loyalty.html / Image 4)
                    SingleChildScrollView(
                      key: const PageStorageKey('restaurant_tab_loyalty_scroll'),
                      controller: _loyaltyScrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          RestaurantLoyaltyTabWidget(
                            restaurantName: state.restaurant.name,
                            logoText: state.restaurant.logoText,
                            points: state.loyaltyPoints,
                            maxPoints: state.loyaltyMaxPoints,
                            rewards: state.loyaltyRewards,
                            activities: state.loyaltyActivities,
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),

                    // Tab 3: Giveaways Screen (restaurant-giveaways.html / Image 5)
                    SingleChildScrollView(
                      key: const PageStorageKey('restaurant_tab_giveaways_scroll'),
                      controller: _giveawaysScrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          RestaurantGiveawaysTabWidget(
                            giveaways: state.giveaways,
                            onJoinGiveaway: (id) {
                              context
                                  .read<RestaurantDetailBloc>()
                                  .add(RestaurantDetailGiveawayJoined(id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Joined giveaway successfully!',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: const Color(0xFF1F7A45),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            onViewPrizeCoupon: () {
                              context
                                  .read<RestaurantDetailBloc>()
                                  .add(const RestaurantDetailTabChanged(1));
                            },
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),

                    // Tab 4: Reviews Screen (restaurant-reviews.html)
                    SingleChildScrollView(
                      key: const PageStorageKey('restaurant_tab_reviews_scroll'),
                      controller: _reviewsScrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          RestaurantReviewsTabWidget(
                            score: state.restaurant.rating,
                            reviewCount: state.restaurant.reviewCount,
                            filterIndex: state.reviewFilterIndex,
                            onFilterChanged: (idx) {
                              context
                                  .read<RestaurantDetailBloc>()
                                  .add(RestaurantDetailReviewFilterChanged(idx));
                            },
                            reviews: state.reviews,
                          ),
                          SizedBox(height: bottomPadding),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
