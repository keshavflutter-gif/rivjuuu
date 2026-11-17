import 'package:flutter/material.dart';
import '../../features/splash/view/splash_page.dart';
import '../../features/language/view/language_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/account_type_page.dart';
import '../../features/auth/view/customer_signup_page.dart';
import '../../features/auth/view/forgot_password_page.dart';
import '../../features/auth/view/check_email_page.dart';
import '../../features/auth/view/new_password_page.dart';
import '../../features/auth/view/password_updated_page.dart';
import '../../features/auth/view/legal_page.dart';
import '../../features/permissions/view/location_permission_page.dart';
import '../../features/permissions/view/notification_permission_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/restaurant_list/view/restaurant_list_page.dart';
import '../../features/search/view/search_page.dart';
import '../../features/restaurant_detail/view/restaurant_detail_page.dart';
import '../../features/restaurant_detail/view/restaurant_tabbed_page.dart';
import '../../features/map/view/map_page.dart';
import '../../features/categories/view/categories_page.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/view/profile_page.dart';
import '../../features/profile/view/edit_profile_page.dart';
import '../../features/profile/view/coupon_history_page.dart';
import '../../features/profile/view/my_giveaways_page.dart';
import '../../features/profile/view/review_detail_page.dart';
import '../../features/profile/view/favorite_restaurants_page.dart';
import '../../features/profile/view/favorite_coupons_page.dart';
import '../../features/coupon_detail/view/coupon_detail_page.dart';
import '../../features/restaurant_detail/models/restaurant_detail_models.dart';
import '../../features/profile/view/coupon_qr_page.dart';
import '../../features/profile/view/redemption_success_page.dart';
import '../../features/profile/view/friends_page.dart';
import '../../features/profile/view/user_profile_page.dart';
import '../../features/profile/view/notifications_page.dart';
import '../../features/profile/view/settings_page.dart';
import '../../features/rewards/view/my_rewards_page.dart';
import '../../features/rewards/view/loyalty_detail_page.dart';
import '../../features/rewards/view/reward_redeemed_page.dart';
import '../../features/restaurant_registration/models/restaurant_registration_data.dart';
import '../../features/restaurant_registration/view/restaurant_step1_page.dart';
import '../../features/restaurant_registration/view/restaurant_step2_page.dart';
import '../../features/restaurant_registration/view/restaurant_step3_page.dart';
import '../../features/restaurant_registration/view/restaurant_step4_page.dart';
import '../../features/restaurant_registration/view/registration_pending_page.dart';
import '../../features/restaurant_registration/view/registration_approved_page.dart';
import '../../features/restaurant_registration/view/registration_rejected_page.dart';
import '../../features/restaurant_registration/view/choose_plan_page.dart';
import '../../features/restaurant_dashboard/view/restaurant_dashboard_page.dart';
import '../../features/restaurant_coupons/view/restaurant_coupons_page.dart';
import '../../features/restaurant_coupons/view/restaurant_coupon_form_page.dart';
import '../../features/restaurant_coupons/view/restaurant_coupon_detail_page.dart';
import '../../features/restaurant_profile/view/restaurant_account_page.dart';
import '../../features/restaurant_profile/view/restaurant_menu_manage_page.dart';
import '../../features/restaurant_profile/view/restaurant_subscription_page.dart';
import '../../features/restaurant_profile/view/restaurant_statistics_page.dart';
import '../../features/restaurant_profile/view/restaurant_loyalty_page.dart';
import '../../features/restaurant_profile/view/restaurant_giveaways_page.dart';
import '../../features/restaurant_profile/view/restaurant_giveaway_form_page.dart';
import '../../features/restaurant_profile/view/restaurant_giveaway_detail_page.dart';
import '../../features/restaurant_profile/view/restaurant_reward_form_page.dart';
import '../../features/restaurant_profile/view/restaurant_settings_page.dart';
import '../../features/restaurant_profile/view/restaurant_profile_manage_page.dart';
import '../../features/restaurant_profile/view/restaurant_notifications_page.dart';
import '../../features/restaurant_scanner/view/restaurant_scanner_page.dart';
import '../../features/restaurant_scanner/view/restaurant_scan_result_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String home = '/home';
  static const String accountType = '/account-type';
  static const String customerSignUp = '/customer-sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String checkEmail = '/check-email';
  static const String newPassword = '/new-password';
  static const String passwordUpdated = '/password-updated';
  static const String locationPermission = '/location-permission';
  static const String notificationPermission = '/notification-permission';
  static const String legal = '/legal';
  static const String restaurantList = '/restaurant-list';
  static const String search = '/search';
  static const String restaurantDetail = '/restaurant-detail';
  static const String restaurantTabs = '/restaurant-tabs';
  static const String map = '/map';
  static const String categories = '/categories';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String myRewards = '/my-rewards';
  static const String loyaltyDetail = '/loyalty-detail';
  static const String rewardRedeemed = '/reward-redeemed';
  static const String couponHistory = '/coupon-history';
  static const String myGiveaways = '/my-giveaways';
  static const String reviewDetail = '/review-detail';
  static const String favoriteRestaurants = '/favorite-restaurants';
  static const String favoriteCoupons = '/favorite-coupons';
  static const String couponDetail = '/coupon-detail';
  static const String couponQr = '/coupon-qr';
  static const String redemptionSuccess = '/redemption-success';
  static const String friends = '/friends';
  static const String friendRequests = '/friend-requests';
  static const String userProfile = '/user-profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String restaurantSignUpStep1 = '/restaurant-sign-up';
  static const String restaurantSignUpStep2 = '/restaurant-sign-up-2';
  static const String restaurantSignUpStep3 = '/restaurant-sign-up-3';
  static const String restaurantSignUpStep4 = '/restaurant-sign-up-4';
  static const String registrationPending = '/registration-pending';
  static const String registrationApproved = '/registration-approved';
  static const String registrationRejected = '/registration-rejected';
  static const String choosePlan = '/choose-plan';
  static const String restaurantDashboard = '/restaurant-dashboard';
  static const String restaurantCoupons = '/restaurant-coupons';
  static const String restaurantCouponForm = '/restaurant-coupon-form';
  static const String restaurantCouponDetail = '/restaurant-coupon-detail';
  static const String restaurantAccount = '/restaurant-account';
  static const String restaurantProfileManage = '/restaurant-profile-manage';
  static const String restaurantMenuManage = '/restaurant-menu-manage';
  static const String restaurantSubscription = '/restaurant-subscription';
  static const String restaurantStatistics = '/restaurant-statistics';
  static const String restaurantLoyalty = '/restaurant-loyalty';
  static const String restaurantGiveaways = '/restaurant-giveaways';
  static const String restaurantGiveawayForm = '/restaurant-giveaway-form';
  static const String restaurantGiveawayDetail = '/restaurant-giveaway-detail';
  static const String restaurantRewardForm = '/restaurant-reward-form';
  static const String restaurantSettings = '/restaurant-settings';
  static const String restaurantNotifications = '/restaurant-notifications';
  static const String restaurantScanner = '/restaurant-scanner';
  static const String restaurantScanResult = '/restaurant-scan-result';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case language:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const LanguagePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case login:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, secondaryAnimation) => const LoginPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case home:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case accountType:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const AccountTypePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case customerSignUp:
        return MaterialPageRoute<void>(
          builder: (_) => const CustomerSignUpPage(),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );
      case checkEmail:
        return MaterialPageRoute<void>(
          builder: (_) => const CheckEmailPage(),
          settings: settings,
        );
      case newPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const NewPasswordPage(),
          settings: settings,
        );
      case passwordUpdated:
        return MaterialPageRoute<void>(
          builder: (_) => const PasswordUpdatedPage(),
          settings: settings,
        );
      case locationPermission:
        return MaterialPageRoute<void>(
          builder: (_) => const LocationPermissionPage(),
          settings: settings,
        );
      case notificationPermission:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationPermissionPage(),
          settings: settings,
        );
      case legal:
        return MaterialPageRoute<void>(
          builder: (_) => const LegalPage(),
          settings: settings,
        );
      case restaurantList:
        final title = settings.arguments as String? ?? 'Italian restaurants';
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantListPage(title: title),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case search:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) => const SearchPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
        );
      case restaurantDetail:
        int initialTabIndex = 0;
        String name = 'Trattoria Nonna Rosa';
        if (settings.arguments is int) {
          initialTabIndex = settings.arguments as int;
        } else if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          initialTabIndex = map['initialTabIndex'] as int? ?? 0;
          name = map['restaurantName'] as String? ?? 'Trattoria Nonna Rosa';
        }
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantDetailPage(
            initialTabIndex: initialTabIndex,
            restaurantName: name,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantTabs:
        int tabIndex = 1; // Default to Coupons tab (Image 3)
        String rName = 'Trattoria Nonna Rosa';
        if (settings.arguments is int) {
          tabIndex = settings.arguments as int;
        } else if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          tabIndex = map['initialTabIndex'] as int? ?? 1;
          rName = map['restaurantName'] as String? ?? 'Trattoria Nonna Rosa';
        }
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantTabbedPage(
            initialTabIndex: tabIndex,
            restaurantName: rName,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case map:
        final selectedName = settings.arguments as String?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              MapPage(initialSelectedName: selectedName),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case categories:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const CategoriesPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case profile:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const ProfilePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case editProfile:
        final profileBloc = settings.arguments is ProfileBloc
            ? settings.arguments as ProfileBloc
            : null;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              EditProfilePage(profileBloc: profileBloc),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case myRewards:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const MyRewardsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case loyaltyDetail:
        final restaurantId = settings.arguments as String?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              LoyaltyDetailPage(restaurantId: restaurantId),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case rewardRedeemed:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RewardRedeemedPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case couponHistory:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const CouponHistoryPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case myGiveaways:
        int? tabIndex;
        bool? showBackButton;
        if (settings.arguments is int) {
          tabIndex = settings.arguments as int;
        } else if (settings.arguments is Map) {
          final map = settings.arguments as Map;
          tabIndex = map['tab'] as int? ?? map['initialTab'] as int?;
          showBackButton = map['showBackButton'] as bool?;
        }
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              MyGiveawaysPage(
                initialTab: tabIndex,
                showBackButton: showBackButton,
              ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case reviewDetail:
        final reviewData = settings.arguments as Map<String, dynamic>?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              ReviewDetailPage(reviewData: reviewData),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case favoriteRestaurants:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const FavoriteRestaurantsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case favoriteCoupons:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const FavoriteCouponsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case couponDetail:
        Widget couponPage;
        if (settings.arguments is CouponModel) {
          couponPage = CouponDetailPage.fromCoupon(
            settings.arguments as CouponModel,
          );
        } else if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          couponPage = CouponDetailPage(
            title: args['title'] as String? ?? '20% off your whole bill',
            discountVal: args['discountVal'] as String? ?? '20% OFF',
            typeName: args['typeName'] as String? ?? 'Percentage discount',
            restaurantName:
                args['restaurantName'] as String? ?? 'Trattoria Nonna Rosa',
            distance: args['distance'] as String? ?? '1.2 km',
            logoText: args['logoText'] as String? ?? 'NR',
            isAvailable: args['isAvailable'] as bool? ?? true,
            statusText: args['statusText'] as String? ?? 'Available',
            unavailableReason:
                args['unavailableReason'] as String? ?? 'Available from 12:00',
            unavailableSubtext: args['unavailableSubtext'] as String? ??
                'This coupon can be redeemed Mon–Sun, 12:00–22:00.',
            requirement:
                args['requirement'] as String? ?? 'Minimum spend 5,000 HUF',
            validDateText: args['validDateText'] as String? ??
                'Valid 1 Oct – 31 Oct 2026',
          );
        } else {
          couponPage = const CouponDetailPage();
        }
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) => couponPage,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case couponQr:
        final args = settings.arguments as Map<String, dynamic>?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) => CouponQrPage(
            restaurant: args?['restaurant'] as String?,
            discount: args?['discount'] as String?,
            title: args?['title'] as String?,
            openRedemptionSuccess: args?['openRedemptionSuccess'] as bool? ?? false,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case redemptionSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) => RedemptionSuccessPage(
            restaurant: args?['restaurant'] as String?,
            coupon: args?['coupon'] as String?,
            redeemed: args?['redeemed'] as String?,
            loyaltyPoints: args?['loyaltyPoints'] as String?,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case friends:
        final tabIndex = settings.arguments as int?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              FriendsPage(initialTab: tabIndex ?? 0),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case friendRequests:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const FriendsPage(initialTab: 1),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case userProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) => UserProfilePage(
            name: args?['name'] as String?,
            initials: args?['initials'] as String?,
            subtitle: args?['subtitle'] as String?,
            avatarBg: args?['avatarBg'] as Color?,
            avatarColor: args?['avatarColor'] as Color?,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case notifications:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const NotificationsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case AppRoutes.settings:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const SettingsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSignUpStep1:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantStep1Page(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSignUpStep2:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantStep2Page(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSignUpStep3:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantStep3Page(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSignUpStep4:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantStep4Page(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case registrationPending:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RegistrationPendingPage(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case registrationApproved:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RegistrationApprovedPage(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case registrationRejected:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RegistrationRejectedPage(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case choosePlan:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              ChoosePlanPage(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantDashboard:
        RestaurantRegistrationData? data;
        int initialTab = 0;
        if (settings.arguments is RestaurantRegistrationData) {
          data = settings.arguments as RestaurantRegistrationData;
        } else if (settings.arguments is int) {
          initialTab = settings.arguments as int;
        } else if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          data = map['data'] as RestaurantRegistrationData?;
          initialTab = map['initialTab'] as int? ?? 0;
        }
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantDashboardPage(data: data, initialTab: initialTab),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantCoupons:
        final initialTab = settings.arguments as int? ?? 0;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantCouponsPage(initialTab: initialTab),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantAccount:
        final data = settings.arguments as RestaurantRegistrationData?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantAccountPage(data: data),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantCouponForm:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantCouponFormPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantCouponDetail:
        final detailArgs = settings.arguments is RestaurantCouponDetailArgs
            ? settings.arguments as RestaurantCouponDetailArgs
            : const RestaurantCouponDetailArgs();
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantCouponDetailPage(args: detailArgs),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantScanner:
        final animate = settings.arguments is bool ? settings.arguments as bool : true;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantScannerPage(animate: animate),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantScanResult:
        final resultArgs = settings.arguments is RestaurantScanResultArgs
            ? settings.arguments as RestaurantScanResultArgs
            : const RestaurantScanResultArgs();
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantScanResultPage(args: resultArgs),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantMenuManage:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantMenuManagePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSubscription:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantSubscriptionPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantStatistics:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantStatisticsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantLoyalty:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantLoyaltyPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantGiveaways:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantGiveawaysPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantGiveawayForm:
        final initialItem = settings.arguments as GiveawayItem?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantGiveawayFormPage(initialItem: initialItem),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantGiveawayDetail:
        final giveaway = settings.arguments as GiveawayItem?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantGiveawayDetailPage(giveaway: giveaway),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantRewardForm:
        final existingReward = settings.arguments as LoyaltyRewardItem?;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              RestaurantRewardFormPage(existingReward: existingReward),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantSettings:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantSettingsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantNotifications:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantNotificationsPage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      case restaurantProfileManage:
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, secondaryAnimation) =>
              const RestaurantProfileManagePage(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }
}
