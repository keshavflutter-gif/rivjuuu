import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/localization_extension.dart';
import '../../../../../../core/routes/app_router.dart';
import '../../../../../../core/utils/localized_messages.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../data/models/auth/customer_register_request.dart';
import '../bloc/customer_register_bloc.dart';
import '../bloc/customer_register_event.dart';
import '../bloc/customer_register_state.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  // Inline validation error states
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _nameError = Validators.validateFullName(_nameController.text);
      _emailError = Validators.validateEmail(_emailController.text);
      _passwordError = Validators.validatePassword(_passwordController.text);
      _confirmPasswordError = Validators.validateConfirmPassword(
        _passwordController.text,
        _confirmPasswordController.text,
      );
      _termsError = Validators.validateTerms(_agreedToTerms);
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _termsError == null;
  }

  void _onSubmit() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_validateForm()) {
      return;
    }

    final request = CustomerRegisterRequest(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text, // Never trim password
      confirmPassword: _confirmPasswordController.text, // Never trim confirm password
      acceptTerms: _agreedToTerms,
    );

    context.read<CustomerRegisterBloc>().add(CustomerRegisterSubmitted(request));
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? errorText,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
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
        TextFormField(
          controller: controller,
          onChanged: (val) {
            onChanged(val);
          },
          keyboardType: keyboardType,
          obscureText: obscureText,
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
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFA1A1AA),
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF71717A),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText != null
                    ? const Color(0xFFE03131)
                    : const Color(0xFFECE4D6),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText != null
                    ? const Color(0xFFE03131)
                    : AppColors.coral,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFFE03131),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.cream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: BlocConsumer<CustomerRegisterBloc, CustomerRegisterState>(
            listener: (context, state) {
              if (state is CustomerRegisterFailure) {
                // Display exact backend error message in SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      LocalizedMessages.get(context, state.message),
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFE03131),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                // Map backend field errors to inline error fields where available
                if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
                  setState(() {
                    if (state.fieldErrors!.containsKey('fullName')) {
                      _nameError = state.fieldErrors!['fullName'];
                    }
                    if (state.fieldErrors!.containsKey('email')) {
                      _emailError = state.fieldErrors!['email'];
                    }
                    if (state.fieldErrors!.containsKey('password')) {
                      _passwordError = state.fieldErrors!['password'];
                    }
                    if (state.fieldErrors!.containsKey('confirmPassword')) {
                      _confirmPasswordError =
                          state.fieldErrors!['confirmPassword'];
                    }
                    if (state.fieldErrors!.containsKey('acceptTerms')) {
                      _termsError = state.fieldErrors!['acceptTerms'];
                    }
                  });
                }
              } else if (state is CustomerRegisterSuccess) {
                // Display exact backend success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      LocalizedMessages.get(context, state.message),
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF1F7A45),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                // Navigate directly to existing Customer Home Screen, clearing auth stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is CustomerRegisterLoading;

              return SingleChildScrollView(
                key: const PageStorageKey<String>('customer_signup_scroll'),
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Back Arrow
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.navy,
                        size: 24,
                      ),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.login);
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      context.l10n.createAccount,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      context.l10n.createAccountSubtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Full Name
                    _buildField(
                      label: context.l10n.fullNameLabel,
                      hint: context.l10n.fullNameHint,
                      controller: _nameController,
                      errorText: _nameError != null
                          ? LocalizedMessages.get(context, _nameError)
                          : null,
                      onChanged: (val) {
                        if (_nameError != null) {
                          setState(() {
                            _nameError = Validators.validateFullName(val);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // Email address
                    _buildField(
                      label: context.l10n.emailLabel,
                      hint: context.l10n.emailHint,
                      controller: _emailController,
                      errorText: _emailError != null
                          ? LocalizedMessages.get(context, _emailError)
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        if (_emailError != null) {
                          setState(() {
                            _emailError = Validators.validateEmail(val);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // Password
                    _buildField(
                      label: context.l10n.passwordLabel,
                      hint: context.l10n.createPasswordHint,
                      controller: _passwordController,
                      errorText: _passwordError != null
                          ? LocalizedMessages.get(context, _passwordError)
                          : null,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      onChanged: (val) {
                        if (_passwordError != null) {
                          setState(() {
                            _passwordError = Validators.validatePassword(val);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // Confirm password
                    _buildField(
                      label: context.l10n.confirmPasswordLabel,
                      hint: context.l10n.confirmPasswordHint,
                      controller: _confirmPasswordController,
                      errorText: _confirmPasswordError != null
                          ? LocalizedMessages.get(context, _confirmPasswordError)
                          : null,
                      isPassword: true,
                      obscureText: !_isConfirmPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      onChanged: (val) {
                        if (_confirmPasswordError != null) {
                          setState(() {
                            _confirmPasswordError =
                                Validators.validateConfirmPassword(
                              _passwordController.text,
                              val,
                            );
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Consent Checkbox
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreedToTerms = !_agreedToTerms;
                          if (_termsError != null) {
                            _termsError = Validators.validateTerms(_agreedToTerms);
                          }
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 18,
                            height: 18,
                            margin: const EdgeInsets.only(top: 2, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _termsError != null
                                    ? const Color(0xFFE03131)
                                    : _agreedToTerms
                                        ? AppColors.coral
                                        : const Color(0xFFCFCBC5),
                                width: 1.5,
                              ),
                            ),
                            child: _agreedToTerms
                                ? const Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 13,
                                      color: AppColors.coral,
                                    ),
                                  )
                                : null,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: context.l10n.iAgreeToThe,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: AppColors.text,
                                  height: 1.45,
                                ),
                                children: [
                                  TextSpan(
                                    text: context.l10n.termsAndConditions,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      color: AppColors.coral,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushNamed(AppRoutes.legal);
                                      },
                                  ),
                                  TextSpan(text: context.l10n.and),
                                  TextSpan(
                                    text: context.l10n.privacyPolicy,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      color: AppColors.coral,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushNamed(AppRoutes.legal);
                                      },
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_termsError != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Text(
                          LocalizedMessages.get(context, _termsError),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFFE03131),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // "Create account" Button with glowing coral shadow
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: isLoading
                                ? Colors.transparent
                                : const Color.fromRGBO(254, 85, 46, 0.28),
                            blurRadius: 16,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.coral.withValues(alpha: 0.65),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _onSubmit,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                context.l10n.createAccount,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Already have an account? Log in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.alreadyHaveAccount,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: AppColors.navy,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.login);
                          },
                          child: Text(
                            context.l10n.logIn,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: AppColors.coral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

