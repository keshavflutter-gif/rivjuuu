import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../bloc/restaurant_detail_event.dart';
import '../bloc/restaurant_detail_state.dart';
import '../widgets/restaurant_hero_header_widget.dart';
import '../widgets/restaurant_tabs_bar_widget.dart';
import '../widgets/restaurant_menu_tab_widget.dart';
import '../widgets/restaurant_coupons_tab_widget.dart';
import '../widgets/restaurant_loyalty_tab_widget.dart';
import '../widgets/restaurant_giveaways_tab_widget.dart';
import '../widgets/restaurant_reviews_tab_widget.dart';
import '../widgets/restaurant_info_sheet_widget.dart';

class RestaurantDetailView extends StatefulWidget {
  const RestaurantDetailView({super.key});

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // 1. Unified Hero + Header (Image 2 - zero clipping, seamless overlap)
              SliverToBoxAdapter(
                child: RestaurantHeroHeaderWidget(
                  restaurant: state.restaurant,
                  isFavorite: state.isFavorite,
                  onBack: () => Navigator.of(context).pop(),
                  onFavorite: () {
                    context
                        .read<RestaurantDetailBloc>()
                        .add(const RestaurantDetailFavoriteToggled());
                  },
                  onViewCoupons: () {
                    // Navigates directly to Coupons screen (restaurant-coupons.html / Image 3)
                    Navigator.of(context).pushNamed(
                      AppRoutes.restaurantTabs,
                      arguments: 1,
                    );
                  },
                  onMoreInfo: () {
                    RestaurantInfoSheetWidget.show(
                      context,
                      restaurant: state.restaurant,
                      onShowOnMap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.map,
                          arguments: state.restaurant.name,
                        );
                      },
                    );
                  },
                ),
              ),

              // Spacing between header and tabs
              const SliverToBoxAdapter(
                child: SizedBox(height: 18),
              ),

              // 3. Sticky 5-Tabs Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabsHeaderDelegate(
                  selectedIndex: state.selectedTabIndex,
                  onTabSelected: (tab) {
                    if (tab != 0) {
                      // Opens dedicated tab screen (Image 3 for Coupons, Image 4 for Loyalty, Image 5 for Giveaways, Reviews)
                      Navigator.of(context).pushNamed(
                        AppRoutes.restaurantTabs,
                        arguments: tab,
                      );
                    } else {
                      context
                          .read<RestaurantDetailBloc>()
                          .add(const RestaurantDetailTabChanged(0));
                    }
                  },
                ),
              ),

              // 4. Tab Body Content (Default: Overview with Menu photos & Popular dishes matching Image 2)
              SliverToBoxAdapter(
                child: _buildActiveTabContent(context, state),
              ),

              // Safe Area Bottom Padding
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 32,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveTabContent(
    BuildContext context,
    RestaurantDetailState state,
  ) {
    switch (state.selectedTabIndex) {
      case 0:
        return RestaurantMenuTabWidget(
          menuItems: state.menuItems,
          segmentIndex: state.menuSegmentIndex,
          onSegmentChanged: (idx) {
            context
                .read<RestaurantDetailBloc>()
                .add(RestaurantDetailMenuSegmentChanged(idx));
          },
          onViewFullMenu: () {
            // Opens full categorized menu (restaurant-menu.html)
            Navigator.of(context).pushNamed(
              AppRoutes.restaurantTabs,
              arguments: 0,
            );
          },
        );
      case 1:
        return RestaurantCouponsTabWidget(
          activeCoupons: state.coupons,
          pastCoupons: state.pastCoupons,
          onCouponTap: (coupon) {
            Navigator.of(context).pushNamed(
              AppRoutes.couponDetail,
              arguments: coupon,
            );
          },
        );
      case 2:
        return RestaurantLoyaltyTabWidget(
          restaurantName: state.restaurant.name,
          logoText: state.restaurant.logoText,
          points: state.loyaltyPoints,
          maxPoints: state.loyaltyMaxPoints,
          rewards: state.loyaltyRewards,
          activities: state.loyaltyActivities,
        );
      case 3:
        return RestaurantGiveawaysTabWidget(
          giveaways: state.giveaways,
          onJoinGiveaway: (id) {
            context
                .read<RestaurantDetailBloc>()
                .add(RestaurantDetailGiveawayJoined(id));
          },
        );
      case 4:
        return RestaurantReviewsTabWidget(
          score: state.restaurant.rating,
          reviewCount: state.restaurant.reviewCount,
          filterIndex: state.reviewFilterIndex,
          onFilterChanged: (idx) {
            context
                .read<RestaurantDetailBloc>()
                .add(RestaurantDetailReviewFilterChanged(idx));
          },
          reviews: state.reviews,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StickyTabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  _StickyTabsHeaderDelegate({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return RestaurantTabsBarWidget(
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
    );
  }

  @override
  double get maxExtent => 46;

  @override
  double get minExtent => 46;

  @override
  bool shouldRebuild(covariant _StickyTabsHeaderDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}
