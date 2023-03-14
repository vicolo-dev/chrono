import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> updateTimer(int scheduleId) async {
  List<ClockTimer> timers = await loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  ClockTimer timer = timers[timerIndex];

  if (timer.remainingSeconds <= 0) {
    timer.reset();
  }

  timers[timerIndex] = timer;
  await saveList("timers", timers);
}

Future<void> updateTimers() async {
  List<ClockTimer> timers = await loadList("timers");

  timers.where((timer) => timer.remainingSeconds <= 0).forEach((timer) {
    timer.reset();
  });

  await saveList("timers", timers);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateTimers");
}

Future<void> updateTimerById(
    int scheduleId, void Function(ClockTimer) callback) async {
  List<ClockTimer> timers = await loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  ClockTimer timer = timers[timerIndex];
  callback(timer);
  timers[timerIndex] = timer;
  await saveList("timers", timers);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateTimers");
}
