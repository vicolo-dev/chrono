import 'dart:developer';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';

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
        AlarmNotificationManager.handleNotificationCreated(
            receivedNotification);
        break;
    }
    // Your code goes here
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
    // print isolate id
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    AlarmNotificationManager.handleNotificationAction(receivedAction);
  }
}
