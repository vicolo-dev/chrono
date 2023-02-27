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
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';

int ringingAlarmId = -1;
List<int> ringingTimerIds = [];
bool isAlarmUpdating = false;
bool isTimerUpdating = false;

void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  if (!isAlarmUpdating) {
    isAlarmUpdating = true;
    await updateAlarms();
    isAlarmUpdating = false;
  }

  SettingsManager.preferences
      ?.setBool("fullScreenNotificationRecentlyShown", true);

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
    isTimerUpdating = false;
  }

  SettingsManager.preferences
      ?.setBool("fullScreenNotificationRecentlyShown", true);

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

  await initializeAppDataDirectory();
  await SettingsManager.initialize();
  await RingtoneManager.initialize();
  await RingtonePlayer.initialize();
  await initializeAudioSession();

  if (notificationType == ScheduledNotificationType.alarm) {
    triggerAlarm(scheduleId, params);
  } else if (notificationType == ScheduledNotificationType.timer) {
    triggerTimer(scheduleId, params);
  }
}

void stopAlarm(int scheduleId, Map<String, dynamic> params) async {
  if (params['action'] == AlarmStopAction.snooze.toString()) {
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

void stopTimer(int scheduleId, Map<String, dynamic> params) async {
  if (params['action'] == AlarmStopAction.snooze.toString()) {
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

@pragma('vm:entry-point')
void stopScheduledNotification(
    int scheduleId, Map<String, dynamic> params) async {
  // print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");
  RingtonePlayer.stop();

  ScheduledNotificationType type = ScheduledNotificationType.values.firstWhere(
    (element) => element.toString() == params['type'],
  );

  if (type == ScheduledNotificationType.alarm) {
    stopAlarm(scheduleId, params);
  } else if (type == ScheduledNotificationType.timer) {
    stopTimer(scheduleId, params);
  }
}
