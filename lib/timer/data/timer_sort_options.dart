import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<ListSortOption<ClockTimer>> timerSortOptions = [
  ListSortOption((context) => AppLocalizations.of(context)!.remainingTimeDesc, sortRemainingTimeDescending),
  ListSortOption((context) => AppLocalizations.of(context)!.remainingTimeAsc, sortRemainingTimeAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.durationAsc, sortTotalDurationAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.durationDesc, sortTotalDurationDescending),
  ListSortOption((context) => AppLocalizations.of(context)!.nameAsc, sortNameAscending),
  ListSortOption((context) => AppLocalizations.of(context)!.nameDesc, sortNameDescending),

];

int sortRemainingTimeAscending(ClockTimer a, ClockTimer b) {
  if(!a.isRunning && !b.isRunning) {
    return 0;
  } else if(!a.isRunning) {
    return 1;
  } else if(!b.isRunning) {
    return -1;
  }
  return a.remainingMilliseconds.compareTo(b.remainingMilliseconds);
 
}

int sortRemainingTimeDescending(ClockTimer a, ClockTimer b) {
  if(!a.isRunning && !b.isRunning) {
    return 0;
  } else if(!a.isRunning) {
    return 1;
  } else if(!b.isRunning) {
    return -1;
  }
  return b.remainingMilliseconds.compareTo(a.remainingMilliseconds);
}

int sortTotalDurationAscending(ClockTimer a, ClockTimer b) {
  return a.duration.compareTo(b.duration);
}

int sortTotalDurationDescending(ClockTimer a, ClockTimer b) {
  return b.duration.compareTo(a.duration);
}

int sortNameAscending(ClockTimer a, ClockTimer b) {
  return a.label.compareTo(b.label);
}

int sortNameDescending(ClockTimer a, ClockTimer b) {
  return b.label.compareTo(a.label);
}


