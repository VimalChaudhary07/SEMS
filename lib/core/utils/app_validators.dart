// Implements Figma Auth field validation foundations.
import '../constants/app_limits.dart';

abstract final class AppValidators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) => _emailPattern.hasMatch(value);

  static bool hasMinimumPasswordLength(String value) =>
      value.length >= AppLimits.minimumPasswordLength;
}
