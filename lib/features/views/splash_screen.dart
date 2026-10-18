// Implements Figma frame: "Splash".
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_durations.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _transition;

  @override
  void initState() {
    super.initState();
    _transition = Timer(AppDurations.splash, () {
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _transition?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 112,
                      height: 112,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.splashOuterRing,
                            width: 112,
                            height: 112,
                          ),
                          SvgPicture.asset(
                            AppAssets.splashInnerRing,
                            width: 104,
                            height: 104,
                          ),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: colors.brandPrimary,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              AppAssets.splashSocket,
                              width: 46,
                              height: 46,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SEMS',
                      style: TextStyle(
                        fontSize: 34,
                        height: 40 / 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Smart Energy Monitoring Socket',
                      style: TextStyle(
                        fontSize: 13,
                        height: 18 / 13,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 56),
                    const SizedBox(
                      width: 176,
                      child: AppProgressBar(value: 0.5, height: 4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Signing in…',
                      style: TextStyle(
                        fontSize: 13,
                        height: 18 / 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'v1.0.0',
                style: AppText.mono.copyWith(color: colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
