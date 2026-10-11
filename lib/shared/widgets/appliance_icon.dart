// Implements Figma component: category-aware appliance icon tile.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

enum ApplianceCategory {
  heater,
  fan,
  refrigerator,
  waterHeater,
  airConditioner,
  lighting,
  television,
  other,
}

class ApplianceIcon extends StatelessWidget {
  const ApplianceIcon({
    super.key,
    required this.category,
    this.online = true,
    this.size = 44,
  });

  final ApplianceCategory category;
  final bool online;
  final double size;

  IconData get _icon => switch (category) {
    ApplianceCategory.heater => Icons.local_fire_department_outlined,
    ApplianceCategory.fan => Icons.mode_fan_off_outlined,
    ApplianceCategory.refrigerator => Icons.kitchen_outlined,
    ApplianceCategory.waterHeater => Icons.water_drop_outlined,
    ApplianceCategory.airConditioner => Icons.ac_unit,
    ApplianceCategory.lighting => Icons.lightbulb_outline,
    ApplianceCategory.television => Icons.tv_outlined,
    ApplianceCategory.other => Icons.electrical_services_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Opacity(
      opacity: online ? 1 : .48,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.brandTint,
          borderRadius: BorderRadius.circular(AppRadii.iconTileMax),
        ),
        alignment: Alignment.center,
        child: Icon(_icon, color: colors.brandPrimary, size: size * .5),
      ),
    );
  }
}
