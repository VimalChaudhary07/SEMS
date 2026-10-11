import 'package:flutter/foundation.dart';

enum DemoRole { owner, member }

abstract final class DemoSession {
  static final role = ValueNotifier<DemoRole>(DemoRole.owner);
  static bool get isMember => role.value == DemoRole.member;
}
