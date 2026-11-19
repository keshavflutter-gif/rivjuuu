import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/utils/localized_messages.dart';
import '../../../data/models/restaurant/restaurant_category_model.dart';
import '../bloc/restaurant_signup_bloc.dart';
import '../bloc/restaurant_signup_event.dart';
import '../bloc/restaurant_signup_state.dart';

class RestaurantStep2View extends StatefulWidget {
  const RestaurantStep2View({super.key});

  @override
  State<RestaurantStep2View> createState() => _RestaurantStep2ViewState();
}

class _RestaurantStep2ViewState extends State<RestaurantStep2View>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _restaurantNameController;
  late final TextEditingController _addressController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RestaurantSignupBloc>();
    _restaurantNameController =
        TextEditingController(text: bloc.state.restaurantName);
    _addressController = TextEditingController(text: bloc.state.restaurantAddress);
    bloc.add(const FetchCategoriesRequested());
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showCategoryPicker(BuildContext context) {
    final bloc = context.read<RestaurantSignupBloc>();
    if (bloc.state.categories.isEmpty) {
      bloc.add(const FetchCategoriesRequested());
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
          bloc: bloc,
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        ctx.l10n.selectCategoryHint,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    if (state.isLoadingCategories)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.coral,
                          ),
                        ),
                      )
                    else if (state.categories.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Failed to load categories.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  bloc.add(const FetchCategoriesRequested()),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.coral,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final catModel = state.categories[index];
                            final catName = catModel.name;
                            final catId = catModel.id;
                            final currentLocale =
                                Localizations.maybeLocaleOf(ctx)?.languageCode ??
                                    Localizations.maybeLocaleOf(context)?.languageCode ??
                                    'en';
                            final localizedCatName =
                                catModel.localizedName(currentLocale);
                            final localizedCatDesc =
                                catModel.localizedDescription(currentLocale);

                            final isSelected = (state.categoryId.isNotEmpty &&
                                    catId.isNotEmpty &&
                                    state.categoryId == catId) ||
                                (state.restaurantCategory.toLowerCase() ==
                                    catName.toLowerCase()) ||
                                (state.restaurantCategory.toLowerCase() ==
                                    localizedCatName.toLowerCase());

                            return ListTile(
                              title: Text(
                                localizedCatName,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.coral
                                      : AppColors.navy,
                                ),
                              ),
                              subtitle: localizedCatDesc != null &&
                                      localizedCatDesc.isNotEmpty
                                  ? Text(
                                      localizedCatDesc,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
                                    )
                                  : null,
                              trailing: isSelected
                                  ? const Icon(Icons.check,
                                      color: AppColors.coral)
                                  : null,
                              onTap: () {
                                bloc.add(RestaurantCategoryChanged(catName,
                                    categoryId: catId));
                                Navigator.of(ctx).pop();
                              },
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
      },
    );
  }

  void _onSetLocation(BuildContext context) {
    final bloc = context.read<RestaurantSignupBloc>();
    final addressText = _addressController.text.trim();
    final label =
        addressText.isNotEmpty ? addressText : 'Fő utca 12, Hungary';

    bloc.add(RestaurantLocationChanged(
      latitude: 47.4979,
      longitude: 19.0402,
      locationLabel: label,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          LocalizedMessages.get(context, 'Location pinned: $label'),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F7A45),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = context.read<RestaurantSignupBloc>();

    return BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
      listenWhen: (prev, curr) =>
          prev.restaurantName != curr.restaurantName ||
          prev.restaurantAddress != curr.restaurantAddress,
      listener: (context, state) {
        if (_restaurantNameController.text != state.restaurantName) {
          _restaurantNameController.text = state.restaurantName;
        }
        if (_addressController.text != state.restaurantAddress) {
          _addressController.text = state.restaurantAddress;
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            Text(
              context.l10n.step2Title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              context.l10n.step2Subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24),

            // Restaurant name
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.validationErrors['restaurantName'] !=
                  curr.validationErrors['restaurantName'],
              builder: (context, state) {
                final err = state.validationErrors['restaurantName'];
                return _buildField(
                  label: context.l10n.restaurantNameLabel,
                  hint: context.l10n.restaurantNameHint,
                  controller: _restaurantNameController,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(RestaurantNameChanged(val)),
                );
              },
            ),
            const SizedBox(height: 16),

            // Restaurant category selector
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.restaurantCategory != curr.restaurantCategory ||
                  prev.validationErrors['restaurantCategory'] !=
                      curr.validationErrors['restaurantCategory'],
              builder: (context, state) {
                final hasSelected = state.restaurantCategory.isNotEmpty;
                final errorText = state.validationErrors['restaurantCategory'];
                final currentLocale =
                    Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
                final selectedCat = state.categories.firstWhere(
                  (c) =>
                      (state.categoryId.isNotEmpty &&
                          c.id == state.categoryId) ||
                      c.name.toLowerCase() ==
                          state.restaurantCategory.toLowerCase() ||
                      c.localizedName(currentLocale).toLowerCase() ==
                          state.restaurantCategory.toLowerCase(),
                  orElse: () => RestaurantCategoryModel(
                    id: state.categoryId,
                    name: state.restaurantCategory,
                  ),
                );
                final displayCategoryName = hasSelected
                    ? selectedCat.localizedName(currentLocale)
                    : context.l10n.selectCategoryHint;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.restaurantCategoryLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      onTap: () => _showCategoryPicker(context),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: errorText != null
                                ? AppColors.coral
                                : AppColors.line,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayCategoryName,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: hasSelected
                                      ? AppColors.navy
                                      : AppColors.muted,
                                  fontWeight: hasSelected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.muted,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          LocalizedMessages.get(context, errorText),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.coral,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Address
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.validationErrors['restaurantAddress'] !=
                  curr.validationErrors['restaurantAddress'],
              builder: (context, state) {
                final err = state.validationErrors['restaurantAddress'];
                return _buildField(
                  label: context.l10n.addressLabel,
                  hint: context.l10n.addressHint,
                  controller: _addressController,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(RestaurantAddressChanged(val)),
                );
              },
            ),
            const SizedBox(height: 16),

            // Restaurant location map card
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.locationLabel != curr.locationLabel ||
                  prev.latitude != curr.latitude ||
                  prev.validationErrors['restaurantLocation'] !=
                      curr.validationErrors['restaurantLocation'],
              builder: (context, state) {
                final hasLocation = (state.locationLabel != null &&
                        state.locationLabel!.isNotEmpty &&
                        state.locationLabel != 'Set location on map') ||
                    (state.latitude != null && state.longitude != null);
                final locationText = state.locationLabel?.isNotEmpty == true
                    ? state.locationLabel!
                    : context.l10n.setLocationOnMap;
                final errorText = state.validationErrors['restaurantLocation'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.restaurantLocationLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      onTap: () => _onSetLocation(context),
                      child: Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF0EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: errorText != null
                                ? AppColors.coral
                                : AppColors.line,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(double.infinity, 72),
                              painter: _MapPatternPainter(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  hasLocation
                                      ? Icons.check_circle_rounded
                                      : Icons.location_on_rounded,
                                  color: hasLocation
                                      ? AppColors.green
                                      : AppColors.coral,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    locationText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Positioned(
                              right: 0,
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.navy,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          LocalizedMessages.get(context, errorText),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.coral,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Continue Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => bloc.add(const NextStepRequested()),
                child: Text(
                  context.l10n.continueButton,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.navy,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.coral,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            errorText: errorText,
            errorStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.coral,
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.muted,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.coral : AppColors.line,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.coral : AppColors.navy,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.coral),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.coral, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Diagonal street line 1
    canvas.drawLine(
      const Offset(0, 50),
      Offset(size.width, 15),
      linePaint,
    );

    // Diagonal street line 2
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.75, size.height),
      linePaint..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

