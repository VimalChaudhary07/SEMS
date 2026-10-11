// Implements Figma component: 46 by 28 toggle.
import 'package:flutter/material.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    toggled: value,
    child: SizedBox(
      width: 46,
      height: 28,
      child: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        trackOutlineWidth: const WidgetStatePropertyAll(0),
      ),
    ),
  );
}
