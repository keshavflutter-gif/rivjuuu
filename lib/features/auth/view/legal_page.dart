import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Text(
                'Terms and Conditions',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Last updated November 2026',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                number: '1.',
                heading: 'Introduction',
                content:
                    'Welcome to Rivjuuu. By accessing or using our services, you agree to be bound by these terms and our Privacy Policy. If you do not agree, please do not use our app.',
              ),

              _buildSection(
                number: '2.',
                heading: 'Account Responsibilities',
                content:
                    'You are responsible for maintaining the confidentiality of your account credentials and for all activities that take place under your account.',
              ),

              _buildSection(
                number: '3.',
                heading: 'Rewards & Offers',
                content:
                    'Rewards, coupons, and offers provided by participating restaurants are subject to availability and specific restaurant terms.',
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String heading,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number $heading',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.55,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

