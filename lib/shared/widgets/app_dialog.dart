// Implements Figma component: confirm dialog with optional danger action.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmText,
    this.cancelText = 'Cancel',
    this.danger = false,
    this.onConfirm,
  });

  final String title;
  final String body;
  final String confirmText;
  final String cancelText;
  final bool danger;
  final VoidCallback? onConfirm;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String body,
    required String confirmText,
    String cancelText = 'Cancel',
    bool danger = false,
  }) => showDialog<bool>(
    context: context,
    builder: (context) => AppDialog(
      title: title,
      body: body,
      confirmText: confirmText,
      cancelText: cancelText,
      danger: danger,
      onConfirm: () => Navigator.of(context).pop(true),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
      ),
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        FilledButton(
          style: danger
              ? FilledButton.styleFrom(
                  backgroundColor: colors.statusFault,
                  foregroundColor: Colors.white,
                )
              : null,
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}
