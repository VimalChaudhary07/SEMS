import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/dashboard_screen.dart';
import 'package:sems/shared/widgets/app_bottom_nav.dart';

Future<void> loadAppFonts() async {
  final interLoader = FontLoader('Inter');
  interLoader.addFont(File('assets/fonts/Inter-Variable.ttf').readAsBytes().then((b) => ByteData.sublistView(b)));
  await interLoader.load();

  final iconsLoader = FontLoader('MaterialIcons');
  iconsLoader.addFont(File(r'D:\flutter_env\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf').readAsBytes().then((b) => ByteData.sublistView(b)));
  await iconsLoader.load();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testWidgets('dashboard_screen_top', (tester) async {
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
          child: Scaffold(
            body: DashboardScreen(repository: repo),
            bottomNavigationBar: AppBottomNav(
              selectedIndex: 0,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/dashboard_top.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('dashboard_screen_scrolled', (tester) async {
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
          child: Scaffold(
            body: DashboardScreen(repository: repo),
            bottomNavigationBar: AppBottomNav(
              selectedIndex: 0,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/dashboard_scrolled.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('dashboard_screen_bottom', (tester) async {
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
          child: Scaffold(
            body: DashboardScreen(repository: repo),
            bottomNavigationBar: AppBottomNav(
              selectedIndex: 0,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/dashboard_bottom.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });
}

