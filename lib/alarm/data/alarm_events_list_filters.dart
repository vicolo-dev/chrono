import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<ListFilterItem<AlarmEvent>> alarmEventsListFilters = [
  ListFilterSelect(
      (context) => AppLocalizations.of(context)!.stateFilterGroup, [
    ListFilter((context) => AppLocalizations.of(context)!.activeFilter,
        (event) => event.isActive),
    ListFilter((context) => AppLocalizations.of(context)!.inactiveFilter,
        (event) => !event.isActive),
  ]),
  ListFilterSelect(
      (context) => AppLocalizations.of(context)!.scheduleDateFilterGroup, [
    ListFilter((context) => AppLocalizations.of(context)!.todayFilter,
        (event) => event.startDate.isToday()),
    ListFilter((context) => AppLocalizations.of(context)!.tomorrowFilter,
        (event) => event.startDate.isTomorrow()),
  ]),
  ListFilterSelect(
      (context) => AppLocalizations.of(context)!.logTypeFilterGroup, [
    ListFilter((context) => AppLocalizations.of(context)!.alarmTitle,
        (event) => event.notificationType == ScheduledNotificationType.alarm),
    ListFilter((context) => AppLocalizations.of(context)!.timerTitle,
        (event) => event.notificationType == ScheduledNotificationType.timer),
  ]),
  ListFilterSelect(
      (context) => AppLocalizations.of(context)!.createdDateFilterGroup, [
    ListFilter((context) => AppLocalizations.of(context)!.todayFilter,
        (event) => event.eventTime.isToday()),
    ListFilter((context) => AppLocalizations.of(context)!.tomorrowFilter,
        (event) => event.eventTime.isTomorrow()),
  ]),
];
