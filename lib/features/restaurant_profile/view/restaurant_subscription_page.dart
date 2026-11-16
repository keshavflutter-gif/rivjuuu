import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Restaurant Subscription page matching [subscription.html] and [subscription-change.html]
class RestaurantSubscriptionPage extends StatefulWidget {
  final String currentPlan;
  final String priceMonthly;
  final int usedCoupons;
  final int totalCoupons;
  final String renewalDate;

  const RestaurantSubscriptionPage({
    super.key,
    this.currentPlan = 'Growth',
    this.priceMonthly = '19,990',
    this.usedCoupons = 4,
    this.totalCoupons = 10,
    this.renewalDate = '14 Nov 2026',
  });

  @override
  State<RestaurantSubscriptionPage> createState() =>
      _RestaurantSubscriptionPageState();
}

class _RestaurantSubscriptionPageState
    extends State<RestaurantSubscriptionPage> {
  late String _plan;
  late String _price;
  late int _usedCoupons;
  late int _totalCoupons;
  late String _renewalDate;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _plan = widget.currentPlan;
    _price = widget.priceMonthly;
    _usedCoupons = widget.usedCoupons;
    _totalCoupons = widget.totalCoupons;
    _renewalDate = widget.renewalDate;
  }

  void _openChangePlanSheet() {
    HapticFeedback.selectionClick();
    String selectedPlan = _plan;

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Head (.bsheet__head)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Change plan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.cream,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Plan Option 1: Starter (.vis)
                    _buildPlanOption(
                      title: 'Starter · 9,990 HUF',
                      subtitle: '3 coupons · no giveaways',
                      planValue: 'Starter',
                      selectedPlan: selectedPlan,
                      onTap: () => setSheetState(() => selectedPlan = 'Starter'),
                    ),
                    const SizedBox(height: 10),

                    // Plan Option 2: Growth (.vis)
                    _buildPlanOption(
                      title: 'Growth · 19,990 HUF',
                      subtitle: 'Current plan · 10 coupons · 2 giveaways',
                      planValue: 'Growth',
                      selectedPlan: selectedPlan,
                      onTap: () => setSheetState(() => selectedPlan = 'Growth'),
                    ),
                    const SizedBox(height: 10),

                    // Plan Option 3: Pro (.vis)
                    _buildPlanOption(
                      title: 'Pro · 34,990 HUF',
                      subtitle: 'Unlimited coupons · featured on Home',
                      planValue: 'Pro',
                      selectedPlan: selectedPlan,
                      onTap: () => setSheetState(() => selectedPlan = 'Pro'),
                    ),
                    const SizedBox(height: 14),

                    // Legal note
                    Text(
                      'Changes apply from your next billing date unless the final payment policy says otherwise.',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        height: 17 / 11.5,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Confirm change button (.btn)
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _plan = selectedPlan;
                            if (_plan == 'Starter') {
                              _price = '9,990';
                              _totalCoupons = 3;
                            } else if (_plan == 'Growth') {
                              _price = '19,990';
                              _totalCoupons = 10;
                            } else {
                              _price = '34,990';
                              _totalCoupons = 25;
                            }
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Plan switched to $_plan successfully',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: AppColors.navy,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 1800),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Confirm change',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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

  Widget _buildPlanOption({
    required String title,
    required String subtitle,
    required String planValue,
    required String selectedPlan,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedPlan == planValue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFAF7) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.coral : AppColors.line,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.coral : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.coral : const Color(0xFFCFCBC5),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation() {
    HapticFeedback.selectionClick();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Cancel subscription?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          content: Text(
            'Your coupons and perks will remain active until $_renewalDate. After this date, your subscription will not renew.',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Keep subscription',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _isActive = false;
                });
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Subscription will cancel on $_renewalDate',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(0xFFFE552E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Cancel plan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFE552E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_usedCoupons / _totalCoupons).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top Bar (.bar, style="padding-top: 4px")
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (.round)
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
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

                  // Title (.bar__title)
                  Text(
                    'Subscription',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),

                  // Spacer for centered title (.spacer)
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Scrollable content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Current Plan Card (.loy, style="gap: 12px")
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F18181B),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top row: Current plan label & status badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current plan',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.72),
                                ),
                              ),
                              Container(
                                height: 22,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: _isActive
                                      ? const Color(0x2E49D17D) // rgba(73,209,125,.18)
                                      : const Color(0x2EFE552E),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Center(
                                  child: Text(
                                    _isActive ? 'Active' : 'Cancelling',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _isActive
                                          ? const Color(0xFF7BE3A3)
                                          : const Color(0xFFFF9580),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Price row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _plan,
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  height: 32 / 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _price,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'HUF / month',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.72),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Usage progress bar (.loy__bar)
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: constraints.maxWidth * progress,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.coral,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Usage text (.loy__next)
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                height: 19 / 13,
                                color: Colors.white.withValues(alpha: 0.86),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '$_usedCoupons of $_totalCoupons active coupons used · Renews ',
                                ),
                                TextSpan(
                                  text: _renewalDate,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 2. Included Features Card (.sec-card)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Included',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildFeatureItem('Up to 10 active coupons'),
                          const SizedBox(height: 7),
                          _buildFeatureItem('2 giveaways per month'),
                          const SizedBox(height: 7),
                          _buildFeatureItem('Highlighted in your category'),
                          const SizedBox(height: 7),
                          _buildFeatureItem('Full statistics'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 3. Billing Card (.sec-card)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Billing',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Payment method up to date',
                                        style: GoogleFonts.poppins(fontSize: 13),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.coral,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Row 1: Payment method (.inforow)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.credit_card_outlined,
                                  size: 20,
                                  color: AppColors.text,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment method',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          height: 20 / 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      Text(
                                        '•••• 4242 (Mastercard)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(color: AppColors.line, height: 1),

                          // Row 2: Last payment (.inforow)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  size: 20,
                                  color: AppColors.text,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last payment 14 Oct 2026',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          height: 20 / 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      Text(
                                        '$_price HUF · Invoice available',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 4. Change plan button (.btn)
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _openChangePlanSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Change plan',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 5. Cancel subscription button (.btn .btn--ghost)
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _showCancelConfirmation,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFE552E),
                          side: const BorderSide(color: AppColors.line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel subscription',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFE552E),
                          ),
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
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_rounded,
          size: 16,
          color: AppColors.coral,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 18 / 13,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}

