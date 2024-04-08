import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/timer/types/timer.dart';

const List<ListSortOption<ClockTimer>> timerSortOptions = [
  ListSortOption("Remaining Time Descending", "9-1", sortRemainingTimeDescending),
  ListSortOption("Remaining Time Ascending", "1-9", sortRemainingTimeAscending),
  ListSortOption("Duration Descending", "5:00-1:00", sortTotalDurationDescending),
  ListSortOption("Duration Ascending", "1:00-5:00", sortTotalDurationAscending),
  ListSortOption("Name Ascending", "A-Z", sortNameAscending),
  ListSortOption("Name Descending", "Z-A", sortNameDescending),

];

int sortRemainingTimeAscending(ClockTimer a, ClockTimer b) {
  return a.remainingMilliseconds.compareTo(b.remainingMilliseconds);
 
}

int sortRemainingTimeDescending(ClockTimer a, ClockTimer b) {
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


