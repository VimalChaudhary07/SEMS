import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../data/repositories/sems_repository.dart';

/// Implements Figma Module 10: AI Energy Intelligence
/// Screen 116: AI Energy - 45 days (strong) (Node ID: 21:252)
/// Screen 117: AI Energy - 10 days (Node ID: 21:440)
/// Screen 118: AI Energy - 5 days (Node ID: 21:574)
/// Screen 119: AI Energy - 2 days (Node ID: 21:649)
/// Screen 120: AI - insight details sheet (Node ID: 21:851)
/// Screen 121: AI - settings sheet (Node ID: 21:1105)
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({
    super.key,
    this.repository,
    this.dataDays = 45,
    this.bottomNavigationBar,
    this.showInsightDetailsOnStart = false,
    this.showSettingsOnStart = false,
    this.onBack,
  });

  final SemsRepository? repository;
  final int dataDays;
  final Widget? bottomNavigationBar;
  final bool showInsightDetailsOnStart;
  final bool showSettingsOnStart;
  final VoidCallback? onBack;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late int _dataDays;

  @override
  void initState() {
    super.initState();
    _dataDays = widget.dataDays;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.showInsightDetailsOnStart) {
        _openInsightDetails();
      } else if (widget.showSettingsOnStart) {
        _openSettings();
      }
    });
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => const AiSettingsSheet(),
    );
  }

  void _openInsightDetails() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => const AiInsightDetailsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar (24px)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '09:41',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.iconWifi,
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '100%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Top Bar (56px)
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.iconChevLeft,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'AI Energy',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Calculated on this phone',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _openSettings,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.iconSliders,
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: DemoSession.isMember
                            ? const Color(0xFFEBF5FF)
                            : const Color(0xFFDDF4EA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        DemoSession.isMember ? 'Family' : 'Owner',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: DemoSession.isMember
                              ? const Color(0xFF1E429F)
                              : const Color(0xFF0E9F6E),
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Banner/ai
                    const _AiPrivacyBanner(),
                    const SizedBox(height: 16),

                    // Data coverage
                    _DataCoverageCard(days: _dataDays),
                    const SizedBox(height: 16),

                    // Cards conditional on coverage days
                    if (_dataDays >= 10) ...[
                      // Consumption Forecast
                      const _ConsumptionForecastCard(),
                      const SizedBox(height: 16),

                      // Peak usage periods
                      const _PeakUsagePeriodsCard(),
                      const SizedBox(height: 16),
                    ],

                    if (_dataDays == 2) ...[
                      // Learning state cards for 2 days
                      const _LearningStateCard(),
                      const SizedBox(height: 16),
                      const _MeasuredSoFarCard(),
                      const SizedBox(height: 16),
                    ],

                    if (_dataDays >= 5) ...[
                      // INSIGHTS section
                      _InsightsSection(
                        dataDays: _dataDays,
                        onTapPotentialSaving: _openInsightDetails,
                      ),
                      const SizedBox(height: 16),

                      // APPLIANCE BASELINES section
                      const _ApplianceBaselinesSection(),
                      const SizedBox(height: 16),

                      // Estimated savings available
                      const _EstimatedSavingsCard(),
                      const SizedBox(height: 16),
                    ],

                    // Footer disclaimer
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset(
                            AppAssets.iconShield,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF55625D),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Runs on this phone with a small time-series model plus plain rules. No chatbot, no cloud.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Home indicator
                    Center(
                      child: Container(
                        width: 112,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1714),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Privacy Banner
// -----------------------------------------------------------------------------
class _AiPrivacyBanner extends StatelessWidget {
  const _AiPrivacyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7C5CE0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppAssets.iconSparkle,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFF7C5CE0),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated, not measured',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.54,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Calculated privately on this phone from your own readings. No data leaves your device.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Data Coverage Card
// -----------------------------------------------------------------------------
class _DataCoverageCard extends StatelessWidget {
  const _DataCoverageCard({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color badgeBg;
    final Color badgeText;
    final double progress;
    final Color progressColor;
    final String subtitle;

    if (days >= 30) {
      label = '$days days · Strong';
      badgeBg = const Color(0xFFE2F1E8);
      badgeText = const Color(0xFF2E9E5B);
      progress = 1.0;
      progressColor = const Color(0xFF2E9E5B);
      subtitle = 'Enough history for forecasts and personal baselines.';
    } else if (days >= 10) {
      label = '$days days · Good';
      badgeBg = const Color(0xFFDEF7EC);
      badgeText = const Color(0xFF03543F);
      progress = 0.33;
      progressColor = const Color(0xFF0E9F6E);
      subtitle = 'Enough history for forecasts and personal baselines.';
    } else if (days >= 5) {
      label = '$days days · Basic';
      badgeBg = const Color(0xFFFDF6B2);
      badgeText = const Color(0xFF723B10);
      progress = 0.16;
      progressColor = const Color(0xFFD97706);
      subtitle = 'Anomaly checks are on. Forecasts unlock at 7 days.';
    } else {
      label = '$days days · Collecting';
      badgeBg = const Color(0xFFE5EDF5);
      badgeText = const Color(0xFF4B6B94);
      progress = 0.08;
      progressColor = const Color(0xFFD97706);
      subtitle = 'Unlocks anomaly checks after 3 days and forecasts after 7 days.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Data coverage',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                  height: 1.38,
                ),
              ),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: badgeText,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1EE),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Consumption Forecast Card
// -----------------------------------------------------------------------------
class _ConsumptionForecastCard extends StatelessWidget {
  const _ConsumptionForecastCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconTrend,
                  width: 15,
                  height: 15,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF7C5CE0),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Consumption Forecast',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              const _EstimatedBadge(),
            ],
          ),
          const SizedBox(height: 10),

          // Big Metric
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '248',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 1.28,
                ),
              ),
              SizedBox(width: 6),
              Text(
                'kWh this month',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 1.38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '₹2,480 estimated cost · range 231 to 266 kWh',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
          const SizedBox(height: 10),

          // Chart
          const _AiForecastChartWidget(),
          const SizedBox(height: 10),

          // Footnote
          const Text(
            'Next 7 days, kWh per day. Shaded band is the likely range.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.27,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiForecastChartWidget extends StatelessWidget {
  const _AiForecastChartWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Grid line 1: 10 (y = 20.86)
              Positioned(
                left: 34,
                right: 6,
                top: 20.86,
                child: Container(
                  height: 1,
                  color: const Color(0xFFE1E9E5),
                ),
              ),
              const Positioned(
                left: 14,
                top: 14,
                child: Text(
                  '10',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),

              // Grid line 2: 5.2 (y = 74.43)
              Positioned(
                left: 34,
                right: 6,
                top: 74.43,
                child: Container(
                  height: 1,
                  color: const Color(0xFFE1E9E5),
                ),
              ),
              const Positioned(
                left: 11,
                top: 67,
                child: Text(
                  '5.2',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),

              // Grid line 3: 0.0 (y = 128)
              Positioned(
                left: 34,
                right: 6,
                top: 128,
                child: Container(
                  height: 1,
                  color: const Color(0xFFE1E9E5),
                ),
              ),
              const Positioned(
                left: 11,
                top: 121,
                child: Text(
                  '0.0',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),

              // SVG Series chart
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  AppAssets.aiForecastChart,
                  fit: BoxFit.fill,
                ),
              ),

              // X-axis labels (y = 134)
              Positioned(
                left: 22.5,
                top: 134,
                child: const Text(
                  'Mon',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.36,
                top: 134,
                child: const Text(
                  'Wed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.67,
                top: 134,
                child: const Text(
                  'Fri',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              Positioned(
                right: 6,
                top: 134,
                child: const Text(
                  'Sun',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Peak Usage Periods Card
// -----------------------------------------------------------------------------
class _PeakUsagePeriodsCard extends StatelessWidget {
  const _PeakUsagePeriodsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconClock,
                  width: 15,
                  height: 15,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF7C5CE0),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Peak usage periods',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              const _EstimatedBadge(),
            ],
          ),
          const SizedBox(height: 10),

          // Subcards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Usual peak',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF55625D),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '19:00–22:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1714),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tomorrow',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF55625D),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '20:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1714),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Estimated peak hour',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF55625D),
                          height: 1.27,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Insights Section
// -----------------------------------------------------------------------------
class _InsightsSection extends StatelessWidget {
  const _InsightsSection({
    required this.dataDays,
    required this.onTapPotentialSaving,
  });

  final int dataDays;
  final VoidCallback onTapPotentialSaving;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'INSIGHTS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Insight 1: Abnormal Consumption (High)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  color: const Color(0xFFD64545),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 8, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBE6E6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                AppAssets.iconTrend,
                                width: 15,
                                height: 15,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFD64545),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Abnormal Consumption',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                            ),
                            Container(
                              height: 24,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBE6E6),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.iconAlert,
                                    width: 13,
                                    height: 13,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFD64545),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'HIGH',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFD64545),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Heater is 47% above normal',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                            height: 1.33,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Current 2,200 W, usual 1,500 W',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                            height: 1.38,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Estimated from your personal baseline for this appliance.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                            color: Color(0xFF55625D),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Insight 2: Potential Saving
        GestureDetector(
          onTap: onTapPotentialSaving,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(16, 22, 20, 0.05),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Color.fromRGBO(16, 22, 20, 0.05),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE6FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconFlame,
                        width: 15,
                        height: 15,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF7C5CE0),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Potential Saving',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF55625D),
                        ),
                      ),
                    ),
                    const _EstimatedBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Reduce heater usage 1 hr/day',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Save ₹20/day, ₹600/month, 60 kWh/month',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Insight 3: Wastage Detected (only when dataDays >= 45)
        if (dataDays >= 45) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(16, 22, 20, 0.05),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Color.fromRGBO(16, 22, 20, 0.05),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEDB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconFlame,
                        width: 15,
                        height: 15,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFA88700),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Wastage Detected',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF55625D),
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEDB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconInfo,
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFA88700),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LOW',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA88700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fan ran 9 h while the room was likely empty',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Estimated 2.1 kWh wasted this week',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Appliance Baselines Section
// -----------------------------------------------------------------------------
class _ApplianceBaselinesSection extends StatelessWidget {
  const _ApplianceBaselinesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'APPLIANCE BASELINES',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Row 1: Heater
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconFlame,
                        width: 19,
                        height: 19,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Heater',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 1.33,
                            ),
                          ),
                          Text(
                            'Normal 1,300 to 1,550 W · 2 h/day',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F1E8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconCheck,
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2E9E5B),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Learned',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E9E5B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),

              // Row 2: Fan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconFan,
                        width: 19,
                        height: 19,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Fan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 1.33,
                            ),
                          ),
                          Text(
                            'Normal 40 to 60 W · 8 h/day',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F1E8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconCheck,
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2E9E5B),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Learned',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E9E5B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),

              // Row 3: Refrigerator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconFridge,
                        width: 19,
                        height: 19,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Refrigerator',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 1.33,
                            ),
                          ),
                          Text(
                            'Needs 3 more days of data',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEEF0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Learning',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A8594),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Estimated Savings Card
// -----------------------------------------------------------------------------
class _EstimatedSavingsCard extends StatelessWidget {
  const _EstimatedSavingsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE2F1E8),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              '₹',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E9E5B),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Estimated savings available',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '₹600 per month',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1714),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const _EstimatedBadge(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Helper: Estimated Badge
// -----------------------------------------------------------------------------
class _EstimatedBadge extends StatelessWidget {
  const _EstimatedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.iconSparkle,
            width: 13,
            height: 13,
            colorFilter: const ColorFilter.mode(
              Color(0xFF7C5CE0),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'Estimated',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7C5CE0),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Learning State Card (for 2 days)
// -----------------------------------------------------------------------------
class _LearningStateCard extends StatelessWidget {
  const _LearningStateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconSparkle,
                  width: 15,
                  height: 15,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF7C5CE0),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Learning',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF55625D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Learning your usage pattern',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '5 more days of data recommended',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1EE),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 2 / 7,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C5CE0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '2 of 7 days',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Measured So Far Card (for 2 days)
// -----------------------------------------------------------------------------
class _MeasuredSoFarCard extends StatelessWidget {
  const _MeasuredSoFarCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Measured so far',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF55625D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'kWh',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peak',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF55625D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '1,890',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'W',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Screen 120: AI Insight Details Sheet (Node ID: 21:851)
// -----------------------------------------------------------------------------
class AiInsightDetailsSheet extends StatelessWidget {
  const AiInsightDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9DEDC),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Potential Saving',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  AppAssets.iconClose,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF55625D),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Badges
          Row(
            children: [
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconInfo,
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1E429F),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'INFO',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E429F),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _EstimatedBadge(),
            ],
          ),
          const SizedBox(height: 14),

          // Title
          const Text(
            'Reduce heater usage 1 hr/day',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 14),

          // Metrics table
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
            ),
            child: Column(
              children: [
                _buildMetricRow('Per day', '₹20'),
                const Divider(height: 1, color: Color(0xFFE1E9E5)),
                _buildMetricRow('Per month', '₹600'),
                const Divider(height: 1, color: Color(0xFFE1E9E5)),
                _buildMetricRow('Energy per month', '60 kWh'),
                const Divider(height: 1, color: Color(0xFFE1E9E5)),
                _buildMetricRow('Share of daily use', '25.0%'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // How it was worked out
          const Text(
            'How it was worked out',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Heater runs about 4 h/day against a 2 h/day baseline. Costs use your tariff of ₹7.7 per kWh on average. All figures are estimates.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Open Heater',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAF1EE),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F1714),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Screen 121: AI Settings Sheet (Node ID: 21:1105)
// -----------------------------------------------------------------------------
class AiSettingsSheet extends StatefulWidget {
  const AiSettingsSheet({super.key});

  @override
  State<AiSettingsSheet> createState() => _AiSettingsSheetState();
}

class _AiSettingsSheetState extends State<AiSettingsSheet> {
  bool anomalyAlerts = true;
  bool wastageDetection = true;
  bool savingsSuggestions = true;
  String sensitivity = 'Balanced';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9DEDC),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI settings',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  AppAssets.iconClose,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF55625D),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Toggles Card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
            ),
            child: Column(
              children: [
                _buildToggleRow(
                  title: 'Anomaly alerts',
                  subtitle: 'Notify me about unusual usage',
                  value: anomalyAlerts,
                  onChanged: (v) => setState(() => anomalyAlerts = v),
                ),
                const Divider(height: 1, color: Color(0xFFE1E9E5)),
                _buildToggleRow(
                  title: 'Wastage detection',
                  subtitle: null,
                  value: wastageDetection,
                  onChanged: (v) => setState(() => wastageDetection = v),
                ),
                const Divider(height: 1, color: Color(0xFFE1E9E5)),
                _buildToggleRow(
                  title: 'Savings suggestions',
                  subtitle: null,
                  value: savingsSuggestions,
                  onChanged: (v) => setState(() => savingsSuggestions = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sensitivity
          const Text(
            'Sensitivity',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF55625D),
            ),
          ),
          const SizedBox(height: 8),

          // 3-way toggle: Low | Balanced | High
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildSegmentButton('Low'),
                _buildSegmentButton('Balanced'),
                _buildSegmentButton('High'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Balanced flags usage 30% or more above your baseline.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 20),

          // Reset learned baselines button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE1E9E5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset learned baselines',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF0E9F6E),
            inactiveTrackColor: const Color(0xFFD9DEDC),
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String option) {
    final isSelected = sensitivity == option;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => sensitivity = option),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(16, 22, 20, 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            option,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF0F1714),
            ),
          ),
        ),
      ),
    );
  }
}
