// Implements role-aware route guard foundations for Figma Family variants.
import '../../core/session/demo_session.dart';

abstract final class RouteGuards {
  static const ownerOnlyPaths = <String>{
    '/home/appliances/add',
    '/home/backup',
    '/home/billing/edit',
    '/home/devices/add',
    '/home/developer',
    '/home/settings/family/invite',
  };

  static bool isOwnerOnlyPath(String location) =>
      ownerOnlyPaths.contains(location);

  static String? redirectFor({
    required String location,
    required bool isFamily,
  }) {
    if (isFamily && isOwnerOnlyPath(location)) return '/home';
    return null;
  }

  static String? currentRoleRedirect(String location) =>
      redirectFor(location: location, isFamily: DemoSession.isMember);
}
