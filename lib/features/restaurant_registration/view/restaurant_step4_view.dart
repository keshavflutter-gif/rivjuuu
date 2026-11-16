import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/restaurant_signup_bloc.dart';
import '../bloc/restaurant_signup_event.dart';
import '../bloc/restaurant_signup_state.dart';

class RestaurantStep4View extends StatelessWidget {
  const RestaurantStep4View({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RestaurantSignupBloc>();

    return BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
      builder: (context, state) {
        final contactVal =
            state.ownerName.isNotEmpty ? state.ownerName : 'Márton Szabó';
        final emailVal =
            state.email.isNotEmpty ? state.email : 'hello@nonnarosa.hu';
        final restaurantNameVal = state.restaurantName.isNotEmpty
            ? state.restaurantName
            : 'Trattoria Nonna Rosa';
        final categoryVal =
            state.restaurantCategory.isNotEmpty ? state.restaurantCategory : 'Italian';
        final addressVal = state.restaurantAddress.isNotEmpty
            ? state.restaurantAddress
            : 'Fő utca 12, Hungary';
        final businessDetailVal = state.businessDetails.isNotEmpty
            ? state.businessDetails
            : '[Value]';
        final termsError = state.validationErrors['terms'];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Text(
                'Review and submit',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Check your details before sending your application.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),

              // Summary Card 1: Account
              _buildSummaryCard(
                title: 'Account',
                onEdit: () => bloc.add(const GoToStepRequested(0)),
                rows: [
                  _SummaryRow(label: 'Contact', value: contactVal),
                  _SummaryRow(label: 'Email', value: emailVal),
                ],
              ),
              const SizedBox(height: 12),

              // Summary Card 2: Restaurant
              _buildSummaryCard(
                title: 'Restaurant',
                onEdit: () => bloc.add(const GoToStepRequested(1)),
                rows: [
                  _SummaryRow(label: 'Name', value: restaurantNameVal),
                  _SummaryRow(label: 'Category', value: categoryVal),
                  _SummaryRow(label: 'Address', value: addressVal),
                ],
              ),
              const SizedBox(height: 12),

              // Summary Card 3: Business information
              _buildSummaryCard(
                title: 'Business information',
                onEdit: () => bloc.add(const GoToStepRequested(2)),
                rows: [
                  _SummaryRow(
                    label: '[Business detail]',
                    value: businessDetailVal,
                  ),
                  if (state.supportingDocument != null)
                    _SummaryRow(
                      label: '[Document]',
                      value: state.supportingDocument!,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkbox consent
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    key: const Key('termsCheckbox'),
                    onTap: () =>
                        bloc.add(TermsAcceptanceChanged(!state.termsAccepted)),
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: state.termsAccepted
                            ? AppColors.coral
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: state.termsAccepted
                              ? AppColors.coral
                              : (termsError != null
                                  ? AppColors.coral
                                  : const Color(0xFFD8D3CC)),
                          width: 1.5,
                        ),
                      ),
                      child: state.termsAccepted
                          ? const Center(
                              child: Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.navy,
                            height: 1.45,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.legal);
                                },
                                child: Text(
                                  'Terms and Conditions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    color: AppColors.coral,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.coral,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.legal);
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    color: AppColors.coral,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.coral,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (termsError != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      termsError,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.coral,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

              // Submit Application Button
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
                    disabledBackgroundColor:
                        AppColors.coral.withValues(alpha: 0.5),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: !state.isSubmitting
                      ? () => bloc.add(const SubmitApplicationRequested())
                      : null,
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : Text(
                          'Submit application',
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
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required VoidCallback onEdit,
    required List<_SummaryRow> rows,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row.label,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: AppColors.text,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      row.value,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});
}
