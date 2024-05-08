import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


final List<ListSortOption<Alarm>> alarmSortOptions = [
  ListSortOption((context) => AppLocalizations.of(context)!.remainingTimeDesc, sortRemainingTimeDescending),
  ListSortOption((context) => AppLocalizations.of(context)!.remainingTimeAsc, sortRemainingTimeAscending),
  // ListSortOption("Date Descending", "30-1", sortDateDescending),
  // ListSortOption("Date Ascending", "1-30", sortDateAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.nameAsc, sortNameAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.nameDesc, sortNameDescending),
  ListSortOption((context) => AppLocalizations.of(context)!.timeOfDayAsc, sortTimeOfDayAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.timeOfDayDesc, sortTimeOfDayDescending),
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
