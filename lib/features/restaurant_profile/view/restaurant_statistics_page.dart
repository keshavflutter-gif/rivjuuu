import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Restaurant Statistics page matching [statistics.html]
class RestaurantStatisticsPage extends StatefulWidget {
  const RestaurantStatisticsPage({super.key});

  @override
  State<RestaurantStatisticsPage> createState() =>
      _RestaurantStatisticsPageState();
}

class _RestaurantStatisticsPageState extends State<RestaurantStatisticsPage> {
  int _selectedFilterIndex = 1; // 0: 7 days, 1: 30 days, 2: Custom

  // Dynamic values that update when filter changes
  String _profileViews = '9,840';
  String _profileViewsDelta = '+12%';
  bool _profileViewsUp = true;

  String _redemptions = '317';
  String _redemptionsDelta = '+9%';
  bool _redemptionsUp = true;

  String _repeatRate = '37%';
  String _repeatDelta = '−2 pts';
  bool _repeatUp = false;

  String _pointsStats = '12.5k / 4.4k';

  List<_WeeklyBarData> _weeklyBars = [
    _WeeklyBarData(label: '16 Sep', value: 58, isHighlight: false),
    _WeeklyBarData(label: '23 Sep', value: 71, isHighlight: false),
    _WeeklyBarData(label: '30 Sep', value: 84, isHighlight: false),
    _WeeklyBarData(label: '7 Oct', value: 104, isHighlight: true),
  ];

  void _onFilterSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFilterIndex = index;
      if (index == 0) {
        // 7 days
        _profileViews = '2,310';
        _profileViewsDelta = '+6%';
        _profileViewsUp = true;
        _redemptions = '84';
        _redemptionsDelta = '+14%';
        _redemptionsUp = true;
        _repeatRate = '41%';
        _repeatDelta = '+3 pts';
        _repeatUp = true;
        _pointsStats = '3.2k / 1.1k';
        _weeklyBars = [
          _WeeklyBarData(label: 'Mon', value: 9, isHighlight: false),
          _WeeklyBarData(label: 'Wed', value: 14, isHighlight: false),
          _WeeklyBarData(label: 'Fri', value: 23, isHighlight: false),
          _WeeklyBarData(label: 'Sun', value: 38, isHighlight: true),
        ];
      } else if (index == 1) {
        // 30 days (Default matching statistics.html)
        _profileViews = '9,840';
        _profileViewsDelta = '+12%';
        _profileViewsUp = true;
        _redemptions = '317';
        _redemptionsDelta = '+9%';
        _redemptionsUp = true;
        _repeatRate = '37%';
        _repeatDelta = '−2 pts';
        _repeatUp = false;
        _pointsStats = '12.5k / 4.4k';
        _weeklyBars = [
          _WeeklyBarData(label: '16 Sep', value: 58, isHighlight: false),
          _WeeklyBarData(label: '23 Sep', value: 71, isHighlight: false),
          _WeeklyBarData(label: '30 Sep', value: 84, isHighlight: false),
          _WeeklyBarData(label: '7 Oct', value: 104, isHighlight: true),
        ];
      } else {
        // Custom
        _profileViews = '14,200';
        _profileViewsDelta = '+18%';
        _profileViewsUp = true;
        _redemptions = '452';
        _redemptionsDelta = '+15%';
        _redemptionsUp = true;
        _repeatRate = '42%';
        _repeatDelta = '+5 pts';
        _repeatUp = true;
        _pointsStats = '18.2k / 6.1k';
        _weeklyBars = [
          _WeeklyBarData(label: 'Aug', value: 68, isHighlight: false),
          _WeeklyBarData(label: 'Sep', value: 92, isHighlight: false),
          _WeeklyBarData(label: 'Oct', value: 115, isHighlight: false),
          _WeeklyBarData(label: 'Nov', value: 142, isHighlight: true),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top Bar (.bar, style="padding-top: 4px")
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back round button (.round)
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
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
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),

                  // Title (.bar__title)
                  Text(
                    'Statistics',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),

                  // Spacer (.spacer)
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // Chips Bar (.chips, style="margin-top: 8px")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip(0, '7 days'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, '30 days'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Custom', icon: Icons.calendar_today_outlined),
                ],
              ),
            ),

            // Scrollable Content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. 2x2 KPI Grid (.statgrid)
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            label: 'Profile views',
                            value: _profileViews,
                            delta: _profileViewsDelta,
                            isUp: _profileViewsUp,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildKpiCard(
                            label: 'Redemptions',
                            value: _redemptions,
                            delta: _redemptionsDelta,
                            isUp: _redemptionsUp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            label: 'Repeat customers',
                            value: _repeatRate,
                            delta: _repeatDelta,
                            isUp: _repeatUp,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildKpiCard(
                            label: 'Points earned / used',
                            value: _pointsStats,
                            delta: 'loyalty',
                            isDeltaNeutral: true,
                            valueFontSize: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 2. Weekly Bar Chart (.chart)
                    _buildWeeklyChartCard(),

                    const SizedBox(height: 12),

                    // 3. Coupon Performance Ranking Card (.sec-card)
                    _buildCouponPerformanceCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label, {IconData? icon}) {
    final isSelected = _selectedFilterIndex == index;

    return GestureDetector(
      onTap: () => _onFilterSelected(index),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required String delta,
    bool isUp = true,
    bool isDeltaNeutral = false,
    double valueFontSize = 24,
  }) {
    Color deltaColor = isUp ? const Color(0xFF1F7A45) : const Color(0xFFFE552E);
    if (isDeltaNeutral) {
      deltaColor = AppColors.text;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: valueFontSize,
              height: 30 / valueFontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.navy,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDeltaNeutral) ...[
                Icon(
                  isUp
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 14,
                  color: deltaColor,
                ),
                const SizedBox(width: 3),
              ],
              Text(
                delta,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: deltaColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChartCard() {
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
          // Chart head (.chart__head)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Redemptions',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'Last 4 weeks',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Painted SVG-accurate Bar Chart
          SizedBox(
            height: 145,
            child: CustomPaint(
              size: const Size(double.infinity, 145),
              painter: _WeeklyBarChartPainter(
                data: _weeklyBars,
                maxValue: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponPerformanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Coupon performance',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'Redemptions',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildRankRow(
            rank: '1',
            title: '20% off your whole bill',
            fraction: 1.0,
            value: '142',
            rate: '4.1% rate',
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),

          _buildRankRow(
            rank: '2',
            title: 'Free tiramisu with any main',
            fraction: 0.62,
            value: '88',
            rate: '3.2% rate',
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),

          _buildRankRow(
            rank: '3',
            title: 'Second Margherita free',
            fraction: 0.36,
            value: '51',
            rate: '2.7% rate',
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),

          _buildRankRow(
            rank: '4',
            title: 'Aperol spritz for 1,500 HUF',
            fraction: 0.25,
            value: '36',
            rate: '1.9% rate',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow({
    required String rank,
    required String title,
    required double fraction,
    required String value,
    required String rate,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank number (.rank__n)
          SizedBox(
            width: 24,
            child: Text(
              rank,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Body (.rank__body)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Progress bar (.bar8)
                Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ECE2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: constraints.maxWidth * fraction,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // End (.rank__end)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                rate,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyBarData {
  final String label;
  final int value;
  final bool isHighlight;

  const _WeeklyBarData({
    required this.label,
    required this.value,
    required this.isHighlight,
  });
}

/// Custom painter matching SVG weekly chart in [statistics.html]
class _WeeklyBarChartPainter extends CustomPainter {
  final List<_WeeklyBarData> data;
  final int maxValue;

  _WeeklyBarChartPainter({
    required this.data,
    this.maxValue = 120,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const bottomLabelHeight = 22.0;
    const topValueHeight = 22.0;
    final chartHeight = size.height - bottomLabelHeight - topValueHeight;

    final gridPaint = Paint()
      ..color = const Color(0xFFECE4D6)
      ..strokeWidth = 1.0;

    final baselinePaint = Paint()
      ..color = const Color(0xFFD8CFBF)
      ..strokeWidth = 1.0;

    // Grid lines at 120 (top), 60 (mid), 0 (bottom)
    final y120 = topValueHeight;
    final y60 = topValueHeight + (chartHeight / 2);
    final y0 = topValueHeight + chartHeight;

    canvas.drawLine(Offset(0, y120), Offset(size.width, y120), gridPaint);
    canvas.drawLine(Offset(0, y60), Offset(size.width, y60), gridPaint);
    canvas.drawLine(Offset(0, y0), Offset(size.width, y0), baselinePaint);

    // Grid axis text on right
    _drawText(
      canvas,
      '120',
      Offset(size.width, y120 - 12),
      const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8B8B93),
      ),
      textAlign: TextAlign.right,
    );

    _drawText(
      canvas,
      '60',
      Offset(size.width, y60 - 12),
      const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8B8B93),
      ),
      textAlign: TextAlign.right,
    );

    // Draw 4 Bars
    final barCount = data.length;
    final slotWidth = size.width / barCount;
    const barWidth = 44.0;

    for (int i = 0; i < barCount; i++) {
      final item = data[i];
      final centerX = slotWidth * i + (slotWidth / 2);
      final barHeight = (item.value / maxValue) * chartHeight;
      final barTop = y0 - barHeight;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - (barWidth / 2), barTop, barWidth, barHeight),
        const Radius.circular(8),
      );

      final barPaint = Paint()
        ..color = item.isHighlight
            ? AppColors.coral // #fe552e
            : const Color(0xFFF8D9CF); // #f8d9cf

      canvas.drawRRect(barRect, barPaint);

      // Value label on top of bar
      _drawText(
        canvas,
        '${item.value}',
        Offset(centerX, barTop - 16),
        TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: item.isHighlight ? FontWeight.w700 : FontWeight.w500,
          color: item.isHighlight
              ? AppColors.navy
              : const Color(0xFF8B8B93),
        ),
        textAlign: TextAlign.center,
      );

      // Date label below baseline
      _drawText(
        canvas,
        item.label,
        Offset(centerX, y0 + 6),
        const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8B8B93),
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    TextAlign textAlign = TextAlign.left,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    )..layout();

    double dx = offset.dx;
    if (textAlign == TextAlign.center) {
      dx -= textPainter.width / 2;
    } else if (textAlign == TextAlign.right) {
      dx -= textPainter.width;
    }

    textPainter.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.maxValue != maxValue;
  }
}

