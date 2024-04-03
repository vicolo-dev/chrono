import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_data.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/stopwatch/logic/update_stopwatch.dart';
import 'package:clock_app/timer/logic/update_timers.dart';

/// Use this method to detect when a new notification or a schedule is created
@pragma("vm:entry-point")
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
  switch (receivedNotification.channelKey) {
    case alarmNotificationChannelKey:
      AlarmNotificationManager.handleNotificationCreated(receivedNotification);
      break;
  }
}

/// Use this method to detect every time that a new notification is displayed
@pragma("vm:entry-point")
Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {}

/// Use this method to detect if the user dismissed a notification
@pragma("vm:entry-point")
Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction) async {
  switch (receivedAction.channelKey) {
    case alarmNotificationChannelKey:
      AlarmNotificationManager.handleNotificationDismiss(receivedAction);
      break;
  }
}

/// Use this method to detect when the user taps on a notification or action button
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  switch (receivedAction.channelKey) {
    case alarmNotificationChannelKey:
      AlarmNotificationManager.handleNotificationAction(receivedAction);
      break;
    case reminderNotificationChannelKey:
      if (receivedAction.buttonKeyPressed == 'alarm_skip') {
        Payload payload = receivedAction.payload!;
        int? scheduleId = int.tryParse(payload['scheduleId']);
        if (scheduleId != null) {
          await updateAlarmById(scheduleId, (alarm) async {
            alarm.setShouldSkip(true);
            // await alarm.update("Skipped alarm");
          });
        }
      } else if (receivedAction.buttonKeyPressed == 'alarm_skip_snooze') {
        Payload payload = receivedAction.payload!;
        int? scheduleId = int.tryParse(payload['scheduleId']);
        if (scheduleId != null) {
          await updateAlarmById(scheduleId, (alarm) async {
            await alarm.cancelSnooze();
            await alarm.update("Skipped snooze");
          });
        }
      }
      // ReminderNotificationManager.handleNotificationAction(receivedAction);
      break;
    case stopwatchNotificationChannelKey:
      switch (receivedAction.buttonKeyPressed) {
        case 'stopwatch_toggle_state':
          await updateStopwatch((stopwatch) async {
            stopwatch.toggleState();
          });
          break;
        case 'stopwatch_lap':
          await updateStopwatch((stopwatch) async {
           stopwatch.addLap();
          });
          break;
        case 'stopwatch_reset':
         await updateStopwatch((stopwatch) async {
           stopwatch.pause();
           stopwatch.reset();
          });
          break;
             }

      break;
    case timerNotificationChannelKey:
      Payload payload = receivedAction.payload!;
      int? scheduleId = int.tryParse(payload['scheduleId']);
      if (scheduleId == null) return;
      switch (receivedAction.buttonKeyPressed) {
        case 'timer_toggle_state':
          await updateTimerById(scheduleId, (timer) async {
            await timer.toggleState();
            await timer.update("onActionReceivedMethod(): Toggle state");
          });
          break;
        case 'timer_add':
          await updateTimerById(scheduleId, (timer) async {
            await timer.addTime();
            await timer.update("onActionReceivedMethod(): Add timer");
          });
          break;
        case 'timer_reset':
          await updateTimerById(scheduleId, (timer) async {
            await timer.reset();
            await timer.update("onActionReceivedMethod(): Reset timer");
          });
          break;
        case 'timer_reset_all':
          await resetAllTimers();
          break;
      }

  }
}
