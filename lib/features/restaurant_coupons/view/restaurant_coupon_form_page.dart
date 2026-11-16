import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import 'restaurant_coupon_detail_page.dart';

class RestaurantCouponFormPage extends StatefulWidget {
  const RestaurantCouponFormPage({super.key});

  @override
  State<RestaurantCouponFormPage> createState() => _RestaurantCouponFormPageState();
}

class _RestaurantCouponFormPageState extends State<RestaurantCouponFormPage> {
  int _selectedTypeIndex = 0; // 0 = Percentage

  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _discountController;
  late final TextEditingController _minPurchaseController;
  late final TextEditingController _termsController;


  int _usesPerCustomer = 1;
  int _pointsAfterRedemption = 40;
  bool _firstTimeOnly = false;
  bool _publishActive = true;

  final Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6}; // Mon-Sun all on by default

  final List<_CouponTypeOption> _couponTypes = const [
    _CouponTypeOption(
      label: 'Percentage',
      icon: Icons.percent_rounded,
      typeTag: 'DISCOUNT',
      defaultTitle: '20% off your whole bill',
      defaultDesc: 'Get 20% off the food on your bill when you dine in.',
      defaultDiscount: '20',
      discountSuffix: '%',
      stubLabel: 'OFF',
    ),
    _CouponTypeOption(
      label: 'Fixed value',
      icon: Icons.confirmation_number_outlined,
      typeTag: 'FIXED VALUE',
      defaultTitle: '2,000 HUF off your bill',
      defaultDesc: 'Get 2,000 HUF discount on your bill.',
      defaultDiscount: '2,000',
      discountSuffix: 'HUF',
      stubLabel: 'HUF',
    ),
    _CouponTypeOption(
      label: 'Gift item',
      icon: Icons.card_giftcard_rounded,
      typeTag: 'GIFT ITEM',
      defaultTitle: 'Free tiramisu with any main',
      defaultDesc: 'One free dessert per table when ordering a main course.',
      defaultDiscount: '1',
      discountSuffix: 'item',
      stubLabel: 'GIFT',
    ),
    _CouponTypeOption(
      label: '1+1',
      icon: Icons.add_rounded,
      typeTag: 'BUY ONE, GET ONE',
      defaultTitle: 'Second Margherita free',
      defaultDesc: 'Buy one Margherita pizza, get the second one free.',
      defaultDiscount: '1',
      discountSuffix: 'deal',
      stubLabel: 'DEAL',
    ),
    _CouponTypeOption(
      label: 'Menu deal',
      icon: Icons.restaurant_rounded,
      typeTag: 'MENU DEAL',
      defaultTitle: '3-course dinner menu for two',
      defaultDesc: 'Special chef tasting selection menu for two guests.',
      defaultDiscount: '1',
      discountSuffix: 'deal',
      stubLabel: 'MENU',
    ),
    _CouponTypeOption(
      label: 'Flash sale',
      icon: Icons.bolt_rounded,
      typeTag: 'FLASH SALE',
      defaultTitle: 'Flash 30% off this evening',
      defaultDesc: 'Valid for dinner service tonight only.',
      defaultDiscount: '30',
      discountSuffix: '%',
      stubLabel: 'FLASH',
    ),
    _CouponTypeOption(
      label: 'Seasonal',
      icon: Icons.calendar_today_rounded,
      typeTag: 'SEASONAL',
      defaultTitle: 'Autumn truffle pasta deal',
      defaultDesc: 'Try our seasonal specialty with 15% discount.',
      defaultDiscount: '15',
      discountSuffix: '%',
      stubLabel: 'SEASON',
    ),
    _CouponTypeOption(
      label: 'First-time',
      icon: Icons.person_outline_rounded,
      typeTag: 'FIRST-TIME',
      defaultTitle: 'Welcome 15% off first visit',
      defaultDesc: 'Valid for all first-time guests dining in.',
      defaultDiscount: '15',
      discountSuffix: '%',
      stubLabel: 'NEW',
    ),
    _CouponTypeOption(
      label: 'Happy hour',
      icon: Icons.access_time_rounded,
      typeTag: 'HAPPY HOUR',
      defaultTitle: 'Aperol Spritz for 1,290 HUF',
      defaultDesc: 'Special cocktail price between 16:00 and 19:00.',
      defaultDiscount: '1,290',
      discountSuffix: 'HUF',
      stubLabel: 'HAPPY',
    ),
    _CouponTypeOption(
      label: 'Secret menu',
      icon: Icons.lock_outline_rounded,
      typeTag: 'SECRET MENU',
      defaultTitle: 'Secret chef tasting dessert',
      defaultDesc: 'Mention this secret coupon to unlock the off-menu dish.',
      defaultDiscount: '1',
      discountSuffix: 'item',
      stubLabel: 'SECRET',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: '20% off your whole bill');
    _descController = TextEditingController(
      text: 'Get 20% off the food on your bill when you dine in.',
    );
    _discountController = TextEditingController(text: '20');
    _minPurchaseController = TextEditingController(text: '5,000');
    _termsController = TextEditingController(
      text: 'Dine-in only. Cannot be combined with other coupons. Drinks not included.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _discountController.dispose();
    _minPurchaseController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _onPublish() {
    final discountSuffix = _couponTypes[_selectedTypeIndex].discountSuffix;
    final discountValRaw = _discountController.text.trim();
    final discountDisplay = discountSuffix == '%'
        ? '$discountValRaw% OFF'
        : (discountSuffix == 'HUF' ? '$discountValRaw HUF' : '$discountValRaw $discountSuffix');

    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : '20% off your whole bill';

    String shortTitle;
    if (title.trim() == '20% off your whole bill' ||
        title.toLowerCase() == '20% off your whole bill') {
      shortTitle = '20% off your bill';
    } else if (title.toLowerCase().contains('whole bill')) {
      shortTitle = title.replaceAll(RegExp(r'whole\s+bill', caseSensitive: false), 'bill');
    } else if (title.length > 25) {
      shortTitle = '${title.substring(0, 24)}...';
    } else {
      shortTitle = title;
    }

    final rawTypeLabel = _couponTypes[_selectedTypeIndex].label;
    final typeTag = rawTypeLabel == 'Percentage'
        ? 'Percentage discount'
        : rawTypeLabel;

    final detailArgs = RestaurantCouponDetailArgs(
      title: title,
      shortTitle: shortTitle,
      typeTag: typeTag,
      discountVal: discountDisplay,
      validity: _publishActive
          ? 'Active · 1 Oct – 31 Oct 2026'
          : 'Inactive · 1 Oct – 31 Oct 2026',
      minSpend: 'Minimum spend ${_minPurchaseController.text.trim().isNotEmpty ? _minPurchaseController.text.trim() : "5,000"} HUF',
      hours: 'Mon–Sun, 12:00–22:00',
      frequency: 'Once per customer',
      points: '+$_pointsAfterRedemption loyalty points',
      viewsCount: '3,480',
      viewsDelta: '+18%',
      redemptionsCount: '142',
      redemptionsDelta: '+9%',
      redemptionRate: '4.1%',
      repeatGuests: '38',
      initialActive: _publishActive,
    );

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.restaurantCouponDetail,
      arguments: detailArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar (.bar)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                        'Create coupon',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42), // Balance back button
                ],
              ),
            ),

            // Scrollable form sections
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  children: [
                    // Section 1: Coupon type
                    _buildSectionCard(
                      stepNumber: '1',
                      title: 'Coupon type',
                      child: _buildCouponTypeGrid(),
                    ),

                    const SizedBox(height: 12),

                    // Section 2: Details
                    _buildSectionCard(
                      stepNumber: '2',
                      title: 'Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Coupon title'),
                          const SizedBox(height: 8),
                          _buildTextInput(controller: _titleController),
                          const SizedBox(height: 14),
                          _buildFieldLabel('Description'),
                          const SizedBox(height: 8),
                          _buildTextArea(controller: _descController, maxLines: 2),
                          const SizedBox(height: 14),
                          _buildFieldLabel('Discount'),
                          const SizedBox(height: 8),
                          _buildTextInput(
                            controller: _discountController,
                            suffix: _couponTypes[_selectedTypeIndex].discountSuffix,
                            keyboardType: _selectedTypeIndex == 0 ? TextInputType.number : TextInputType.text,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 3: Validity
                    _buildSectionCard(
                      stepNumber: '3',
                      title: 'Validity',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('Start date'),
                                    const SizedBox(height: 6),
                                    _buildSelectField('1 Oct 2026', Icons.calendar_today_rounded),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('End date'),
                                    const SizedBox(height: 6),
                                    _buildSelectField('31 Oct 2026', Icons.calendar_today_rounded),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel('Available days'),
                          const SizedBox(height: 6),
                          _buildDaysSelector(),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('From'),
                                    const SizedBox(height: 6),
                                    _buildSelectField('12:00', Icons.access_time_rounded),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('Until'),
                                    const SizedBox(height: 6),
                                    _buildSelectField('22:00', Icons.access_time_rounded),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 4: Rules
                    _buildSectionCard(
                      stepNumber: '4',
                      title: 'Rules',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Minimum purchase'),
                          const SizedBox(height: 8),
                          _buildTextInput(
                            controller: _minPurchaseController,
                            suffix: 'HUF',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildToggleRow(
                            title: 'Uses per customer',
                            subtitle: 'How often one guest can redeem it',
                            trailing: _buildStepper(
                              value: _usesPerCustomer,
                              onMinus: () {
                                if (_usesPerCustomer > 1) {
                                  setState(() => _usesPerCustomer--);
                                }
                              },
                              onPlus: () {
                                setState(() => _usesPerCustomer++);
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildToggleRow(
                            title: 'Total redemptions',
                            subtitle: 'Leave unlimited or set a cap',
                            trailing: Text(
                              'Unlimited',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildToggleRow(
                            title: 'First-time guests only',
                            trailing: _buildSwitch(
                              value: _firstTimeOnly,
                              onChanged: (val) {
                                setState(() => _firstTimeOnly = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel('Terms and conditions'),
                          const SizedBox(height: 8),
                          _buildTextArea(controller: _termsController, maxLines: 3),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 5: Loyalty
                    _buildSectionCard(
                      stepNumber: '5',
                      title: 'Loyalty',
                      child: _buildToggleRow(
                        title: 'Points after redemption',
                        subtitle: 'Earned at Trattoria Nonna Rosa only',
                        trailing: _buildStepper(
                          value: _pointsAfterRedemption,
                          onMinus: () {
                            if (_pointsAfterRedemption > 5) {
                              setState(() => _pointsAfterRedemption -= 5);
                            }
                          },
                          onPlus: () {
                            setState(() => _pointsAfterRedemption += 5);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 6: Status & preview
                    _buildSectionCard(
                      stepNumber: '6',
                      title: 'Status & preview',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildToggleRow(
                            title: 'Publish as active',
                            subtitle: 'Guests can see it right away',
                            trailing: _buildSwitch(
                              value: _publishActive,
                              onChanged: (val) {
                                setState(() => _publishActive = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'CUSTOMER PREVIEW',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.72,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildCustomerPreviewTicket(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA (.stickycta)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onPublish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: AppColors.coral.withValues(alpha: 0.22),
                      ),
                      child: Text(
                        'Publish coupon',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String stepNumber,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildCouponTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _couponTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 48,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = _couponTypes[index];
        final isSelected = _selectedTypeIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTypeIndex = index;
              final opt = _couponTypes[index];
              _titleController.text = opt.defaultTitle;
              _descController.text = opt.defaultDesc;
              _discountController.text = opt.defaultDiscount;
            });
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF4EF) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.coral : AppColors.line,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: isSelected ? AppColors.coral : AppColors.text,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: AppColors.navy,
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
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.navy,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: AppColors.navy,
      ),
      cursorColor: AppColors.coral,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1.0,
                  child: Text(
                    suffix,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    int maxLines = 2,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.navy,
      ),
      cursorColor: AppColors.coral,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildSelectField(String text, IconData icon) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.navy,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 18, color: AppColors.text),
        ],
      ),
    );
  }

  Widget _buildDaysSelector() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      children: List.generate(7, (index) {
        final isOn = _selectedDays.contains(index);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 6 ? 0 : 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isOn) {
                    _selectedDays.remove(index);
                  } else {
                    _selectedDays.add(index);
                  }
                });
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: isOn ? AppColors.navy : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOn ? AppColors.navy : AppColors.line,
                  ),
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOn ? Colors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildToggleRow({
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: AppColors.text,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }

  Widget _buildStepper({
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onMinus,
            child: Container(
              width: 44,
              height: 44,
              color: AppColors.cream,
              child: const Icon(Icons.remove, size: 16, color: AppColors.navy),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 54),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          GestureDetector(
            onTap: onPlus,
            child: Container(
              width: 44,
              height: 44,
              color: AppColors.cream,
              child: const Icon(Icons.add, size: 16, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 28,
        decoration: BoxDecoration(
          color: value ? AppColors.coral : const Color(0xFFE4DDD0),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerPreviewTicket() {
    final currentType = _couponTypes[_selectedTypeIndex];
    final title = _titleController.text.trim().isEmpty
        ? currentType.defaultTitle
        : _titleController.text.trim();
    final discountVal = _discountController.text.trim().isEmpty
        ? currentType.defaultDiscount
        : _discountController.text.trim();
    final minPurchaseVal = _minPurchaseController.text.trim().isEmpty
        ? '5,000'
        : _minPurchaseController.text.trim();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left value coupon stub (.tk__val)
                Container(
                  width: 88,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedTypeIndex == 0) ...[
                        Text(
                          '$discountVal%',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            height: 26 / 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.48,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'OFF',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            height: 14 / 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.63,
                            color: Colors.white,
                          ),
                        ),
                      ] else if (_selectedTypeIndex == 1) ...[
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            discountVal,
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'HUF OFF',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ] else if (_selectedTypeIndex == 3) ...[
                        Text(
                          '1+1',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.48,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'DEAL',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.63,
                            color: Colors.white,
                          ),
                        ),
                      ] else ...[
                        Icon(currentType.icon, size: 26, color: Colors.white),
                        const SizedBox(height: 2),
                        Text(
                          currentType.stubLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Dashed border line & right body (.tk__body)
                Expanded(
                  child: CustomPaint(
                    painter: const _VerticalDashedLinePainter(
                      color: Color(0xFFE3DACB),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentType.typeTag,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 15 / 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.55,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                  color: AppColors.navy,
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Minimum spend $minPurchaseVal HUF',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  height: 16 / 11.5,
                                  letterSpacing: -0.1,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Trattoria Nonna Rosa',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    height: 16 / 11,
                                    letterSpacing: -0.2,
                                    color: AppColors.text,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Until 31 Oct',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 16 / 11,
                                  letterSpacing: -0.2,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Top Notch Cutout (.tk__val::before)
            Positioned(
              left: 80,
              top: -8,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line),
                ),
              ),
            ),

            // Bottom Notch Cutout (.tk__val::after)
            Positioned(
              left: 80,
              bottom: -8,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponTypeOption {
  final String label;
  final IconData icon;
  final String typeTag;
  final String defaultTitle;
  final String defaultDesc;
  final String defaultDiscount;
  final String discountSuffix;
  final String stubLabel;

  const _CouponTypeOption({
    required this.label,
    required this.icon,
    required this.typeTag,
    required this.defaultTitle,
    required this.defaultDesc,
    required this.defaultDiscount,
    required this.discountSuffix,
    required this.stubLabel,
  });
}

class _VerticalDashedLinePainter extends CustomPainter {
  final Color color;

  const _VerticalDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 8.0;

    while (startY < size.height - 8.0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalDashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
