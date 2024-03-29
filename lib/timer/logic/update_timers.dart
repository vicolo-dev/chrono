import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> cancelAllTimers() async {
  /* List<AlarmEvent> events = (await loadList<AlarmEvent>('alarm_events')).where((event) => event.isActive && event.notificationType == ScheduledNotificationType.timer).toList(); */
  List<ScheduleId> scheduleIds = await loadList<ScheduleId>('timer_schedule_ids');
  for (var scheduleId in scheduleIds) {
    await cancelAlarm(scheduleId.id, ScheduledNotificationType.timer);
  }
}
Future<void> updateTimer(int scheduleId) async {
  await cancelAllTimers();

  List<ClockTimer> timers = await loadList("timers");
  int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  ClockTimer timer = timers[timerIndex];

  if (timer.remainingSeconds <= 0) {
   await timer.reset();
  }

  timers[timerIndex] = timer;
  await saveList("timers", timers);
}

Future<void> updateTimers() async {
  List<ClockTimer> timers = await loadList("timers");

  timers.where((timer) => timer.remainingSeconds <= 0).forEach((timer)async {
    await timer.reset();
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
