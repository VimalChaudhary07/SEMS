// Implements Figma frames: "Sign in", "Sign up", and "Verify email".
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
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
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(AppRoutes.onboarding),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome back',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in to your SEMS account',
            style: TextStyle(color: SemsColors.muted),
          ),
          if (previewError != null) ...[
            const SizedBox(height: 14),
            AppCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: SemsColors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      previewError!,
                      style: const TextStyle(
                        color: SemsColors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 26),
          Form(
            key: form,
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (v) =>
                      v == null || !AppValidators.isValidEmail(v.trim())
                      ? 'Enter a valid email address'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: password,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (v) =>
                      v == null || !AppValidators.hasMinimumPasswordLength(v)
                      ? 'Password must be at least ${AppLimits.minimumPasswordLength} characters'
                      : null,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ForgotPasswordScreen(),
                ),
              ),
              child: const Text('Forgot password?'),
            ),
          ),
          FilledButton(
            onPressed: _signIn,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Sign in'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _guest,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Continue as demo user'),
          ),
          TextButton(
            onPressed: _choosePreviewError,
            child: const Text('Preview a sign-in error state'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('New to SEMS?'),
              TextButton(
                onPressed: () => context.push(AppRoutes.signUp),
                child: const Text('Create account'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const AppCard(
            child: Text(
              'Authentication is a local demo. Sign-in never contacts a server or stores credentials.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
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
  final confirm = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create account')),
    body: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeading(
            title: 'Join SEMS',
            subtitle: 'Create a local demo profile',
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Full name'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v == null || !AppValidators.isValidEmail(v.trim())
                ? 'Enter a valid email'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: pass,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) =>
                v == null || !AppValidators.hasMinimumPasswordLength(v)
                ? 'Use at least ${AppLimits.minimumPasswordLength} characters'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: confirm,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm password'),
            validator: (v) => v != pass.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                context.go(AppRoutes.verifyEmail, extra: email.text.trim());
              }
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Create demo profile'),
          ),
          const SizedBox(height: 14),
          const AppCard(
            child: Text(
              'This form only demonstrates validation. No account is created on a server and the password is discarded.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
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
        FilledButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('Mark verified and continue'),
        ),
        OutlinedButton(
          onPressed: () => setState(() => resent = true),
          child: const Text('Resend verification email'),
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  bool sent = false;
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reset password')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PageHeading(
          title: sent ? 'Check your email' : 'Forgot password?',
          subtitle: sent
              ? 'Demo reset confirmation'
              : 'Enter the email used for your account',
        ),
        const SizedBox(height: 20),
        if (!sent)
          Form(
            key: form,
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Enter a valid email address'
                      : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      setState(() => sent = true);
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Send reset link'),
                ),
              ],
            ),
          )
        else
          const AppCard(
            child: Text(
              'If this were connected to an account service, a reset link would be sent. No email was sent in this local demo.',
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
      ],
    ),
  );
}
