import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import 'restaurant_giveaways_page.dart';

/// Full-screen Create Giveaway Page
/// Matching batch-05-restaurant-app/html/giveaway-form.html & Image 3 reference
class RestaurantGiveawayFormPage extends StatefulWidget {
  final GiveawayItem? initialItem;

  const RestaurantGiveawayFormPage({
    super.key,
    this.initialItem,
  });

  @override
  State<RestaurantGiveawayFormPage> createState() =>
      _RestaurantGiveawayFormPageState();
}

class _RestaurantGiveawayFormPageState
    extends State<RestaurantGiveawayFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _prizeController;
  late final TextEditingController _rulesController;

  String _selectedPrizeType = 'Prize coupon · valid 30 days';
  String _startDate = '1 Oct 2026';
  String _endDate = '14 Oct 2026';
  int _winnersCount = 3;
  String _imagePath = 'assets/table.jpg';

  final List<String> _prizeTypes = const [
    'Prize coupon · valid 30 days',
    'Prize coupon · valid 14 days',
    'Free dining voucher',
    'Special tasting menu voucher',
  ];

  final List<String> _sampleImages = const [
    'assets/table.jpg',
    'assets/dining.jpg',
    'assets/pizza.jpg',
    'assets/dessert.jpg',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _titleController = TextEditingController(
      text: item?.title ?? 'Win dinner for two',
    );
    _descController = TextEditingController(
      text: item?.description ??
          'Celebrate autumn at Nonna Rosa. Three winners get a dinner for two.',
    );
    _prizeController = TextEditingController(
      text: item?.prize ?? '15,000 HUF dinner coupon',
    );
    _rulesController = TextEditingController(
      text: item != null && item.rules.isNotEmpty
          ? item.rules.join('\n')
          : 'Free to join, one entry per customer. Customers aged 18+. Staff can’t take part.',
    );
    if (item != null) {
      _selectedPrizeType = item.prizeType;
      _winnersCount = item.winnersCount;
      _imagePath = item.imagePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _prizeController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  void _changeImage() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Choose Giveaway Photo',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _sampleImages.map((img) {
                  final isCurrent = _imagePath == img;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _imagePath = img;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent ? AppColors.coral : AppColors.line,
                          width: isCurrent ? 2.5 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: AppColors.peach,
                          child: const Icon(
                            LucideIcons.utensils,
                            color: AppColors.coral,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectPrizeType() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Winners receive',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 10),
              ..._prizeTypes.map((type) {
                final isSelected = _selectedPrizeType == type;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: isSelected ? AppColors.coral : AppColors.text,
                    size: 20,
                  ),
                  title: Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.navy : AppColors.text,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedPrizeType = type;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    HapticFeedback.lightImpact();
    final initial = isStart ? DateTime(2026, 10, 1) : DateTime(2026, 10, 14);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2028, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.coral,
              onPrimary: Colors.white,
              onSurface: AppColors.navy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = '${picked.day} ${_monthName(picked.month)} ${picked.year}';
      setState(() {
        if (isStart) {
          _startDate = formatted;
        } else {
          _endDate = formatted;
        }
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  void _publishGiveaway() {
    HapticFeedback.mediumImpact();
    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : 'Win dinner for two';
    final prize = _prizeController.text.trim().isNotEmpty
        ? _prizeController.text.trim()
        : '15,000 HUF dinner coupon';
    final desc = _descController.text.trim();
    final rules = _rulesController.text
        .split('\n')
        .where((r) => r.trim().isNotEmpty)
        .toList();

    final newGiveaway = GiveawayItem(
      id: widget.initialItem?.id ??
          'gw_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: desc.isNotEmpty
          ? desc
          : 'Celebrate autumn at Nonna Rosa. Three winners get a dinner for two.',
      prize: prize,
      prizeType: _selectedPrizeType,
      dateRange: '$_startDate – $_endDate',
      participantsCount: widget.initialItem?.participantsCount ?? 1,
      winnersCount: _winnersCount,
      status: 'Active',
      statusColor: Colors.white,
      statusBg: AppColors.coral,
      imagePath: _imagePath,
      rules: rules.isNotEmpty
          ? rules
          : [
              'Free to join, one entry per customer.',
              'Customers aged 18+. Staff can’t take part.',
            ],
    );

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.restaurantGiveawayDetail,
      arguments: newGiveaway,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // Top App Bar (.bar) matching giveaway-form.html & Image 3
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
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
                          LucideIcons.arrowLeft,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Create giveaway',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  // Spacer to center title
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Scrollable Form Sections (.scroll)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Basics
                    _buildFormCard(
                      stepNumber: '1',
                      title: 'Basics',
                      children: [
                        // Upload Hero (.upload-hero)
                        GestureDetector(
                          onTap: _changeImage,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.line),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  _imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    color: AppColors.peach,
                                    child: const Center(
                                      child: Icon(
                                        LucideIcons.utensils,
                                        size: 40,
                                        color: AppColors.coral,
                                      ),
                                    ),
                                  ),
                                ),
                                // Change image pill button
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xF0FFFFFF),
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x1A000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          LucideIcons.camera,
                                          size: 14,
                                          color: AppColors.navy,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Change image',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.navy,
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

                        const SizedBox(height: 14),

                        // Giveaway title
                        _buildFieldLabel('Giveaway title'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _titleController,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(),
                        ),

                        const SizedBox(height: 14),

                        // Description
                        _buildFieldLabel('Description'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _descController,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Section 2: Prize
                    _buildFormCard(
                      stepNumber: '2',
                      title: 'Prize',
                      children: [
                        _buildFieldLabel('Prize'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _prizeController,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(),
                        ),

                        const SizedBox(height: 14),

                        _buildFieldLabel('Winners receive'),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _selectPrizeType,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.line),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedPrizeType,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  LucideIcons.chevronDown,
                                  size: 20,
                                  color: AppColors.navy,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Section 3: Rules
                    _buildFormCard(
                      stepNumber: '3',
                      title: 'Rules',
                      children: [
                        _buildFieldLabel('Eligibility and rules'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _rulesController,
                          maxLines: 3,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Section 4: Timing & winners
                    _buildFormCard(
                      stepNumber: '4',
                      title: 'Timing & winners',
                      children: [
                        Row(
                          children: [
                            // Start date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldLabel('Start date'),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _pickDate(isStart: true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border:
                                            Border.all(color: AppColors.line),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _startDate,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.navy,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            LucideIcons.calendar,
                                            size: 16,
                                            color: AppColors.navy,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // End date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldLabel('End date'),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _pickDate(isStart: false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border:
                                            Border.all(color: AppColors.line),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _endDate,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.navy,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            LucideIcons.calendar,
                                            size: 16,
                                            color: AppColors.navy,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stepper: Number of winners
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of winners',
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.navy,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      LucideIcons.minus,
                                      size: 18,
                                    ),
                                    color: AppColors.navy,
                                    onPressed: () {
                                      if (_winnersCount > 1) {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _winnersCount--;
                                        });
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '$_winnersCount',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      LucideIcons.plus,
                                      size: 18,
                                    ),
                                    color: AppColors.navy,
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      setState(() {
                                        _winnersCount++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA (.stickycta)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _publishGiveaway,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Publish giveaway',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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

  Widget _buildFormCard({
    required String stepNumber,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
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
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
      ),
    );
  }
}
