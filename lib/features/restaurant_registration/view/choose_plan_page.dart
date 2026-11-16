import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../models/restaurant_registration_data.dart';

class ChoosePlanPage extends StatefulWidget {
  final RestaurantRegistrationData? data;

  const ChoosePlanPage({super.key, this.data});

  @override
  State<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  bool _isYearly = false;
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

  String _getPriceForPlan(String planName) {
    if (planName == 'Starter') {
      return _isYearly ? '8,490' : '9,990';
    } else if (planName == 'Growth') {
      return _isYearly ? '16,990' : '19,990';
    } else {
      return _isYearly ? '29,990' : '34,990';
    }
  }

  void _onSelectPlan(String planName) {
    final price = _getPriceForPlan(planName);
    final period = _isYearly ? 'Yearly' : 'Monthly';
    final renewsDate = _isYearly ? '14 Oct 2027' : '14 Nov 2026';
    String? paymentMethod;
    bool isSubscribing = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8D2C6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Sheet Title
                    Text(
                      'Confirm your plan',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plan Summary Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Plan', '$planName · $period'),
                          const Divider(height: 1, thickness: 1, color: AppColors.line),
                          _buildSummaryRow('Starts', 'Today, 14 Oct 2026'),
                          const Divider(height: 1, thickness: 1, color: AppColors.line),
                          _buildSummaryRow('Renews', renewsDate),
                          const Divider(height: 1, thickness: 1, color: AppColors.line),
                          _buildSummaryRow('Total today', '$price HUF'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Add Payment Method Box
                    GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          paymentMethod = paymentMethod == null
                              ? '•••• 4242 (Visa)'
                              : null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: paymentMethod != null
                                ? AppColors.navy
                                : AppColors.line,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.credit_card_outlined,
                              size: 19,
                              color: AppColors.navy,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                paymentMethod ?? 'Add payment method',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 19,
                              color: AppColors.text,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Disclaimer text
                    Text(
                      'Renews ${_isYearly ? 'yearly' : 'monthly'} until cancelled. Payment provider to be confirmed.',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.text,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subscribe button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSubscribing
                            ? null
                            : () async {
                                setSheetState(() => isSubscribing = true);
                                await Future<void>.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                if (!ctx.mounted) return;
                                Navigator.of(ctx).pop();
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.restaurantDashboard,
                                  arguments: widget.data,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSubscribing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Subscribe · $price HUF',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: Center(
                      child: Text(
                        'Choose a plan',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Pick a plan to publish coupons and reach more guests. You can change it any time.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.text,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Monthly / Yearly toggle pill
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1ECE1),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Monthly
                            GestureDetector(
                              onTap: () => setState(() => _isYearly = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isYearly
                                      ? AppColors.navy
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  'Monthly',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: !_isYearly
                                        ? Colors.white
                                        : AppColors.navy,
                                  ),
                                ),
                              ),
                            ),
                            // Yearly -15%
                            GestureDetector(
                              onTap: () => setState(() => _isYearly = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _isYearly
                                      ? AppColors.navy
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Yearly',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _isYearly
                                            ? Colors.white
                                            : AppColors.navy,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '-15%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.coral,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Plan 1: Starter
                    _buildStarterCard(),

                    const SizedBox(height: 28),

                    // Plan 2: Growth (Most Popular)
                    _buildGrowthCard(),

                    const SizedBox(height: 24),

                    // Plan 3: Pro
                    _buildProCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarterCard() {
    final price = _getPriceForPlan('Starter');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Name + Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Starter',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get listed and start with coupons',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    'HUF / month',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Checklist
          _buildCheckItem('Up to 3 active coupons', isIncluded: true),
          _buildCheckItem('Loyalty program', isIncluded: true),
          _buildCheckItem('Basic statistics', isIncluded: true),
          _buildCheckItem('Giveaways', isIncluded: false),
          _buildCheckItem('Highlighted placement', isIncluded: false),

          const SizedBox(height: 20),

          // Choose plan button (outlined)
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => _onSelectPlan('Starter'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Choose plan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard() {
    final price = _getPriceForPlan('Growth');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.coral, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.coral.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: Name + Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Growth',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'More coupons and giveaways',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        'HUF / month',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Checklist
              _buildCheckItem('Up to 10 active coupons', isIncluded: true),
              _buildCheckItem('Loyalty program', isIncluded: true),
              _buildCheckItem('2 giveaways per month', isIncluded: true),
              _buildCheckItem('Full statistics', isIncluded: true),
              _buildCheckItem('Highlighted in your category', isIncluded: true),

              const SizedBox(height: 20),

              // Choose plan button (solid coral)
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _onSelectPlan('Growth'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Choose plan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // MOST POPULAR badge sitting over top border
        Positioned(
          top: -12,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'MOST POPULAR',
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProCard() {
    final price = _getPriceForPlan('Pro');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Name + Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pro',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All-inclusive restaurant growth',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    'HUF / month',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Checklist
          _buildCheckItem('Unlimited active coupons', isIncluded: true),
          _buildCheckItem('Loyalty program', isIncluded: true),
          _buildCheckItem('Unlimited giveaways', isIncluded: true),
          _buildCheckItem('Full statistics & exports', isIncluded: true),
          _buildCheckItem(
            'Highlighted in search & category',
            isIncluded: true,
          ),

          const SizedBox(height: 20),

          // Choose plan button (outlined)
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => _onSelectPlan('Pro'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Choose plan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, {required bool isIncluded}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isIncluded ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: isIncluded ? AppColors.coral : AppColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isIncluded ? AppColors.navy : AppColors.muted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
