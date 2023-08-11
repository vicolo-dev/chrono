import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/timer/types/timer.dart';

final List<ListFilter<ClockTimer>> timerListFilters = [
  ListFilter(
    'All',
    (timer) => true,
  ),
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
];
