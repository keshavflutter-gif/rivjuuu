import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/validators.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text;
    final password = _passwordController.text;

    final emailErr = Validators.validateEmail(email);
    final passErr = Validators.validateLoginPassword(password);

    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });

    if (emailErr == null && passErr == null) {
      context.read<LoginBloc>().add(
            LoginSubmitted(
              email: email,
              password: password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final scale = (screenSize.width / 390.0).clamp(0.85, 1.25);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.cream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFE03131),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
              setState(() {
                if (state.fieldErrors!.containsKey('email')) {
                  _emailError = state.fieldErrors!['email'];
                }
                if (state.fieldErrors!.containsKey('password')) {
                  _passwordError = state.fieldErrors!['password'];
                }
              });
            }
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  state.response.message.isNotEmpty
                      ? state.response.message
                      : AppMessages.loginSuccess,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF1F7A45),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            // Navigate to Customer Home Screen, clearing backstack
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: Stack(
            children: [
              // 1. Decorative top-right plate image (clipped to screen edge)
              Positioned(
                right: -52 * scale,
                top: topPadding + 10,
                child: Container(
                  width: 168 * scale,
                  height: 168 * scale,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(60, 40, 20, 0.16),
                        blurRadius: 34,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.plate,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.24, -0.84),
                    ),
                  ),
                ),
              ),

              // 2. Language selector button (hovering over top right)
              Positioned(
                right: 18 * scale,
                top: topPadding + 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.language);
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.language,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Main scrollable content
              SafeArea(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14 * scale),

                      // Brand Logo on top left
                      Image.asset(
                        AppAssets.logo,
                        width: 118 * scale,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 38 * scale),

                      // Heading: Welcome to Rivjuuu
                      Text(
                        AppStrings.welcomeTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.2,
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        AppStrings.welcomeSubtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 26 * scale),

                      // Field 1: Email address
                      Text(
                        AppStrings.emailLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w400,
                        ),
                        cursorColor: AppColors.coral,
                        onChanged: (value) {
                          context
                              .read<LoginBloc>()
                              .add(LoginEmailChanged(value));
                          if (_emailError != null) {
                            setState(() {
                              _emailError = Validators.validateEmail(value);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppStrings.emailHint,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFFA1A1AA),
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFE03131)
                                  : const Color(0xFFECE4D6),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFE03131)
                                  : AppColors.navy,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                      if (_emailError != null) ...[
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _emailError!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFFE03131),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Field 2: Password
                      Text(
                        AppStrings.passwordLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (prev, curr) =>
                            prev.obscurePassword != curr.obscurePassword,
                        builder: (context, state) {
                          return TextFormField(
                            controller: _passwordController,
                            obscureText: state.obscurePassword,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.navy,
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: AppColors.coral,
                            onChanged: (value) {
                              context
                                  .read<LoginBloc>()
                                  .add(LoginPasswordChanged(value));
                              if (_passwordError != null) {
                                setState(() {
                                  _passwordError =
                                      Validators.validateLoginPassword(value);
                                });
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: AppStrings.passwordHint,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFFA1A1AA),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.text,
                                  size: 20,
                                ),
                                onPressed: () {
                                  context.read<LoginBloc>().add(
                                        const LoginPasswordVisibilityToggled(),
                                      );
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _passwordError != null
                                      ? const Color(0xFFE03131)
                                      : const Color(0xFFECE4D6),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _passwordError != null
                                      ? const Color(0xFFE03131)
                                      : AppColors.navy,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_passwordError != null) ...[
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _passwordError!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFFE03131),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Forgot password? Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.forgotPassword);
                          },
                          child: Text(
                            AppStrings.forgotPassword,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.coral,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24 * scale),

                      // Log In Button with glowing coral shadow
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          final isSubmitting = state is LoginLoading;

                          return Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                  color: isSubmitting
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
                                backgroundColor: isSubmitting
                                    ? AppColors.coral.withValues(alpha: 0.7)
                                    : AppColors.coral,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isSubmitting ? null : _handleSubmit,
                              child: isSubmitting
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
                                      AppStrings.logIn,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 22 * scale),

                      // "or" Divider with lines on both sides
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFECE4D6),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              AppStrings.or,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.text,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFECE4D6),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20 * scale),

                      // Sign up text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.newToRivjuuu,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: AppColors.navy,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.accountType);
                            },
                            child: Text(
                              AppStrings.createAccount,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.coral,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
