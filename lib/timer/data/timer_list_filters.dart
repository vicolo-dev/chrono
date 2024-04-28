import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/timer.dart';

final List<ListFilterItem<ClockTimer>> timerListFilters = [
  ListFilterSelect<ClockTimer>("State", [
    ListFilter(
      'Running',
      (timer) => timer.isRunning,
    ),
    ListFilter(
      'Paused',
      (timer) => timer.isPaused,
    ),
    ListFilter(
      'Stopped',
      (timer) => timer.isStopped,
    ),
  ]),
  //
  DynamicListFilterMultiSelect("Tags", () {
    final tags = loadListSync<Tag>("tags");
    return tags.map((tag) {
      return ListFilter<ClockTimer>(
        tag.name,
        (timer) => timer.tags.any((element) => element.id == tag.id),
        id: tag.id,
      );
    }).toList();
  }),
];
