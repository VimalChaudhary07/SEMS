// Implements Figma frames: "Onboarding 1" through "Onboarding 5" (Nodes 11:87 to 11:244).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_text.dart';

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final String asset;
  final Color primaryColor;
  final Color tintColor;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.primaryColor,
    required this.tintColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'One socket, one appliance',
      subtitle:
          'Plug any appliance into a SEMS socket. It measures power and switches the appliance for you.',
      asset: AppAssets.onboardingSocket,
      primaryColor: Color(0xFF0E9F6E),
      tintColor: Color(0xFFDDF4EA),
    ),
    _OnboardingSlide(
      title: 'See what you really use',
      subtitle:
          'Voltage, current, power and energy every 10 seconds, measured by the socket itself.',
      asset: AppAssets.onboardingBars,
      primaryColor: Color(0xFF2F6FED),
      tintColor: Color(0xFFE3ECFD),
    ),
    _OnboardingSlide(
      title: 'Control from anywhere',
      subtitle:
          'Switch ON or OFF remotely. We only say it worked once the socket confirms.',
      asset: AppAssets.onboardingPower,
      primaryColor: Color(0xFF2E9E5B),
      tintColor: Color(0xFFE2F1E8),
    ),
    _OnboardingSlide(
      title: 'Schedules that run offline',
      subtitle:
          'Timers and schedules live on the socket, so they keep working without your phone or Wi-Fi.',
      asset: AppAssets.onboardingCalendar,
      primaryColor: Color(0xFFD98A00),
      tintColor: Color(0xFFFCF0D9),
    ),
    _OnboardingSlide(
      title: 'Your data stays yours',
      subtitle:
          'History is stored on your phone. Optionally back it up to your own Google Drive.',
      asset: AppAssets.onboardingShield,
      primaryColor: Color(0xFF7C5CE0),
      tintColor: Color(0xFFECE6FB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (56px) with right-aligned Skip button on slides 1-4
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_page < _slides.length - 1)
                      GestureDetector(
                        key: const ValueKey('onboarding_skip_button'),
                        onTap: _signIn,
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                              color: Color(0xFF55625D),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Illustration (240x240)
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer circle (240x240)
                              Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: slide.tintColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Floating accent dot 1: top-right (12x12 at 198, 12)
                              Positioned(
                                left: 198,
                                top: 12,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: slide.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Floating accent dot 2: bottom-left (20x20 at 12, 204)
                              Positioned(
                                left: 12,
                                top: 204,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: slide.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Center rounded tile: 96x96, radius 28px
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: slide.primaryColor,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  slide.asset,
                                  width: 48,
                                  height: 48,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title (26px Bold #0F1714)
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 26,
                            height: 32 / 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle (15px Regular #55625D)
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 24 / 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer (padding: 8px 24px 32px)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pager dots
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _slides.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _page ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _page
                                  ? const Color(0xFF0E9F6E)
                                  : const Color(0xFFE1E9E5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Primary Button (Next / Get started)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0E9F6E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        textStyle: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        if (_page < _slides.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _signIn();
                        }
                      },
                      child: Text(
                        _page == _slides.length - 1 ? 'Get started' : 'Next',
                      ),
                    ),
                  ),

                  // Secondary Button (Slide 5: "Use without Drive for now")
                  if (_page == _slides.length - 1) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0E9F6E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          textStyle: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _enterDemo,
                        child: const Text('Use without Drive for now'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() => context.go(AppRoutes.signIn);
  void _enterDemo() => context.go(AppRoutes.home);
}
