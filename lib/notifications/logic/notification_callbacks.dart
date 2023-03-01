import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';

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
    ReceivedAction receivedAction) async {}

/// Use this method to detect when the user taps on a notification or action button
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  AlarmNotificationManager.handleNotificationAction(receivedAction);
}
