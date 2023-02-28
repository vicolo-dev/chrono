import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> updateTimer(int scheduleId) async {
  List<ClockTimer> timers = loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  ClockTimer timer = timers[timerIndex];

  if (timer.remainingSeconds <= 0) {
    timer.reset();
  }

  timers[timerIndex] = timer;
  await saveList("timers", timers);
}

Future<void> updateTimers() async {
  List<ClockTimer> timers = loadList("timers");

  print(timers);

  timers.where((timer) => timer.remainingSeconds <= 0).forEach((timer) {
    timer.reset();
  });

  await saveList("timers", timers);
}
