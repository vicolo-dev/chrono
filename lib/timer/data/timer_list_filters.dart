import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<ListFilterItem<ClockTimer>> timerListFilters = [
  ListFilterSelect<ClockTimer>(
      (context) => AppLocalizations.of(context)!.stateFilterGroup, [
    ListFilter(
      (context) => AppLocalizations.of(context)!.runningTimerFilter,
      (timer) => timer.isRunning,
    ),
    ListFilter(
      (context) => AppLocalizations.of(context)!.pausedTimerFilter,
      (timer) => timer.isPaused,
    ),
    ListFilter(
      (context) => AppLocalizations.of(context)!.stoppedTimerFilter,
      (timer) => timer.isStopped,
    ),
  ]),
  //
  DynamicListFilterMultiSelect(
      (context) => AppLocalizations.of(context)!.tagsSetting, () {
    final tags = loadListSync<Tag>("tags");
    return tags.map((tag) {
      return ListFilter<ClockTimer>(
        (context) => tag.name,
        (timer) => timer.tags.any((element) => element.id == tag.id),
        id: tag.id,
      );
    }).toList();
  }),
];
