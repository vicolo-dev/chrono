import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/utils/date_time.dart';

final List<ListFilter<Alarm>> alarmListFilters = [
  ListFilter(
    'All',
    (alarm) => true,
  ),
  ListFilter(
    'Today',
    (alarm) {
      if (alarm.currentScheduleDateTime == null) return false;
      return alarm.currentScheduleDateTime!.isToday();
    },
  ),
  ListFilter('Tomorrow', (alarm) {
    if (alarm.currentScheduleDateTime == null) return false;
    return alarm.currentScheduleDateTime!.isTomorrow();
  }),
  ListFilter(
    'Snoozed',
    (alarm) => alarm.isSnoozed,
  ),
  ListFilter(
    'Disabled',
    (alarm) => !alarm.isEnabled,
  ),
  ListFilter(
    'Completed',
    (alarm) => alarm.isFinished,
  ),
];
