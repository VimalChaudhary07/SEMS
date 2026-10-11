// Implements Figma Auth and 00 Flows foundation behavior tests.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sems/app/router/route_guards.dart';
import 'package:sems/core/constants/app_limits.dart';
import 'package:sems/core/services/id_generator.dart';
import 'package:sems/core/utils/app_formatters.dart';
import 'package:sems/core/utils/app_validators.dart';

void main() {
  group('AppValidators', () {
    test('accepts complete email addresses only', () {
      expect(AppValidators.isValidEmail('owner@sems.app'), isTrue);
      expect(AppValidators.isValidEmail('owner@sems'), isFalse);
      expect(AppValidators.isValidEmail('owner sems.app'), isFalse);
    });

    test('formats currency using the configured INR locale', () {
      expect(AppFormatters.inr(1292), '₹1,292');
    });

    test('uses the configured minimum password length', () {
      expect(
        AppValidators.hasMinimumPasswordLength(
          'a' * AppLimits.minimumPasswordLength,
        ),
        isTrue,
      );
      expect(AppValidators.hasMinimumPasswordLength('short'), isFalse);
    });
  });

  group('RouteGuards', () {
    test('redirects family members away from owner-only routes', () {
      expect(
        RouteGuards.redirectFor(location: '/home/devices/add', isFamily: true),
        '/home',
      );
    });

    test('allows owners to open owner-only routes', () {
      expect(
        RouteGuards.redirectFor(location: '/home/devices/add', isFamily: false),
        isNull,
      );
    });
  });

  test('local id generator returns a fixed-length lowercase id', () {
    final generator = RandomIdGenerator(random: Random(0));
    final id = generator.nextId();

    expect(id, hasLength(20));
    expect(id, matches(RegExp(r'^[a-z0-9]{20}$')));
  });
}
