// Implements Figma frames: "Onboarding 1" through "Onboarding 5".
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int page = 0;
  static const slides = [
    (
      'One socket, one appliance',
      'Plug any appliance into a SEMS socket. It measures power and switches the appliance for you.',
      Icons.power_rounded,
    ),
    (
      'See what you really use',
      'Understand energy use by appliance, room, and time with clear local history.',
      Icons.bar_chart_rounded,
    ),
    (
      'Control from anywhere',
      'Switch sockets from the app and see when a device is active.',
      Icons.touch_app_outlined,
    ),
    (
      'Schedules that run offline',
      'Set timers and schedules. They can run locally on a compatible socket.',
      Icons.calendar_month_rounded,
    ),
    (
      'Your data stays yours',
      'This demo keeps sample data on this device. No account or cloud service is required.',
      Icons.shield_outlined,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final item = slides[page];
    final motionDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 320);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _signIn,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: motionDuration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Container(
                        key: ValueKey('art-$page'),
                        width: 240,
                        height: 240,
                        decoration: const BoxDecoration(
                          color: SemsColors.mint,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: SemsColors.forest,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: page == 0
                                ? SvgPicture.asset(
                                    AppAssets.onboardingSocket,
                                    width: 48,
                                    height: 48,
                                  )
                                : Icon(item.$3, color: Colors.white, size: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                    AnimatedSwitcher(
                      duration: motionDuration,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, .12),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: Text(
                        item.$1,
                        key: ValueKey('title-$page'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: SemsColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: motionDuration,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, .08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: Text(
                        item.$2,
                        key: ValueKey('body-$page'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: SemsColors.muted,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < slides.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == page ? 24 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == page
                                ? SemsColors.forest
                                : SemsColors.line,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () {
                      if (page < slides.length - 1) {
                        setState(() => page++);
                      } else {
                        _signIn();
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(
                      page == slides.length - 1 ? 'Get started' : 'Next',
                    ),
                  ),
                  if (page == slides.length - 1)
                    TextButton(
                      onPressed: _enterDemo,
                      child: const Text('Use without an account'),
                    ),
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
