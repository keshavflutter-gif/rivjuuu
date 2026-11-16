import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/language_bloc.dart';
import '../bloc/language_event.dart';
import '../bloc/language_state.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

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

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'Choose language',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "Select the language you'd like to use in Rivjuuu.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.text,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Language Options with BlocBuilder
                        BlocBuilder<LanguageBloc, LanguageState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                _LanguageOptionCard(
                                  title: 'English',
                                  flag: const UkFlag(),
                                  isSelected: state.selectedLanguage == 'en',
                                  onTap: () {
                                    context.read<LanguageBloc>().add(
                                          const LanguageSelected('en'),
                                        );
                                  },
                                ),
                                const SizedBox(height: 12),
                                _LanguageOptionCard(
                                  title: 'Hungarian',
                                  flag: const HungarianFlag(),
                                  isSelected: state.selectedLanguage == 'hu',
                                  onTap: () {
                                    context.read<LanguageBloc>().add(
                                          const LanguageSelected('hu'),
                                        );
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.coral,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.login);
                            },
                            child: Text(
                              'Continue',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String title;
  final Widget flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.title,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.coral : AppColors.line,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(254, 85, 46, 0.12),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            flag,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.coral : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.coral : AppColors.line,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 13,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class UkFlag extends StatelessWidget {
  const UkFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line, width: 0.8),
      ),
      child: ClipOval(
        child: CustomPaint(
          size: const Size(28, 28),
          painter: _UkFlagPainter(),
        ),
      ),
    );
  }
}

class _UkFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBlue);

    final whiteDiag = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), whiteDiag);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), whiteDiag);

    final redDiag = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), redDiag);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), redDiag);

    final whiteCross = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH((size.width - 8) / 2, 0, 8, size.height),
      whiteCross,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, (size.height - 8) / 2, size.width, 8),
      whiteCross,
    );

    final redCross = Paint()
      ..color = const Color(0xFFC8102E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH((size.width - 4.5) / 2, 0, 4.5, size.height),
      redCross,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, (size.height - 4.5) / 2, size.width, 4.5),
      redCross,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HungarianFlag extends StatelessWidget {
  const HungarianFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line, width: 0.8),
      ),
      child: ClipOval(
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFCE2939))),
            Expanded(child: Container(color: Colors.white)),
            Expanded(child: Container(color: const Color(0xFF477050))),
          ],
        ),
      ),
    );
  }
}

