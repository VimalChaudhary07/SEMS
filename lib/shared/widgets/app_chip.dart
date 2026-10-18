// Implements Figma component: selectable Chip.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.count,
    this.height,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final int? count;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onSelected == null ? null : () => onSelected!(!selected),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: Container(
          height: height,
          constraints: height == null ? const BoxConstraints(minHeight: 40) : null,
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: height != null ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.brandPrimary : colors.card,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(
              color: selected ? colors.brandPrimary : colors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? colors.onBrandPrimary
                      : colors.textSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: height != null ? FontWeight.w500 : FontWeight.w600,
                  color: selected ? colors.onBrandPrimary : colors.textPrimary,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 6),
                Container(
                  height: height != null ? 18 : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: height != null ? 5 : 6,
                    vertical: height != null ? 0 : 2,
                  ),
                  alignment: height != null ? Alignment.center : null,
                  decoration: BoxDecoration(
                    color: selected
                        ? (height != null
                            ? Colors.white
                            : colors.onBrandPrimary.withValues(alpha: .18))
                        : colors.raised,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: height != null ? FontWeight.w400 : null,
                      color: selected
                          ? (height != null
                              ? colors.brandPrimary
                              : colors.onBrandPrimary)
                          : (height != null
                              ? colors.textPrimary
                              : colors.textSecondary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppChipRow extends StatelessWidget {
  const AppChipRow({super.key, required this.children, this.spacing = 8});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index != 0) SizedBox(width: spacing),
          children[index],
        ],
      ],
    ),
  );
}
