import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../models/restaurant_detail_models.dart';

class RestaurantDetailState extends Equatable {
  final RestaurantDetailModel restaurant;
  final int selectedTabIndex;
  final bool isFavorite;
  final int menuSegmentIndex;
  final int reviewFilterIndex;
  final List<MenuItemModel> menuItems;
  final List<CouponModel> coupons;
  final List<CouponModel> pastCoupons;
  final int loyaltyPoints;
  final int loyaltyMaxPoints;
  final List<LoyaltyRewardModel> loyaltyRewards;
  final List<LoyaltyActivityModel> loyaltyActivities;
  final List<GiveawayModel> giveaways;
  final List<ReviewModel> reviews;

  const RestaurantDetailState({
    required this.restaurant,
    this.selectedTabIndex = 0,
    this.isFavorite = false,
    this.menuSegmentIndex = 0,
    this.reviewFilterIndex = 0,
    this.menuItems = const [],
    this.coupons = const [],
    this.pastCoupons = const [],
    this.loyaltyPoints = 320,
    this.loyaltyMaxPoints = 400,
    this.loyaltyRewards = const [],
    this.loyaltyActivities = const [],
    this.giveaways = const [],
    this.reviews = const [],
  });

  factory RestaurantDetailState.initial({int initialTabIndex = 0}) {
    return RestaurantDetailState(
      restaurant: RestaurantDetailModel.defaultTrattoria(),
      selectedTabIndex: initialTabIndex,
      isFavorite: false,
      menuSegmentIndex: 0,
      reviewFilterIndex: 0,
      menuItems: const [
        // Starters
        MenuItemModel(
          id: 's1',
          name: 'Burrata & tomatoes',
          description: 'Puglia burrata, heirloom tomatoes, basil oil',
          price: '3,200 HUF',
          imageUrl: AppAssets.bowl,
          section: 'Starters',
        ),
        MenuItemModel(
          id: 's2',
          name: 'Bruschetta trio',
          description: 'Tomato, mushroom, nduja',
          price: '2,400 HUF',
          imageUrl: null,
          section: 'Starters',
        ),
        // Main dishes
        MenuItemModel(
          id: 'm1',
          name: 'Cacio e pepe',
          description: 'Tonnarelli, pecorino romano, black pepper',
          price: '3,900 HUF',
          imageUrl: AppAssets.pasta,
          section: 'Main dishes',
        ),
        MenuItemModel(
          id: 'm2',
          name: "Penne all'arrabbiata",
          description: 'Tomato, garlic, chilli, parsley',
          price: '3,400 HUF',
          imageUrl: AppAssets.penne,
          section: 'Main dishes',
        ),
        MenuItemModel(
          id: 'm3',
          name: 'Margherita',
          description: 'San Marzano, fior di latte, basil',
          price: '3,600 HUF',
          imageUrl: AppAssets.pizza,
          section: 'Main dishes',
        ),
        // Desserts
        MenuItemModel(
          id: 'd1',
          name: 'Tiramisu della Nonna',
          description: 'Mascarpone, espresso, cocoa',
          price: '1,900 HUF',
          imageUrl: AppAssets.tiramisu,
          section: 'Desserts',
        ),
        // Drinks
        MenuItemModel(
          id: 'dr1',
          name: 'Espresso',
          description: null,
          price: '650 HUF',
          imageUrl: null,
          section: 'Drinks',
        ),
        MenuItemModel(
          id: 'dr2',
          name: 'House lemonade',
          description: 'Lemon, mint, soda',
          price: '1,200 HUF',
          imageUrl: null,
          section: 'Drinks',
        ),
      ],
      coupons: const [
        CouponModel(
          id: 'c1',
          discountVal: '20%',
          discountSmall: 'Off',
          type: 'Discount',
          title: '20% off your whole bill',
          requirement: 'Minimum spend 5,000 HUF',
          statusText: 'Available',
          statusType: CouponStatusType.available,
          meta: 'Until 31 Oct',
        ),
        CouponModel(
          id: 'c2',
          discountVal: 'Free',
          discountSmall: 'Free',
          icon: Icons.card_giftcard_rounded,
          type: 'Gift item',
          title: 'Free tiramisu with any main',
          requirement: 'One per table',
          statusText: 'Available',
          statusType: CouponStatusType.available,
          meta: 'Until 31 Oct',
        ),
        CouponModel(
          id: 'c3',
          discountVal: '1+1',
          discountSmall: 'Pizza',
          type: 'Buy one, get one',
          title: 'Second Margherita free',
          requirement: 'Weekends only',
          statusText: 'Available',
          statusType: CouponStatusType.available,
          meta: 'Sat–Sun',
        ),
        CouponModel(
          id: 'c4',
          discountVal: 'Happy',
          discountSmall: 'Hour',
          icon: Icons.access_time_rounded,
          type: 'Happy hour',
          title: 'Aperol spritz for 1,500 HUF',
          requirement: 'Mon–Fri, 16:00–18:00',
          statusText: 'Available from 16:00',
          statusType: CouponStatusType.wait,
          isDark: true,
        ),
      ],
      pastCoupons: const [
        CouponModel(
          id: 'p1',
          discountVal: '15%',
          discountSmall: 'Off',
          type: 'Seasonal',
          title: 'Truffle week',
          requirement: 'Ended 30 Sep 2026',
          statusText: 'Expired',
          statusType: CouponStatusType.expired,
          isPast: true,
        ),
        CouponModel(
          id: 'p2',
          discountVal: '25%',
          discountSmall: 'Off',
          type: 'First visit',
          title: '25% off your first visit',
          requirement: 'Redeemed 12 Oct, 19:42',
          statusText: 'Used',
          statusType: CouponStatusType.used,
          meta: '+40 pts earned',
          isPast: true,
        ),
      ],
      loyaltyPoints: 320,
      loyaltyMaxPoints: 400,
      loyaltyRewards: const [
        LoyaltyRewardModel(
          id: 'r1',
          title: 'Free espresso',
          pointsText: '150 points',
          imageUrl: AppAssets.coffee,
          isLocked: false,
        ),
        LoyaltyRewardModel(
          id: 'r2',
          title: 'Free tiramisu',
          pointsText: '400 points · 80 more to go',
          imageUrl: AppAssets.tiramisu,
          isLocked: true,
        ),
        LoyaltyRewardModel(
          id: 'r3',
          title: '5,000 HUF off dinner',
          pointsText: '1,000 points',
          imageUrl: AppAssets.table,
          isLocked: true,
        ),
      ],
      loyaltyActivities: const [
        LoyaltyActivityModel(
          title: 'Coupon redeemed · 20% off',
          date: '12 Oct 2026',
          deltaText: '+40',
          isPositive: true,
        ),
        LoyaltyActivityModel(
          title: 'Reward used · Free espresso',
          date: '2 Oct 2026',
          deltaText: '−150',
          isPositive: false,
        ),
        LoyaltyActivityModel(
          title: 'Coupon redeemed · Free tiramisu',
          date: '24 Sep 2026',
          deltaText: '+25',
          isPositive: true,
        ),
      ],
      giveaways: const [
        GiveawayModel(
          id: 'g1',
          title: 'Win dinner for two',
          prize: '15,000 HUF dinner coupon · 3 winners',
          dateMeta: 'Closes 14 Oct',
          joinedMeta: '1,248 joined',
          imageUrl: AppAssets.table,
          status: GiveawayStatus.open,
          actionText: 'Join giveaway',
        ),
        GiveawayModel(
          id: 'g2',
          title: 'Dessert of the day, every day this week',
          prize: 'Daily prize · 1 winner per day',
          dateMeta: 'Next draw today 20:00',
          imageUrl: AppAssets.tiramisu,
          status: GiveawayStatus.joined,
        ),
        GiveawayModel(
          id: 'g3',
          title: 'Pizza night for four',
          prize: 'Your prize coupon is in My Coupons',
          dateMeta: 'Won 10 Oct',
          imageUrl: AppAssets.pizza,
          status: GiveawayStatus.won,
          actionText: 'View prize coupon',
        ),
        GiveawayModel(
          id: 'g4',
          title: 'Pasta masterclass',
          dateMeta: 'Ended 30 Sep · Not selected this time',
          imageUrl: AppAssets.pasta,
          status: GiveawayStatus.ended,
        ),
      ],
      reviews: const [
        ReviewModel(
          id: 'rv1',
          initials: 'AK',
          name: 'Anna K.',
          date: '12 Oct 2026',
          visitedWithCoupon: true,
          score: 8.9,
          text:
              "Best cacio e pepe I've had outside Rome. Staff scanned my coupon in seconds and the tiramisu was on the house.",
          images: [AppAssets.pasta, AppAssets.tiramisu, AppAssets.interior],
          avatarBg: Color(0xFFFFE8E0),
          avatarColor: Color(0xFFFE552E),
        ),
        ReviewModel(
          id: 'rv2',
          initials: 'BT',
          name: 'Bence T.',
          date: '8 Oct 2026',
          visitedWithCoupon: true,
          score: 9.6,
          text:
              'Lovely courtyard and friendly service. The 1+1 pizza deal on Saturday was great value.',
          images: [],
          avatarBg: Color(0xFFFDF0D9),
          avatarColor: Color(0xFF7A4A00),
        ),
        ReviewModel(
          id: 'rv3',
          initials: 'ZS',
          name: 'Zsófia B.',
          date: '3 Oct 2026',
          visitedWithCoupon: false,
          score: 6.2,
          text:
              'Food was good, but we waited a while on a busy Friday night.',
          images: [],
          avatarBg: Color(0xFFE9E3D8),
          avatarColor: Color(0xFF3F3F46),
        ),
      ],
    );
  }

  RestaurantDetailState copyWith({
    RestaurantDetailModel? restaurant,
    int? selectedTabIndex,
    bool? isFavorite,
    int? menuSegmentIndex,
    int? reviewFilterIndex,
    List<MenuItemModel>? menuItems,
    List<CouponModel>? coupons,
    List<CouponModel>? pastCoupons,
    int? loyaltyPoints,
    int? loyaltyMaxPoints,
    List<LoyaltyRewardModel>? loyaltyRewards,
    List<LoyaltyActivityModel>? loyaltyActivities,
    List<GiveawayModel>? giveaways,
    List<ReviewModel>? reviews,
  }) {
    return RestaurantDetailState(
      restaurant: restaurant ?? this.restaurant,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      menuSegmentIndex: menuSegmentIndex ?? this.menuSegmentIndex,
      reviewFilterIndex: reviewFilterIndex ?? this.reviewFilterIndex,
      menuItems: menuItems ?? this.menuItems,
      coupons: coupons ?? this.coupons,
      pastCoupons: pastCoupons ?? this.pastCoupons,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyMaxPoints: loyaltyMaxPoints ?? this.loyaltyMaxPoints,
      loyaltyRewards: loyaltyRewards ?? this.loyaltyRewards,
      loyaltyActivities: loyaltyActivities ?? this.loyaltyActivities,
      giveaways: giveaways ?? this.giveaways,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [
        restaurant,
        selectedTabIndex,
        isFavorite,
        menuSegmentIndex,
        reviewFilterIndex,
        menuItems,
        coupons,
        pastCoupons,
        loyaltyPoints,
        loyaltyMaxPoints,
        loyaltyRewards,
        loyaltyActivities,
        giveaways,
        reviews,
      ];
}


