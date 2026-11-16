import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../models/restaurant_registration_data.dart';

class RegistrationPendingPage extends StatefulWidget {
  final RestaurantRegistrationData? data;
  final bool autoAdvance;
  final Duration autoAdvanceDuration;

  const RegistrationPendingPage({
    super.key,
    this.data,
    this.autoAdvance = true,
    this.autoAdvanceDuration = const Duration(milliseconds: 2500),
  });

  @override
  State<RegistrationPendingPage> createState() => _RegistrationPendingPageState();
}

class _RegistrationPendingPageState extends State<RegistrationPendingPage> {
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    if (widget.autoAdvance) {
      _autoTimer = Timer(widget.autoAdvanceDuration, () {
        if (mounted) {
          _navigateToApproved();
        }
      });
    }
  }

  void _navigateToApproved() {
    _autoTimer?.cancel();
    _autoTimer = null;
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.registrationApproved,
      arguments: widget.data,
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  String _formatInitials(String name) {
    if (name.trim().isEmpty) return 'NR';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    if (parts.length >= 3 && parts[0].toLowerCase() == 'trattoria') {
      return '${parts[1][0]}${parts[2][0]}'.toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _showSubmittedDetails(BuildContext context, RestaurantRegistrationData d) {
    _autoTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Submitted details',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _modalDetailRow('Owner name', d.ownerName.isEmpty ? 'Márton Szabó' : d.ownerName),
                  _modalDetailRow('Owner email', d.email.isEmpty ? 'hello@nonnarosa.hu' : d.email),
                  _modalDetailRow('Restaurant name', d.restaurantName.isEmpty ? 'Trattoria Nonna Rosa' : d.restaurantName),
                  _modalDetailRow('Category', d.category.isEmpty ? 'Italian' : d.category),
                  _modalDetailRow('Address', d.address.isEmpty ? 'Fő utca 12, Hungary' : d.address),
                  if (d.businessDetail.isNotEmpty)
                    _modalDetailRow('Business detail', d.businessDetail),
                  if (d.uploadedFileName != null)
                    _modalDetailRow('Document', d.uploadedFileName!),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
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

  Widget _modalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.text,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data ?? RestaurantRegistrationData();
    final restaurantName =
        d.restaurantName.trim().isEmpty ? 'Trattoria Nonna Rosa' : d.restaurantName;
    final category = d.category.trim().isEmpty ? 'Italian' : d.category;
    final address =
        d.address.trim().isEmpty ? 'Fő utca 12, Hungary' : d.address;
    final email =
        d.email.trim().isEmpty ? 'hello@nonnarosa.hu' : d.email;
    final initials = _formatInitials(restaurantName);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Top Bar with Logo & Logout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppAssets.logo,
                    width: 64,
                    fit: BoxFit.contain,
                  ),
                  InkWell(
                    onTap: () {
                      _autoTimer?.cancel();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: AppColors.navy,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Log out',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Hero section with amber clock disc
              Center(
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: const BoxDecoration(
                    color: AppColors.amberSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 56,
                      color: AppColors.amber,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Application under review',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your restaurant application has been submitted and is waiting for review.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.45,
                    color: AppColors.text,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Summary card
              GestureDetector(
                onTap: _navigateToApproved,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      // Header row: Logo + Name + Category/Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E4A3A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurantName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$category · $address',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.text,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.line),
                      const SizedBox(height: 12),

                      // Email row
                      _buildSummaryRow('Email', email),
                      const SizedBox(height: 8),

                      // Submitted date row
                      _buildSummaryRow('Submitted', '29 Sep 2026'),
                      const SizedBox(height: 8),

                      // Status row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.text,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amberSoft,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Pending review',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8A5300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Actions: Ghost button + link
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _showSubmittedDetails(context, d),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'View submitted details',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Support email: support@rivjuuu.com'),
                        backgroundColor: AppColors.navy,
                      ),
                    );
                  },
                  child: Text(
                    'Contact support',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.text,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
