import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import '../bloc/rewards_state.dart';
import '../models/rewards_models.dart';
import '../widgets/loyalty_card_widget.dart';
import '../widgets/reward_activity_list_widget.dart';
import '../widgets/reward_item_widget.dart';
import '../widgets/reward_redeem_bottom_sheet.dart';
import 'reward_redeemed_view.dart';

class LoyaltyDetailView extends StatelessWidget {
  const LoyaltyDetailView({super.key});

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
          child: BlocBuilder<RewardsBloc, RewardsState>(
            builder: (context, state) {
              final detail = state.activeLoyaltyDetail;
              if (detail == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.white,
                          shape: const CircleBorder(
                            side: BorderSide(color: AppColors.line, width: 1),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 18,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            detail.restaurantName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Navy Loyalty Card
                          LoyaltyCardWidget(model: detail),

                          const SizedBox(height: 20),

                          // 2. Available Rewards Section
                          Text(
                            'Available rewards',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...detail.rewards.map(
                            (reward) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RewardItemWidget(
                                reward: reward,
                                onRedeem: () => _openRedeemSheet(
                                  context,
                                  detail,
                                  reward,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 3. Activity Section
                          Text(
                            'Activity',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RewardActivityListWidget(
                            activities: detail.activities,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openRedeemSheet(
    BuildContext context,
    LoyaltyDetailModel detail,
    LoyaltyRewardItemModel reward,
  ) {
    RewardRedeemBottomSheet.show(
      context: context,
      restaurantName: detail.restaurantName,
      reward: reward,
      currentPoints: detail.points,
      onConfirm: () {
        context.read<RewardsBloc>().add(
              RedeemRewardEvent(
                restaurantId: detail.id,
                rewardId: reward.id,
              ),
            );

        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (_, animation, secondaryAnimation) =>
                BlocProvider.value(
              value: context.read<RewardsBloc>(),
              child: const RewardRedeemedView(),
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
          ),
        );
      },
    );
  }
}

