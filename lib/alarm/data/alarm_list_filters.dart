import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<ListFilterItem<Alarm>> alarmListFilters = [
  ListFilterSelect(
    (context) => AppLocalizations.of(context)!.dateFilterGroup,
    [
      ListFilter(
        (context) => AppLocalizations.of(context)!.todayFilter,
        (alarm) {
          if (alarm.currentScheduleDateTime == null) return false;
          return alarm.currentScheduleDateTime!.isToday();
        },
      ),
      ListFilter((context) => AppLocalizations.of(context)!.tomorrowFilter,
          (alarm) {
        if (alarm.currentScheduleDateTime == null) return false;
        return alarm.currentScheduleDateTime!.isTomorrow();
      }),
    ],
  ),
  ListFilterSelect(
      (context) => AppLocalizations.of(context)!.stateFilterGroup, [
    ListFilter(
      (context) => AppLocalizations.of(context)!.activeFilter,
      (alarm) => alarm.isEnabled && !alarm.isFinished,
    ),
    ListFilter(
      (context) => AppLocalizations.of(context)!.snoozedFilter,
      (alarm) => alarm.isSnoozed,
    ),
    ListFilter(
      (context) => AppLocalizations.of(context)!.disabledFilter,
      (alarm) => !alarm.isEnabled,
    ),
    ListFilter(
      (context) => AppLocalizations.of(context)!.completedFilter,
      (alarm) => alarm.isFinished,
    ),
  ]),
  //
  DynamicListFilterMultiSelect(
      (context) => AppLocalizations.of(context)!.tagsSetting, () {
    final tags = loadListSync<Tag>("tags");
    return tags.map((tag) {
      return ListFilter<Alarm>(
        (context) => tag.name,
        (alarm) => alarm.tags.any((element) => element.id == tag.id),
        id: tag.id,
      );
    }).toList();
  }),
];
