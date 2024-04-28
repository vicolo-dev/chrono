import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';

final List<ListFilterItem<Alarm>> alarmListFilters = [
  ListFilterSelect("Date", [
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
   //
  DynamicListFilterMultiSelect("Tags", () {
    final tags = loadListSync<Tag>("tags");
    return tags.map((tag) {
        return ListFilter<Alarm>(
          tag.name,
          (alarm) => alarm.tags.any((element) => element.id == tag.id),
          id: tag.id,
        );
      }).toList();
  }),
 ];
