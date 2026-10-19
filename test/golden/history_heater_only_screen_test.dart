import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/analytics_screen.dart';
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

  testWidgets('history_heater_only_screen_golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1091));
    DemoSession.role.value = DemoRole.owner;

    final repository = MockSemsRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 1091,
          child: AnalyticsScreen(
            repository: repository,
            initialRange: 'Hour',
            initialAppliance: 'Heater',
            bottomNavigationBar: AppBottomNav(
              selectedIndex: 2,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile(
        'screens/history_heater_only_screen_updated.png',
      ),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
