// Implements Figma frames: "Sign in", "Sign up", and "Verify email".
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_limits.dart';
import '../../core/utils/app_validators.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  String? previewError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo tile (48x48, radius 16px, #0E9F6E)
                GestureDetector(
                  onLongPress: _choosePreviewError,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E9F6E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.onboardingSocket,
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Heading
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 28,
                    height: 36 / 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1714),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to see your sockets and usage.',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
                if (previewError != null) ...[
                  const SizedBox(height: 14),
                  AppBanner(tone: StatusTone.fault, title: previewError!),
                ],
                const SizedBox(height: 24),

                // Segmented control ("Sign in" / "Sign up")
                Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Active "Sign in" tab
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(16, 22, 20, 0.05),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(16, 22, 20, 0.05),
                                offset: Offset(0, 4),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Inactive "Sign up" tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.signUp),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 36,
                            alignment: Alignment.center,
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Field 1: Email
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconMail,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF55625D),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (v) =>
                              v == null || !AppValidators.isValidEmail(v.trim())
                                  ? 'Enter a valid email address'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Field 2: Password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconLock,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            hintText: '••••••••',
                            hintStyle: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF55625D),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (v) =>
                              v == null ||
                              !AppValidators.hasMinimumPasswordLength(v)
                                  ? 'Password must be at least ${AppLimits.minimumPasswordLength} characters'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // "Forgot password?" Link
                GestureDetector(
                  onTap: () => showForgotPasswordSheet(context),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 13,
                      height: 18 / 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E9F6E),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Primary Button ("Sign in")
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
                    onPressed: _signIn,
                    child: const Text('Sign in'),
                  ),
                ),

                // Divider Row ("── or ──")
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFE1E9E5),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFE1E9E5),
                        ),
                      ),
                    ],
                  ),
                ),

                // Google Button ("G Continue with Google")
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF0F1714),
                      side: const BorderSide(color: Color(0xFFE1E9E5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: _guest,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'G',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2F6FED),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
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
      ),
    );
  }

  void _signIn() {
    if (!form.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Demo sign-in complete. No account service was contacted.',
        ),
      ),
    );
    _guest();
  }

  void _guest() => context.go(AppRoutes.home);

  Future<void> _choosePreviewError() async {
    const errors = {
      'Wrong password': 'The password does not match this sample account.',
      'Email not verified': 'Verify the email address before continuing.',
      'No network':
          'You appear to be offline. Check your connection and retry.',
      'Field errors':
          'Enter a valid email and a password with at least six characters.',
    };
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const ListTile(title: Text('Preview a sign-in error')),
            for (final label in errors.keys)
              ListTile(
                title: Text(label),
                onTap: () => Navigator.pop(context, label),
              ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => previewError = errors[selected]);
    }
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo tile (48x48, radius 16px, #0E9F6E)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.onboardingSocket,
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Heading
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 28,
                    height: 36 / 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1714),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'You will be the Owner of this home.',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 24),

                // Segmented control ("Sign in" / "Sign up")
                Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Inactive "Sign in" tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.signIn);
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 36,
                            alignment: Alignment.center,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Active "Sign up" tab
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(16, 22, 20, 0.05),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(16, 22, 20, 0.05),
                                offset: Offset(0, 4),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Field 1: Full name
                const Text(
                  'Full name',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconUser,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: name,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Asha Verma',
                            hintStyle: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF55625D),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Enter your name' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Field 2: Email
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconMail,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF55625D),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (v) =>
                              v == null || !AppValidators.isValidEmail(v.trim())
                                  ? 'Enter a valid email'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Field 3: Password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconLock,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: pass,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            hintText: '••••••••',
                            hintStyle: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF55625D),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (v) =>
                              v == null ||
                              !AppValidators.hasMinimumPasswordLength(v)
                                  ? 'Use at least ${AppLimits.minimumPasswordLength} characters'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'At least 6 characters',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 16),

                // Primary Button ("Create account")
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
                      if (form.currentState!.validate()) {
                        context.go(AppRoutes.verifyEmail, extra: email.text.trim());
                      }
                    },
                    child: const Text('Create account'),
                  ),
                ),

                // Divider Row ("── or ──")
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFE1E9E5),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFE1E9E5),
                        ),
                      ),
                    ],
                  ),
                ),

                // Google Button ("G Continue with Google")
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF0F1714),
                      side: const BorderSide(color: Color(0xFFE1E9E5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () => context.go(AppRoutes.home),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'G',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2F6FED),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
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
      ),
    );
  }
}

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});
  final String email;
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool resent = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verify email')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PageHeading(
          title: 'Check your inbox',
          subtitle: 'Email verification · local demo',
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: SemsColors.forest,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                widget.email,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'No email is sent by this preview. Use the controls below to explore the verification flow.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SemsColors.muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: 'Mark verified and continue',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: 'Resend verification email',
          variant: AppButtonVariant.secondary,
          onPressed: () => setState(() => resent = true),
        ),
        if (resent)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Demo: verification email resend requested. No email was sent.',
              textAlign: TextAlign.center,
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('Continue without verifying'),
        ),
      ],
    ),
  );
}

Future<void> showForgotPasswordSheet(
  BuildContext context, {
  String? initialEmail,
  bool initialSent = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.45),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: ForgotPasswordSheet(
        initialEmail: initialEmail,
        initialSent: initialSent,
      ),
    ),
  );
}

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({
    super.key,
    this.initialEmail,
    this.initialSent = false,
    this.onClose,
  });

  final String? initialEmail;
  final bool initialSent;
  final VoidCallback? onClose;

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final form = GlobalKey<FormState>();
  late final TextEditingController email;
  late bool sent;

  @override
  void initState() {
    super.initState();
    email = TextEditingController(text: widget.initialEmail ?? '');
    sent = widget.initialSent;
    email.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (email.text.trim().isEmpty) return;
    if (form.currentState != null && !form.currentState!.validate()) return;
    setState(() {
      sent = true;
    });
  }

  void _close() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = email.text.trim().isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grab handle
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E9E5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),

          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reset password',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 18,
                    height: 24 / 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _close,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
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
                ),
              ],
            ),
          ),

          if (!sent) ...[
            Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: Color(0xFF55625D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.iconMail,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF55625D),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              color: Color(0xFF0F1714),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'you@example.com',
                              hintStyle: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 15,
                                color: Color(0xFF55625D),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) => v == null ||
                                    !AppValidators.isValidEmail(v.trim())
                                ? 'Enter a valid email address'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: canSubmit
                      ? const Color(0xFF0E9F6E)
                      : const Color(0xFF0E9F6E).withOpacity(0.45),
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
                onPressed: canSubmit ? _sendResetLink : null,
                child: const Text('Send reset link'),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2F1E8),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.iconMail,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF0E9F6E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check your inbox',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'If an account exists for ${email.text.trim().isEmpty ? "owner@sems.app" : email.text.trim()}, a reset link is on its way.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                onPressed: _close,
                child: const Text('Done'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
    this.initialEmail,
    this.initialSent = false,
  });

  final String? initialEmail;
  final bool initialSent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: SignInScreen(),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.45),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: ForgotPasswordSheet(
                initialEmail: initialEmail,
                initialSent: initialSent,
                onClose: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
