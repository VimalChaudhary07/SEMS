import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/more_home_screen.dart';

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

  testWidgets('appliance_overview_offline_screen_golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1418));
    DemoSession.role.value = DemoRole.owner;

    final repository = MockSemsRepository();
    final refrigerator = repository.appliances.firstWhere(
      (appliance) => appliance.id == 'refrigerator',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 1418,
          child: ApplianceOverviewScreen(
            appliance: refrigerator,
            repository: repository,
            onChanged: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await expectLater(
      find.byType(ApplianceOverviewScreen),
      matchesGoldenFile('screens/appliance_overview_offline_screen_updated.png'),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
