// Implements Figma component: labeled input, validation and password reveal.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.leadingIcon,
    this.unitSuffix,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.semanticLabel,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? leadingIcon;
  final String? unitSuffix;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? semanticLabel;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final hasError = widget.errorText != null;
    return Semantics(
      label: widget.semanticLabel,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.leadingIcon == null
                  ? null
                  : Icon(widget.leadingIcon),
              suffixText: widget.unitSuffix,
              suffixIcon: widget.obscureText
                  ? TextButton(
                      onPressed: () => setState(() => _obscured = !_obscured),
                      child: Text(_obscured ? 'Show' : 'Hide'),
                    )
                  : hasError
                  ? Icon(Icons.error_outline, color: colors.statusFault)
                  : null,
              errorText: widget.errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.input),
                borderSide: BorderSide(
                  color: hasError ? colors.statusFault : colors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.input),
                borderSide: BorderSide(
                  color: hasError ? colors.statusFault : colors.brandPrimary,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.input),
                borderSide: BorderSide(color: colors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
