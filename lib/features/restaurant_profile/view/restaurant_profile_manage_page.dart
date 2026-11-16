import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';

/// Restaurant Profile Management Page matching profile-manage.html & profile-edit.html
class RestaurantProfileManagePage extends StatefulWidget {
  const RestaurantProfileManagePage({super.key});

  @override
  State<RestaurantProfileManagePage> createState() =>
      _RestaurantProfileManagePageState();
}

class _RestaurantProfileManagePageState
    extends State<RestaurantProfileManagePage> {
  // State for editable profile information
  String _restaurantName = 'Trattoria Nonna Rosa';
  String _category = 'Italian · Pasta · Pizza';
  String _description =
      'Hand-made pasta, a wood-fired oven and a quiet courtyard.';
  String _address = 'Fő utca 12, Hungary';
  int _completeness = 85;
  String _coverAsset = 'assets/interior.jpg';

  final List<String> _galleryImages = [
    'assets/interior.jpg',
    'assets/pasta.jpg',
    'assets/tiramisu.jpg',
    'assets/terrace.jpg',
  ];

  static TextStyle _poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (.bar, style="padding-top: 4px") matching profile-manage.html
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
                      'Restaurant profile',
                      textAlign: TextAlign.center,
                      style: _poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cover & Logo Header
                    _buildCoverAndHeader(),

                    const SizedBox(height: 14),

                    // Profile Completeness Card
                    _buildCompletenessCard(),

                    const SizedBox(height: 12),

                    // Basic Information Card
                    _buildBasicInfoCard(),

                    const SizedBox(height: 12),

                    // Location Card
                    _buildLocationCard(),

                    const SizedBox(height: 12),

                    // Images Gallery Card
                    _buildImagesCard(),

                    const SizedBox(height: 16),

                    // "View as customer" Button (.btn.btn--ghost)
                    _buildViewAsCustomerButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Cover Image and Overlapping Logo + Restaurant Name (.cover, .pm-head)
  Widget _buildCoverAndHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover container
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF2E4A3A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      _coverAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF2E4A3A),
                        child: const Center(
                          child: Icon(
                            LucideIcons.utensils,
                            size: 48,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // "Change cover" pill button (.cover__edit)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: _showChangeCoverSheet,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.camera,
                              size: 15,
                              color: AppColors.navy,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Change cover',
                              style: _poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Logo box (.pm-logo: 64x64, r=18, border 4px cream, bg #2e4a3a)
            Positioned(
              left: 14,
              bottom: -32,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E4A3A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cream, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'NR',
                    style: _poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Text placed completely below cover, to the right of the overlapping logo
        Padding(
          padding: const EdgeInsets.fromLTRB(90, 8, 14, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _restaurantName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _poppins(
                  fontSize: 18,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$_category · Approved',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Profile completeness card (.complete, .bar8)
  Widget _buildCompletenessCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile completeness',
                style: _poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              Text(
                '$_completeness%',
                style: _poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar (.bar8)
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECE2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_completeness / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            _completeness >= 100
                ? 'Your profile is complete!'
                : 'Add 3 more gallery photos to reach 100%.',
            style: _poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  /// Basic information card (.sec-card, .kv)
  Widget _buildBasicInfoCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Basic information',
                style: _poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: _showEditBasicInfoSheet,
                child: Text(
                  'Edit',
                  style: _poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Key-Values
          _buildKeyValue('Restaurant name', _restaurantName),
          const SizedBox(height: 10),
          _buildKeyValue('Category', _category),
          const SizedBox(height: 10),
          _buildKeyValue('Description', _description),
        ],
      ),
    );
  }

  /// Location card with vector minimap (.sec-card, .minimap, .kv)
  Widget _buildLocationCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: _poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: _showEditLocationSheet,
                child: Text(
                  'Edit',
                  style: _poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vector Minimap matching SVG in profile-manage.html
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: CustomPaint(
                painter: _MinimapPainter(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildKeyValue('Address', _address),
        ],
      ),
    );
  }

  /// Images card with gallery and add button (.sec-card, .gallery)
  Widget _buildImagesCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Images',
                style: _poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: _showManageImagesSheet,
                child: Text(
                  'Manage',
                  style: _poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Gallery
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: _galleryImages.length + 1,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index < _galleryImages.length) {
                  return Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.cardBg,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      _galleryImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(LucideIcons.image, color: AppColors.muted),
                      ),
                    ),
                  );
                }

                // Add photo button (.gallery button)
                return GestureDetector(
                  onTap: _addPhoto,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: const Color(0xFFD8CFBF),
                        strokeWidth: 1.5,
                        dashLength: 5,
                        dashGap: 4,
                        borderRadius: 12,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.plus,
                          size: 24,
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// "View as customer" Button (.btn.btn--ghost)
  Widget _buildViewAsCustomerButton() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.eye,
              size: 20,
              color: AppColors.navy,
            ),
            const SizedBox(width: 8),
            Text(
              'View as customer',
              style: _poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Key-value component (.kv)
  Widget _buildKeyValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: _poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppColors.navy,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM SHEETS & ACTIONS
  // ============================================================

  /// Edit Basic Information bottom sheet matching profile-edit.html
  void _showEditBasicInfoSheet() {
    HapticFeedback.lightImpact();

    final nameController = TextEditingController(text: _restaurantName);
    final descController = TextEditingController(text: _description);
    String selectedCategory = _category;

    final categories = [
      'Italian · Pasta · Pizza',
      'Burgers · American · Fast Food',
      'Japanese · Sushi · Asian',
      'Cafe · Bakery · Desserts',
      'Indian · Curry · Vegetarian',
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.line,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Header with close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Basic information',
                              style: _poppins(
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
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: const Center(
                                  child: Icon(
                                    LucideIcons.x,
                                    size: 18,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Field 1: Restaurant name
                        _buildFieldLabel('Restaurant name'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: nameController,
                          style: _poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(
                            hintText: 'Enter restaurant name',
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Field 2: Category dropdown
                        _buildFieldLabel('Category'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: categories.contains(selectedCategory)
                                  ? selectedCategory
                                  : categories.first,
                              isExpanded: true,
                              icon: const Icon(
                                LucideIcons.chevronDown,
                                color: AppColors.navy,
                              ),
                              style: _poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.navy,
                              ),
                              items: categories.map((cat) {
                                return DropdownMenuItem<String>(
                                  value: cat,
                                  child: Text(cat),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() {
                                    selectedCategory = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Field 3: Description
                        _buildFieldLabel('Description'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: descController,
                          maxLines: 3,
                          style: _poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.navy,
                          ),
                          decoration: _buildInputDecoration(
                            hintText: 'Describe your restaurant',
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Save changes button (.btn)
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = nameController.text.trim();
                              final desc = descController.text.trim();
                              if (name.isEmpty) return;

                              setState(() {
                                _restaurantName = name;
                                _category = selectedCategory;
                                _description = desc;
                              });

                              Navigator.pop(ctx);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Basic information updated successfully!',
                                    style: _poppins(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.navy,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
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
                            child: Text(
                              'Save changes',
                              style: _poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Edit Location sheet
  void _showEditLocationSheet() {
    HapticFeedback.lightImpact();
    final addressController = TextEditingController(text: _address);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit location',
                        style: _poppins(
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.line),
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.x,
                              size: 18,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildFieldLabel('Restaurant address'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: addressController,
                    style: _poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navy,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: 'Enter street, city, postal code',
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final addr = addressController.text.trim();
                        if (addr.isNotEmpty) {
                          setState(() => _address = addr);
                        }
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Location updated successfully!',
                              style: _poppins(color: Colors.white),
                            ),
                            backgroundColor: AppColors.navy,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                      child: Text(
                        'Save location',
                        style: _poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Change Cover bottom sheet
  void _showChangeCoverSheet() {
    HapticFeedback.lightImpact();
    final covers = [
      {'title': 'Dining interior', 'asset': 'assets/interior.jpg'},
      {'title': 'Terrace & outdoor', 'asset': 'assets/terrace.jpg'},
      {'title': 'Bar & ambience', 'asset': 'assets/dining.jpg'},
      {'title': 'Grill & kitchen', 'asset': 'assets/grill.jpg'},
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Change cover image',
                  style: _poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 16),
                ...covers.map((c) {
                  final isSelected = _coverAsset == c['asset'];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        c['asset']!,
                        width: 52,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      c['title']!,
                      style: _poppins(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: AppColors.navy,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(LucideIcons.checkCircle, color: AppColors.coral)
                        : null,
                    onTap: () {
                      setState(() {
                        _coverAsset = c['asset']!;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Cover image updated!',
                            style: _poppins(color: Colors.white),
                          ),
                          backgroundColor: AppColors.navy,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Manage gallery images sheet
  void _showManageImagesSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Manage gallery images',
                  style: _poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_galleryImages.length} images uploaded',
                  style: _poppins(
                    fontSize: 13,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _galleryImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, idx) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              _galleryImages[idx],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                if (_galleryImages.length > 1) {
                                  setState(() {
                                    _galleryImages.removeAt(idx);
                                    _completeness = (_completeness - 5).clamp(50, 100);
                                  });
                                  Navigator.pop(ctx);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.x,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addPhoto() {
    HapticFeedback.lightImpact();
    // Simulate adding another image from available assets
    final extraAssets = [
      'assets/dining.jpg',
      'assets/pizza.jpg',
      'assets/healthy.jpg',
      'assets/salad.jpg',
    ];

    final remaining = extraAssets
        .where((asset) => !_galleryImages.contains(asset))
        .toList();

    if (remaining.isNotEmpty) {
      setState(() {
        _galleryImages.add(remaining.first);
        _completeness = (_completeness + 5).clamp(0, 100);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Photo added! Completeness: $_completeness%',
            style: _poppins(color: Colors.white),
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All available sample photos already added!',
            style: _poppins(color: Colors.white),
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: _poppins(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.navy,
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text.withValues(alpha: 0.5),
      ),
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

/// Custom Painter for the Minimap matching profile-manage.html SVG minimap
class _MinimapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background #ECEEE9
    final bgPaint = Paint()..color = const Color(0xFFECEEE9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final scaleX = size.width / 350.0;
    final scaleY = size.height / 110.0;

    // Road lines (stroke #FFFFFF, round cap)
    final road1Paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12 * scaleY
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(-10 * scaleX, 60 * scaleY),
      Offset(360 * scaleX, 44 * scaleY),
      road1Paint,
    );

    final road2Paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10 * scaleX
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(120 * scaleX, -10 * scaleY),
      Offset(100 * scaleX, 120 * scaleY),
      road2Paint,
    );

    final road3Paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8 * scaleX
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(260 * scaleX, -10 * scaleY),
      Offset(250 * scaleX, 120 * scaleY),
      road3Paint,
    );

    // Map Pin in Center (x=175, y=33)
    final pinCenterX = 175 * scaleX;
    final pinCenterY = 33 * scaleY;
    final pinRadius = 18.0 * scaleY;

    final pinPaint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.fill;

    // Pin shape
    final pinPath = Path();
    pinPath.moveTo(pinCenterX, pinCenterY + pinRadius + 13 * scaleY);
    pinPath.cubicTo(
      pinCenterX - 10 * scaleX,
      pinCenterY + 18 * scaleY,
      pinCenterX - pinRadius,
      pinCenterY + 10 * scaleY,
      pinCenterX - pinRadius,
      pinCenterY,
    );
    pinPath.arcToPoint(
      Offset(pinCenterX + pinRadius, pinCenterY),
      radius: Radius.circular(pinRadius),
      clockwise: true,
    );
    pinPath.cubicTo(
      pinCenterX + pinRadius,
      pinCenterY + 10 * scaleY,
      pinCenterX + 10 * scaleX,
      pinCenterY + 18 * scaleY,
      pinCenterX,
      pinCenterY + pinRadius + 13 * scaleY,
    );
    pinPath.close();

    canvas.drawPath(pinPath, pinPaint);

    // Inner white circle (r=6.5)
    final whiteDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(pinCenterX, pinCenterY), 6.5 * scaleY, whiteDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for dashed rounded border (.gallery button)
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        final extract = metric.extractPath(
          distance,
          next > metric.length ? metric.length : next,
        );
        canvas.drawPath(extract, paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

