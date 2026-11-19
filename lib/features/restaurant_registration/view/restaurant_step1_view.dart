import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/utils/localized_messages.dart';
import '../bloc/restaurant_signup_bloc.dart';
import '../bloc/restaurant_signup_event.dart';
import '../bloc/restaurant_signup_state.dart';

class RestaurantStep1View extends StatefulWidget {
  const RestaurantStep1View({super.key});

  @override
  State<RestaurantStep1View> createState() => _RestaurantStep1ViewState();
}

class _RestaurantStep1ViewState extends State<RestaurantStep1View>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RestaurantSignupBloc>();
    _nameController = TextEditingController(text: bloc.state.ownerName);
    _emailController = TextEditingController(text: bloc.state.email);
    _passwordController = TextEditingController(text: bloc.state.password);
    _confirmPasswordController =
        TextEditingController(text: bloc.state.confirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = context.read<RestaurantSignupBloc>();

    return BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
      listenWhen: (prev, curr) =>
          prev.ownerName != curr.ownerName ||
          prev.email != curr.email ||
          prev.password != curr.password ||
          prev.confirmPassword != curr.confirmPassword,
      listener: (context, state) {
        if (_nameController.text != state.ownerName) {
          _nameController.text = state.ownerName;
        }
        if (_emailController.text != state.email) {
          _emailController.text = state.email;
        }
        if (_passwordController.text != state.password) {
          _passwordController.text = state.password;
        }
        if (_confirmPasswordController.text != state.confirmPassword) {
          _confirmPasswordController.text = state.confirmPassword;
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
              context.l10n.step1Title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              context.l10n.step1Subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24),

            // Owner or contact name
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.validationErrors['ownerName'] !=
                  curr.validationErrors['ownerName'],
              builder: (context, state) {
                final err = state.validationErrors['ownerName'];
                return _buildField(
                  label: context.l10n.ownerNameLabel,
                  hint: context.l10n.ownerNameHint,
                  controller: _nameController,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(OwnerNameChanged(val)),
                );
              },
            ),
            const SizedBox(height: 14),

            // Email address
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.validationErrors['email'] !=
                  curr.validationErrors['email'],
              builder: (context, state) {
                final err = state.validationErrors['email'];
                return _buildField(
                  label: context.l10n.emailLabel,
                  hint: context.l10n.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(EmailChanged(val)),
                );
              },
            ),
            const SizedBox(height: 14),

            // Password
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.isPasswordVisible != curr.isPasswordVisible ||
                  prev.validationErrors['password'] !=
                      curr.validationErrors['password'],
              builder: (context, state) {
                final err = state.validationErrors['password'];
                return _buildField(
                  label: context.l10n.passwordLabel,
                  hint: context.l10n.createPasswordHint,
                  controller: _passwordController,
                  obscureText: !state.isPasswordVisible,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(PasswordChanged(val)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.text,
                    ),
                    onPressed: () =>
                        bloc.add(const PasswordVisibilityToggled()),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // Confirm password
            BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
              buildWhen: (prev, curr) =>
                  prev.isConfirmPasswordVisible !=
                      curr.isConfirmPasswordVisible ||
                  prev.validationErrors['confirmPassword'] !=
                      curr.validationErrors['confirmPassword'],
              builder: (context, state) {
                final err = state.validationErrors['confirmPassword'];
                return _buildField(
                  label: context.l10n.confirmPasswordLabel,
                  hint: context.l10n.confirmPasswordHint,
                  controller: _confirmPasswordController,
                  obscureText: !state.isConfirmPasswordVisible,
                  errorText: err != null ? LocalizedMessages.get(context, err) : null,
                  onChanged: (val) => bloc.add(ConfirmPasswordChanged(val)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.text,
                    ),
                    onPressed: () =>
                        bloc.add(const ConfirmPasswordVisibilityToggled()),
                  ),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
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
          keyboardType: keyboardType,
          obscureText: obscureText,
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
            suffixIcon: suffixIcon,
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

