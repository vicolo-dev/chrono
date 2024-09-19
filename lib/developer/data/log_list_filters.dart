import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/developer/types/log.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

final List<ListFilterItem<Log>> logListFilters = [
  ListFilterSelect((context) => AppLocalizations.of(context)!.dateFilterGroup, [
    ListFilter((context) => AppLocalizations.of(context)!.todayFilter,
        (log) => log.dateTime.isToday()),
    ListFilter((context) => AppLocalizations.of(context)!.tomorrowFilter,
        (log) => log.dateTime.isTomorrow()),
  ]),
  ListFilterMultiSelect(
      (context) => AppLocalizations.of(context)!.logTypeFilterGroup, [
    ListFilter((context) => "Debug", (log) => log.level == Level.debug),
    ListFilter((context) => "Trace", (log) => log.level == Level.trace),
    ListFilter((context) => "Info", (log) => log.level == Level.info),
    ListFilter((context) => "Warning", (log) => log.level == Level.warning),
    ListFilter((context) => "Error", (log) => log.level == Level.error),
    ListFilter((context) => "Fatal", (log) => log.level == Level.fatal),
  ]),
];
