import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';
import 'package:get_storage/get_storage.dart';

const String stopAlarmPortName = "13";
const String updatePortName = "d";

int ringingAlarmId = -1;
List<int> ringingTimerIds = [];
bool isAlarmUpdating = false;
bool isTimerUpdating = false;

void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  if (!isAlarmUpdating) {
    isAlarmUpdating = true;
    await updateAlarms();
    SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
    sendPort?.send("updateAlarms");
    isAlarmUpdating = false;
  }

  GetStorage().write("fullScreenNotificationRecentlyShown", true);

  if (ringingTimerIds.isNotEmpty) {
    RingtonePlayer.pause();
  }

  if (ringingAlarmId != -1) {
    await AlarmNotificationManager.removeNotification(
        ScheduledNotificationType.alarm);
  }

  RingtonePlayer.playAlarm(getAlarmByScheduleId(scheduleId));

  ringingAlarmId = scheduleId;

  AlarmNotificationManager.showFullScreenNotification(
    ScheduledNotificationType.alarm,
    [ringingAlarmId],
    "Alarm Ringing...",
    TimeOfDayUtils.decode(params['timeOfDay']).formatToString('h:mm a'),
  );
}

void triggerTimer(int scheduleId, Map<String, dynamic> params) async {
  if (!isTimerUpdating) {
    isTimerUpdating = true;
    await updateTimers();
    SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
    sendPort?.send("updateTimers");
    isTimerUpdating = false;
  }

  GetStorage().write("fullScreenNotificationRecentlyShown", true);

  if (ringingAlarmId != -1) {
    RingtonePlayer.pause();
  }

  if (ringingTimerIds.isNotEmpty) {
    await AlarmNotificationManager.removeNotification(
        ScheduledNotificationType.timer);
  }

  ClockTimer timer = getTimerById(scheduleId);

  RingtonePlayer.playTimer(timer);

  ringingTimerIds.add(scheduleId);

  AlarmNotificationManager.showFullScreenNotification(
      ScheduledNotificationType.timer,
      ringingTimerIds,
      "Time's Up!",
      "${ringingTimerIds.length} Timer${ringingTimerIds.length > 1 ? 's' : ''}");
}

@pragma('vm:entry-point')
void triggerScheduledNotification(
    int scheduleId, Map<String, dynamic> params) async {
  print("ringingAlarmId: $ringingAlarmId");
  print("Alarm triggered: $scheduleId");
  // print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.firstWhere(
    (element) => element.toString() == params['type'],
  );

  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, stopAlarmPortName);
  receivePort.listen((message) {
    print("${message[0]} - ${message[1]} - ${message[2]}");
    stopScheduledNotification(message);
  });

  await initializeAppDataDirectory();
  await GetStorage.init();
  await RingtoneManager.initialize();
  await RingtonePlayer.initialize();
  await initializeAudioSession();

  if (notificationType == ScheduledNotificationType.alarm) {
    triggerAlarm(scheduleId, params);
  } else if (notificationType == ScheduledNotificationType.timer) {
    triggerTimer(scheduleId, params);
  }
}

void stopAlarm(int scheduleId, AlarmStopAction action) async {
  if (action == AlarmStopAction.snooze) {
    Alarm alarm = getAlarmByScheduleId(scheduleId);
    Duration snoozeDuration = Duration(minutes: alarm.snoozeLength.floor());

    scheduleSnoozeAlarm(
        scheduleId, snoozeDuration, ScheduledNotificationType.alarm);
  } else {
    updateAlarms();
    if (ringingTimerIds.isNotEmpty) {
      RingtonePlayer.playTimer(getTimerById(ringingTimerIds.first));
    }
  }
  ringingAlarmId = -1;
}

void stopTimer(int scheduleId, AlarmStopAction action) async {
  if (action == AlarmStopAction.snooze) {
    Duration snoozeDuration = const Duration(minutes: 1);
    scheduleSnoozeAlarm(
        scheduleId, snoozeDuration, ScheduledNotificationType.timer);
  } else {
    updateTimers();
    if (ringingAlarmId != -1) {
      RingtonePlayer.playAlarm(getAlarmByScheduleId(ringingAlarmId));
    }
  }
  ringingTimerIds = [];
}

void stopScheduledNotification(List<dynamic> message) {
  int scheduleId = message[0];
  RingtonePlayer.stop();
  AlarmStopAction action = AlarmStopAction.values.firstWhere(
    (element) => element.toString() == message[2],
  );

  ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.firstWhere(
    (element) => element.toString() == message[1],
  );

  if (notificationType == ScheduledNotificationType.alarm) {
    stopAlarm(scheduleId, action);
  } else if (notificationType == ScheduledNotificationType.timer) {
    stopTimer(scheduleId, action);
  }
}
