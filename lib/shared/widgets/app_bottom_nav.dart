// Implements Figma component: five-tab application bottom navigation.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_text.dart';
import 'component_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = <(String, String)>[
    ('Dashboard', AppAssets.iconHome),
    ('Devices', AppAssets.iconPlug),
    ('History', AppAssets.iconChart),
    ('Alerts', AppAssets.iconBell),
    ('More', AppAssets.iconGrid),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final activeIndex = selectedIndex.clamp(0, _items.length - 1);
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: _NavItem(
                label: _items[i].$1,
                asset: _items[i].$2,
                isSelected: i == activeIndex,
                onTap: () => onDestinationSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String asset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 28,
            decoration: BoxDecoration(
              color: isSelected ? colors.brandTint : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              asset,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isSelected ? colors.brandPrimary : colors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.brandPrimary : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
