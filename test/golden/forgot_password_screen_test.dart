import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/features/views/auth_screens.dart';

Future<void> loadAppFonts() async {
  final interLoader = FontLoader('Inter');
  interLoader.addFont(
    File('assets/fonts/Inter-Variable.ttf')
        .readAsBytes()
        .then((b) => ByteData.sublistView(b)),
  );
  await interLoader.load();

  final monoLoader = FontLoader('JetBrains Mono');
  monoLoader.addFont(
    File('assets/fonts/JetBrainsMono-Variable.ttf')
        .readAsBytes()
        .then((b) => ByteData.sublistView(b)),
  );
  await monoLoader.load();

  final iconsLoader = FontLoader('MaterialIcons');
  iconsLoader.addFont(
    File(
      r'D:\flutter_env\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf',
    ).readAsBytes().then((b) => ByteData.sublistView(b)),
  );
  await iconsLoader.load();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testWidgets('forgot_password_enter_email', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SizedBox(
          width: 390,
          height: 844,
          child: ForgotPasswordScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ForgotPasswordScreen),
      matchesGoldenFile('screens/forgot_password_enter_email.png'),
    );

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('forgot_password_sent', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SizedBox(
          width: 390,
          height: 844,
          child: ForgotPasswordScreen(
            initialEmail: 'owner@sems.app',
            initialSent: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ForgotPasswordScreen),
      matchesGoldenFile('screens/forgot_password_sent.png'),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
