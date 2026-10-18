// Implements Figma frames: "Onboarding 1" through "Onboarding 5".
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller = PageController();
  int page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
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
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => page = i),
                itemBuilder: (context, index) {
                  final item = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            color: colors.brandTint,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: colors.brandPrimary,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: index == 0
                                  ? SvgPicture.asset(
                                      AppAssets.onboardingSocket,
                                      width: 48,
                                      height: 48,
                                    )
                                  : Icon(
                                      item.$3,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 38),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: colors.textSecondary,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  );
                },
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
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == page ? 24 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == page
                                ? colors.brandPrimary
                                : colors.border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: page == slides.length - 1 ? 'Get started' : 'Next',
                    onPressed: () {
                      if (page < slides.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _signIn();
                      }
                    },
                  ),
                  if (page == slides.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: _enterDemo,
                        child: const Text('Use without an account'),
                      ),
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
