import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/data/alarm_notification_route.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/main.dart';

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
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("payload: ${receivedAction.payload}");

    switch (receivedAction.buttonKeyPressed) {
      case alarmSnoozeActionKey:
        break;

      case alarmDismissActionKey:
        dismissAlarm();
        break;

      default:
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
