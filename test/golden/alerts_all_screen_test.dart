import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/alerts_screen.dart';
import 'package:sems/shared/widgets/app_bottom_nav.dart';

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

  testWidgets('alerts_all_screen_golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1122));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 1122,
          child: AlertsScreen(
            repository: repo,
            initialFilter: 'All',
            bottomNavigationBar: AppBottomNav(
              selectedIndex: 3,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/alerts_all_screen_updated.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });
}
