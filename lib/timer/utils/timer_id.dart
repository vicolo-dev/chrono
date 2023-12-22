import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';

ClockTimer getTimerById(id) {
  final List<ClockTimer> timers = loadListSync('timers');
  return timers.firstWhere((timer) => timer.id == id,
      orElse: () => ClockTimer(TimeDuration.zero));
}
