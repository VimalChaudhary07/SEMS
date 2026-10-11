// Implements Figma component: Button.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import 'component_theme.dart';

enum AppButtonVariant { primary, secondary, tonal, danger, text }

enum AppButtonSize { small, regular }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.leadingIcon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? leadingIcon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final height = size == AppButtonSize.small ? 40.0 : 48.0;
    final foreground = variant == AppButtonVariant.danger
        ? colors.statusFault
        : colors.brandPrimary;
    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.button),
    );
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      ),
      shape: WidgetStatePropertyAll(shape),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? foreground.withValues(alpha: .45)
            : variant == AppButtonVariant.primary
            ? colors.onBrandPrimary
            : foreground,
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return variant == AppButtonVariant.primary
              ? colors.brandPrimary.withValues(alpha: .45)
              : Colors.transparent;
        }
        return switch (variant) {
          AppButtonVariant.primary => colors.brandPrimary,
          AppButtonVariant.tonal => colors.brandTint,
          AppButtonVariant.danger => colors.statusFault.withValues(alpha: .1),
          _ => Colors.transparent,
        };
      }),
      side: WidgetStatePropertyAll(
        variant == AppButtonVariant.secondary
            ? BorderSide(color: colors.border)
            : BorderSide.none,
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    );
    final button = switch (variant) {
      AppButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: style.copyWith(
          minimumSize: WidgetStatePropertyAll(Size(0, height)),
        ),
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      _ => FilledButton(onPressed: onPressed, style: style, child: child),
    };
    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
