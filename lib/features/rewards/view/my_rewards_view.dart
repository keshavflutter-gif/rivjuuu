import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/home/widgets/home_bottom_nav_widget.dart';
import 'package:rivjuuu/features/rewards/bloc/rewards_bloc.dart';
import 'package:rivjuuu/features/rewards/bloc/rewards_event.dart';
import 'package:rivjuuu/features/rewards/bloc/rewards_state.dart';
import 'package:rivjuuu/features/rewards/view/loyalty_detail_view.dart';
import 'package:rivjuuu/features/rewards/widgets/my_rewards_card_widget.dart';

class MyRewardsView extends StatefulWidget {
  const MyRewardsView({super.key});

  @override
  State<MyRewardsView> createState() => _MyRewardsViewState();
}

class _MyRewardsViewState extends State<MyRewardsView> {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 8,
                ),
                child: Text(
                  'My rewards',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              // Scrollable body
              Expanded(
                child: BlocBuilder<RewardsBloc, RewardsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      key: const PageStorageKey<String>('customer_rewards_scroll_view'),
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Intro strip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBF1DF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.storefront_outlined,
                                  size: 18,
                                  color: Color(0xFFFE552E),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Your restaurant rewards. Points stay with the restaurant where you earned them.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF5A4525),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Section: Reward available
                          if (state.availableRewards.isNotEmpty) ...[
                            Text(
                              'REWARD AVAILABLE',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF71717A),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...state.availableRewards.map(
                              (card) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: MyRewardsCardWidget(
                                  model: card,
                                  onTap: () => _navigateToLoyalty(context, card.id),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],

                          // Section: Collecting
                          if (state.collectingRewards.isNotEmpty) ...[
                            Text(
                              'COLLECTING',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF71717A),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...state.collectingRewards.map(
                              (card) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: MyRewardsCardWidget(
                                  model: card,
                                  onTap: () => _navigateToLoyalty(context, card.id),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Bottom Navigation Bar (Rewards tab is index 2)
        bottomNavigationBar: HomeBottomNavWidget(
          currentIndex: 2,
          onNavTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
            } else if (index == 1) {
              Navigator.of(context).pushNamed(AppRoutes.categories);
            } else if (index == 4) {
              Navigator.of(context).pushNamed(AppRoutes.profile);
            }
          },
        ),
      ),
    );
  }

  void _navigateToLoyalty(BuildContext context, String restaurantId) {
    context.read<RewardsBloc>().add(SelectRestaurantLoyaltyEvent(restaurantId));
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, secondaryAnimation) => BlocProvider.value(
          value: context.read<RewardsBloc>(),
          child: const LoyaltyDetailView(),
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
      ),
    );
  }
}

