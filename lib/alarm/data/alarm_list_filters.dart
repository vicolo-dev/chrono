import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/timer/types/timer_preset.dart';

final List<ListFilterItem<Alarm>> alarmListFilters = [
  ListFilterSelect("Date", [
    // ListFilter(
    //   'All',
    //   (alarm) => true,
    // ),
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
  ]),
  ListFilterSelect("State", [
    // ListFilter(
    //   'All',
    //   (alarm) => true,
    // ),
    ListFilter(
      'Active',
      (alarm) => alarm.isEnabled && !alarm.isFinished,
    ),
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
  ]),
  // DynamicListFilterMultiSelect("Tags", () {
  //   final tags = loadListSync<Tag>("tags");
  //   return [
  //     ListFilter(
  //       'All',
  //       (alarm) => true,
  //     ),
  //     ...tags.map((tag) {
  //       return ListFilter(
  //         tag.name,
  //         (alarm) => alarm.tags.contains(tag.id),
  //       );
  //     })
  //   ];
  // }),
];
