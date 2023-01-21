import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/data/alarm_notification_route.dart';
import 'package:clock_app/alarm/logic/alarm_storage.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/main.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class NotificationController {
  static void setListeners() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: _onActionReceivedMethod,
        onNotificationCreatedMethod: _onNotificationCreatedMethod,
        onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: _onDismissActionReceivedMethod);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> _onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    switch (receivedNotification.channelKey) {
      case alarmNotificationChannelKey:
        handleAlarmNotificationCreated(receivedNotification);
        break;
    }
    // Your code goes here
  }

  static void handleAlarmNotificationCreated(
      ReceivedNotification receivedNotification) {
    int ringtoneIndex =
        int.parse((receivedNotification.payload?['ringtoneIndex']) ?? '0');
    AlarmAudioPlayer.play(ringtoneIndex);
    if (receivedNotification.payload?['type'] == 'oneTime') {
      int scheduleId =
          int.parse((receivedNotification.payload?['scheduleId'])!);
      disableAlarmByScheduleId(scheduleId);
    }
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> _onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> _onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case alarmSnoozeActionKey:
        await clearLockScreenFlags();
        break;

      case alarmDismissActionKey:
        await clearLockScreenFlags();
        dismissAlarm();
        break;

      default:
        await setLockScreenFlags();
        App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          alarmNotificationRoute,
          (route) {
            return (route.settings.name != alarmNotificationRoute) ||
                route.isFirst;
          },
          arguments: receivedAction,
        );
        break;
    }
  }
}
