import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/logic/alarm_notifications.dart';
import 'package:clock_app/notifications/types/alarm_notification_arguments.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_data.dart';
import 'package:clock_app/stopwatch/logic/update_stopwatch.dart';
import 'package:clock_app/system/logic/initialize_isolate.dart';
import 'package:clock_app/timer/logic/update_timers.dart';

/// Use this method to detect when a new notification or a schedule is created
@pragma("vm:entry-point")
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
  await initializeIsolate();

  switch (receivedNotification.channelKey) {
    case alarmNotificationChannelKey:
      Payload payload = receivedNotification.payload!;
      int? scheduleId = int.tryParse(payload['scheduleId']);
      if (scheduleId == null) return;
      // AlarmNotificationManager.handleNotificationCreated(receivedNotification);
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
  await initializeIsolate();

  switch (receivedAction.channelKey) {
    case alarmNotificationChannelKey:
      await handleAlarmNotificationDismiss(
          receivedAction, AlarmDismissType.dismiss);
      break;
  }
}

/// Use this method to detect when the user taps on a notification or action button
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  await initializeIsolate();

  switch (receivedAction.channelKey) {
    case alarmNotificationChannelKey:
      await handleAlarmNotificationAction(receivedAction);
      break;
    case reminderNotificationChannelKey:
      switch (receivedAction.buttonKeyPressed) {
        case 'alarm_skip':
          await handleAlarmNotificationDismiss(
              receivedAction, AlarmDismissType.skip);
          break;
        case 'alarm_skip_snooze':
          await handleAlarmNotificationDismiss(
              receivedAction, AlarmDismissType.unsnooze);
          break;
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
