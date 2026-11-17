import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/restaurant_signup_bloc.dart';
import '../bloc/restaurant_signup_event.dart';
import '../bloc/restaurant_signup_state.dart';

class RestaurantStep3View extends StatefulWidget {
  const RestaurantStep3View({super.key});

  @override
  State<RestaurantStep3View> createState() => _RestaurantStep3ViewState();
}

class _RestaurantStep3ViewState extends State<RestaurantStep3View>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _businessDetailController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RestaurantSignupBloc>();
    _businessDetailController =
        TextEditingController(text: bloc.state.businessDetails);
  }

  @override
  void dispose() {
    _businessDetailController.dispose();
    super.dispose();
  }

  void _onUpload(BuildContext context) {
    final bloc = context.read<RestaurantSignupBloc>();
    const fileName = 'business_license_certificate.pdf';
    bloc.add(const SupportingDocumentChanged(fileName));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          'Uploaded: $fileName',
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
          prev.businessDetails != curr.businessDetails,
      listener: (context, state) {
        if (_businessDetailController.text != state.businessDetails) {
          _businessDetailController.text = state.businessDetails;
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
              'Business information',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              'We use this to verify your restaurant before it goes live.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),

            // Fields to be confirmed tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DC),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Fields to be confirmed by client',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8A5300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // [Business detail]
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.validationErrors['businessDetails'] !=
                  curr.validationErrors['businessDetails'],
              builder: (context, state) {
                final errorText = state.validationErrors['businessDetails'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[Business detail]',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _businessDetailController,
                      onChanged: (val) =>
                          bloc.add(BusinessDetailsChanged(val)),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w400,
                      ),
                      cursorColor: AppColors.coral,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '[Field to be confirmed]',
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
                            color: errorText != null
                                ? AppColors.coral
                                : AppColors.line,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorText != null
                                ? AppColors.coral
                                : AppColors.navy,
                            width: 1.2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.coral),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.coral, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),

            // [Supporting document] upload area
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.supportingDocument != curr.supportingDocument ||
                  prev.validationErrors['supportingDocument'] !=
                      curr.validationErrors['supportingDocument'],
              builder: (context, state) {
                final hasFile = state.supportingDocument != null &&
                    state.supportingDocument!.isNotEmpty;
                final fileName = state.supportingDocument;
                final errorText = state.validationErrors['supportingDocument'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[Supporting document]',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      onTap: () => _onUpload(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: errorText != null
                                ? AppColors.coral
                                : (hasFile
                                    ? AppColors.green
                                    : const Color(0xFFD8D3CC)),
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hasFile
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.file_upload_outlined,
                              size: 28,
                              color: hasFile
                                  ? AppColors.green
                                  : AppColors.coral,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              hasFile ? fileName! : 'Upload a file',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasFile
                                  ? 'Tap to change file'
                                  : '[Accepted formats to be confirmed]',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                color: AppColors.muted,
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
                          errorText,
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
                  'Continue',
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
}

