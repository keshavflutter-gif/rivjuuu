import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_state.dart';
import '../widgets/circular_dish_widget.dart';
import '../widgets/splash_branding_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _topLeftSlide;
  late final Animation<Offset> _topRightSlide;
  late final Animation<Offset> _bottomLeftSlide;
  late final Animation<Offset> _bottomRightSlide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    final curved = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(curved);

    _topLeftSlide = Tween<Offset>(
      begin: const Offset(-0.35, -0.35),
      end: Offset.zero,
    ).animate(curved);

    _topRightSlide = Tween<Offset>(
      begin: const Offset(0.35, -0.35),
      end: Offset.zero,
    ).animate(curved);

    _bottomLeftSlide = Tween<Offset>(
      begin: const Offset(-0.35, 0.35),
      end: Offset.zero,
    ).animate(curved);

    _bottomRightSlide = Tween<Offset>(
      begin: const Offset(0.35, 0.35),
      end: Offset.zero,
    ).animate(curved);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final scale = (screenSize.width / 390.0).clamp(0.85, 1.25);

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status == SplashStatus.authenticated) {
          // Persistent login: session exists, navigate directly to customer home
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state.status == SplashStatus.authenticatedRestaurant) {
          // Persistent login: restaurant is approved, navigate directly to dashboard
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.restaurantDashboard,
            arguments: state.restaurantData,
          );
        } else if (state.status == SplashStatus.authenticatedRestaurantPending) {
          // Persistent login: restaurant is pending approval, navigate to pending screen
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.registrationPending,
            arguments: state.restaurantData,
          );
        } else if (state.status == SplashStatus.authenticatedRestaurantRejected) {
          // Persistent login: restaurant rejected, navigate to rejected screen
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.registrationRejected,
            arguments: state.restaurantData,
          );
        } else if (state.status == SplashStatus.unauthenticatedWithLanguage) {
          // Language already chosen: navigate directly to login
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else if (state.status == SplashStatus.unauthenticated ||
            state.status == SplashStatus.completed) {
          // No session: navigate to language / onboarding flow
          Navigator.of(context).pushReplacementNamed(AppRoutes.language);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.cream,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // 4 Corner Decorative Food Dishes
              Positioned.fill(
                child: ClipRect(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Top-Left Dish
                      Positioned(
                        left: -84 * scale,
                        top: 34 * scale,
                        child: SlideTransition(
                          position: _topLeftSlide,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: CircularDishWidget(
                              assetPath: AppAssets.bowl,
                              size: 224 * scale,
                              alignment: const Alignment(0.0, 0.0),
                            ),
                          ),
                        ),
                      ),

                      // Top-Right Dish
                      Positioned(
                        right: -64 * scale,
                        top: 66 * scale,
                        child: SlideTransition(
                          position: _topRightSlide,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: CircularDishWidget(
                              assetPath: AppAssets.plate,
                              size: 196 * scale,
                              alignment: const Alignment(0.24, -0.84),
                            ),
                          ),
                        ),
                      ),

                      // Bottom-Left Dish
                      Positioned(
                        left: -86 * scale,
                        bottom: -30 * scale,
                        child: SlideTransition(
                          position: _bottomLeftSlide,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: CircularDishWidget(
                              assetPath: AppAssets.bowls,
                              size: 250 * scale,
                              alignment: const Alignment(0.0, 0.72),
                            ),
                          ),
                        ),
                      ),

                      // Bottom-Right Dish
                      Positioned(
                        right: -78 * scale,
                        bottom: 60 * scale,
                        child: SlideTransition(
                          position: _bottomRightSlide,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: CircularDishWidget(
                              assetPath: AppAssets.salad,
                              size: 232 * scale,
                              alignment: const Alignment(0.38, 0.50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Logo & Tagline
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20 * scale),
                      child: SplashBrandingWidget(scale: scale),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

