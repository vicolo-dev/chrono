import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/timer.dart';

Timer getTimerById(id) {
  final List<Timer> timers = loadList('timers');
  return timers.firstWhere((timer) => timer.id == id);
}
