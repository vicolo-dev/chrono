import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/alarm_isolate.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> cancelAllTimers() async {
  List<ScheduleId> scheduleIds =
      await loadList<ScheduleId>('timer_schedule_ids');
  for (var scheduleId in scheduleIds) {
    await cancelAlarm(scheduleId.id, ScheduledNotificationType.timer);
  }
  scheduleIds.clear();
  await saveList('timer_schedule_ids', scheduleIds);
}

Future<void> resetAllTimers() async {
  await cancelAllTimers();

  List<ClockTimer> timers = await loadList("timers");
  for (var timer in timers) {
    await timer.reset();
    await timer.update("resetAllTimers()");
  }
  await saveList("timers", timers);
  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateTimers");
}

Future<void> updateTimer(int scheduleId, String description) async {
  List<ClockTimer> timers = await loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  ClockTimer timer = timers[timerIndex];

  await timer.update(description);

  timers[timerIndex] = timer;
  await saveList("timers", timers);
}

Future<void> updateTimers(String description) async {
  await cancelAllTimers();

  List<ClockTimer> timers = await loadList("timers");

  for (var timer in timers) {
    await timer.update(description);
  }
  await saveList("timers", timers);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateTimers");
}

Future<void> updateTimerById(
    int scheduleId, Future<void> Function(ClockTimer) callback) async {
  List<ClockTimer> timers = await loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  if (timerIndex == -1) return;
  ClockTimer timer = timers[timerIndex];
  await callback(timer);
  timers[timerIndex] = timer;
  await saveList("timers", timers);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateTimers");
}
