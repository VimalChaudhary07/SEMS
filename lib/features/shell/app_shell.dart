// Implements Figma frame: persistent five-tab application shell.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/mock_data_provider.dart';
import '../../data/repositories/sems_repository.dart';
import '../views/alerts_screen.dart';
import '../views/analytics_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/devices_screen.dart';
import '../views/more_home_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  AppShellState createState() => AppShellState();
}

class AppShellState extends ConsumerState<AppShell> {
  int selectedIndex = 0;

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(semsRepositoryProvider);
    return repository.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load local SEMS data.'),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(semsRepositoryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (value) => _buildShell(value),
    );
  }

  Widget _buildShell(SemsRepository repository) {
    final pages = [
      DashboardScreen(repository: repository),
      DevicesScreen(repository: repository, onChanged: refresh),
      AnalyticsScreen(repository: repository),
      AlertsScreen(repository: repository),
      MoreScreen(repository: repository),
    ];
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const _NavIcon(asset: AppAssets.homeNav),
            selectedIcon: const _NavIcon(
              asset: AppAssets.homeNav,
              selected: true,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: const _NavIcon(asset: AppAssets.plugNav),
            selectedIcon: const _NavIcon(
              asset: AppAssets.plugNav,
              selected: true,
            ),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: const _NavIcon(asset: AppAssets.historyNav),
            selectedIcon: const _NavIcon(
              asset: AppAssets.historyNav,
              selected: true,
            ),
            label: 'History',
          ),
          NavigationDestination(
            icon: const _NavIcon(asset: AppAssets.alertsNav),
            selectedIcon: const _NavIcon(
              asset: AppAssets.alertsNav,
              selected: true,
            ),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: const _NavIcon(asset: AppAssets.moreNav),
            selectedIcon: const _NavIcon(
              asset: AppAssets.moreNav,
              selected: true,
            ),
            label: 'More',
          ),
        ],
      ),
      backgroundColor: SemsColors.canvas,
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.asset, this.selected = false});
  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    asset,
    width: 22,
    height: 22,
    colorFilter: ColorFilter.mode(
      selected ? SemsColors.forest : SemsColors.muted,
      BlendMode.srcIn,
    ),
  );
}
