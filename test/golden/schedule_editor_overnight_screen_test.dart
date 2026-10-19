import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/domain/models/schedule_record.dart';
import 'package:sems/features/views/schedules_screen.dart';

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

  testWidgets('schedule_editor_overnight_screen_golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 979));
    DemoSession.role.value = DemoRole.owner;

    final repository = MockSemsRepository();
    final schedules = await repository.getSchedules();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 979,
          child: ScheduleEditorScreen(
            repository: repository,
            schedules: schedules,
            initialKind: 'overnight',
            initialName: 'Night fan',
            initialApplianceId: 'fan',
            initialDays: const [
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday',
              'sunday',
            ],
            initialIntervals: const [
              ScheduleInterval(startTime: '23:00', endTime: '06:00'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await expectLater(
      find.byType(ScheduleEditorScreen),
      matchesGoldenFile('screens/schedule_editor_overnight_screen_updated.png'),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
