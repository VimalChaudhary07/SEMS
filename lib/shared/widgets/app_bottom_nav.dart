// Implements Figma component: five-tab application bottom navigation.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = <(String, IconData)>[
    ('Dashboard', Icons.home_outlined),
    ('Devices', Icons.power_outlined),
    ('History', Icons.bar_chart_rounded),
    ('Alerts', Icons.notifications_none_rounded),
    ('More', Icons.grid_view_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return NavigationBar(
      selectedIndex: selectedIndex.clamp(0, _items.length - 1),
      onDestinationSelected: onDestinationSelected,
      backgroundColor: colors.card,
      indicatorColor: Colors.transparent,
      destinations: [
        for (final (label, icon) in _items)
          NavigationDestination(
            label: label,
            icon: Icon(icon),
            selectedIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colors.brandTint,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Icon(icon, color: colors.brandPrimary),
            ),
          ),
      ],
    );
  }
}
