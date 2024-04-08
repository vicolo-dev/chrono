import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';

const List<ListSortOption<Alarm>> alarmSortOptions = [
  ListSortOption(
      "Remaining Time Descending", "9-1", sortRemainingTimeDescending),
  ListSortOption("Remaining Time Ascending", "1-9", sortRemainingTimeAscending),
  ListSortOption("Date Descending", "30-1", sortDateDescending),
  ListSortOption("Date Ascending", "1-30", sortDateAscending),
  ListSortOption("Name Ascending", "A-Z", sortNameAscending),
  ListSortOption("Name Descending", "Z-A", sortNameDescending),
  ListSortOption("Time of Day Ascending", "0:00-12:00", sortTimeOfDayAscending),
  ListSortOption(
      "Time of Day Descending", "12:00-0:00", sortTimeOfDayDescending),
];

int sortRemainingTimeDescending(Alarm a, Alarm b) {
  if (a.currentScheduleDateTime == null && b.currentScheduleDateTime == null) {
    return 0;
  } else if (a.currentScheduleDateTime == null) {
    return 1;
  } else if (b.currentScheduleDateTime == null) {
    return -1;
  }
  final remainingA =
      a.currentScheduleDateTime!.difference(DateTime.now()).inSeconds;
  final remainingB =
      b.currentScheduleDateTime!.difference(DateTime.now()).inSeconds;
  return remainingB.compareTo(remainingA);
}

int sortRemainingTimeAscending(Alarm a, Alarm b) {
  if (a.currentScheduleDateTime == null && b.currentScheduleDateTime == null) {
    return 0;
  } else if (a.currentScheduleDateTime == null) {
    return 1;
  } else if (b.currentScheduleDateTime == null) {
    return -1;
  }
  final remainingA =
      a.currentScheduleDateTime!.difference(DateTime.now()).inSeconds;
  final remainingB =
      b.currentScheduleDateTime!.difference(DateTime.now()).inSeconds;
  return remainingA.compareTo(remainingB);
}

int sortDateDescending(Alarm a, Alarm b) {
  if (a.currentScheduleDateTime == null && b.currentScheduleDateTime == null) {
    return 0;
  } else if (a.currentScheduleDateTime == null) {
    return 1;
  } else if (b.currentScheduleDateTime == null) {
    return -1;
  }
  return b.currentScheduleDateTime!.compareTo(a.currentScheduleDateTime!);
}

int sortDateAscending(Alarm a, Alarm b) {
  if (a.currentScheduleDateTime == null && b.currentScheduleDateTime == null) {
    return 0;
  } else if (a.currentScheduleDateTime == null) {
    return 1;
  } else if (b.currentScheduleDateTime == null) {
    return -1;
  }
  return a.currentScheduleDateTime!.compareTo(b.currentScheduleDateTime!);
}

int sortNameAscending(Alarm a, Alarm b) {
  return a.label.compareTo(b.label);
}

int sortNameDescending(Alarm a, Alarm b) {
  return b.label.compareTo(a.label);
}

int sortTimeOfDayAscending(Alarm a, Alarm b) {
  return a.time.compareTo(b.time);
}

int sortTimeOfDayDescending(Alarm a, Alarm b) {
  return b.time.compareTo(a.time);
}
