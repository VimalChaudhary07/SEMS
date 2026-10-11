// Implements Figma 00 Flows entry routes and persistent app shell routing.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/demo_session.dart';
import '../../features/shell/app_shell.dart';
import '../../features/views/auth_screens.dart';
import '../../features/views/onboarding_screen.dart';
import '../../features/views/splash_screen.dart';
import 'route_guards.dart';
import '../routes/routes.dart';

GoRouter createAppRouter() => GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: DemoSession.role,
  redirect: (context, state) =>
      RouteGuards.currentRoleRedirect(state.matchedLocation),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      name: 'sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: 'sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      name: 'verify-email',
      builder: (context, state) {
        final email = state.extra;
        return VerifyEmailScreen(
          email: email is String
              ? email
              : state.uri.queryParameters['email'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const AppShell(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(child: Text(state.error?.toString() ?? state.uri.path)),
  ),
);
