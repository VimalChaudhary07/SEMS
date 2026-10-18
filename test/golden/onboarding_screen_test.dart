import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/features/views/onboarding_screen.dart';

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

  testWidgets('onboarding_screen_slide_1_and_5', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SizedBox(
          width: 390,
          height: 844,
          child: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Slide 1 golden
    await expectLater(
      find.byType(OnboardingScreen),
      matchesGoldenFile('screens/onboarding_1_updated.png'),
    );

    // Navigate to slide 5 (4 clicks on Next)
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    // Slide 5 golden
    await expectLater(
      find.byType(OnboardingScreen),
      matchesGoldenFile('screens/onboarding_5_updated.png'),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
