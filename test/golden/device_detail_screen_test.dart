import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/features/views/device_detail_screen.dart';

Future<void> loadAppFonts() async {
  final interLoader = FontLoader('Inter');
  interLoader.addFont(File('assets/fonts/Inter-Variable.ttf').readAsBytes().then((b) => ByteData.sublistView(b)));
  await interLoader.load();

  final monoLoader = FontLoader('JetBrains Mono');
  monoLoader.addFont(File('assets/fonts/JetBrainsMono-Variable.ttf').readAsBytes().then((b) => ByteData.sublistView(b)));
  await monoLoader.load();

  final iconsLoader = FontLoader('MaterialIcons');
  iconsLoader.addFont(File(r'D:\flutter_env\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf').readAsBytes().then((b) => ByteData.sublistView(b)));
  await iconsLoader.load();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testWidgets('device_detail_top', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();
    final device = repo.devices.first; // Living room socket

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: DeviceDetailScreen(
            device: device,
            repository: repo,
            onChanged: () {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/device_detail_top_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('device_detail_middle', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();
    final device = repo.devices.first;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: DeviceDetailScreen(
            device: device,
            repository: repo,
            onChanged: () {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.drag(find.byType(ListView), const Offset(0, -450));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/device_detail_middle_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('device_detail_bottom', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;
    final repo = MockSemsRepository();
    final device = repo.devices.first;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: DeviceDetailScreen(
            device: device,
            repository: repo,
            onChanged: () {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Remove device'), 200);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('screens/device_detail_bottom_current.png'),
    );
    await tester.binding.setSurfaceSize(null);
  });
}

