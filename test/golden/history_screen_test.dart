import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/analytics_screen.dart';

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

  testWidgets('history_day_top', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: AnalyticsScreen(repository: repo),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Day'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/history_day_top_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('history_day_bottom', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: AnalyticsScreen(repository: repo),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Day'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/history_day_bottom_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('history_hour_top', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: AnalyticsScreen(repository: repo),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Hour'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/history_hour_top_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });
}
