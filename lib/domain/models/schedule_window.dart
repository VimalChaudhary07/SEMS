// Represents a recurring local schedule window and its validation result.
class ScheduleWindow {
  const ScheduleWindow({
    required this.startMinute,
    required this.endMinute,
    required this.days,
  });

  final int startMinute;
  final int endMinute;
  final Set<int> days;
}

class ScheduleValidation {
  const ScheduleValidation({this.error});

  final String? error;

  bool get isValid => error == null;
}

ScheduleValidation validateScheduleWindows(List<ScheduleWindow> windows) {
  for (final window in windows) {
    if (window.startMinute < 0 ||
        window.startMinute >= 1440 ||
        window.endMinute < 0 ||
        window.endMinute >= 1440) {
      return const ScheduleValidation(error: 'Schedule time is invalid.');
    }
    if (window.days.isEmpty) {
      return const ScheduleValidation(
        error: 'Select at least one day for every schedule.',
      );
    }
    if (window.days.any((day) => day < 1 || day > 7)) {
      return const ScheduleValidation(error: 'Schedule day is invalid.');
    }
  }
  for (var left = 0; left < windows.length; left++) {
    for (var right = left + 1; right < windows.length; right++) {
      final a = windows[left];
      final b = windows[right];
      if (_overlaps(a, b)) {
        return const ScheduleValidation(
          error: 'Schedule intervals cannot overlap on the same day.',
        );
      }
    }
  }
  return const ScheduleValidation();
}

bool _overlaps(ScheduleWindow a, ScheduleWindow b) {
  const minutesPerDay = 1440;
  const minutesPerWeek = minutesPerDay * 7;
  for (final aDay in a.days) {
    final aStart = (aDay - 1) * minutesPerDay + a.startMinute;
    final aEnd =
        (aDay - 1) * minutesPerDay +
        (a.endMinute <= a.startMinute
            ? a.endMinute + minutesPerDay
            : a.endMinute);
    for (final bDay in b.days) {
      final bStart = (bDay - 1) * minutesPerDay + b.startMinute;
      final bEnd =
          (bDay - 1) * minutesPerDay +
          (b.endMinute <= b.startMinute
              ? b.endMinute + minutesPerDay
              : b.endMinute);
      for (final weekOffset in [-minutesPerWeek, 0, minutesPerWeek]) {
        final shiftedStart = bStart + weekOffset;
        final shiftedEnd = bEnd + weekOffset;
        if (aStart < shiftedEnd && shiftedStart < aEnd) return true;
      }
    }
  }
  return false;
}
