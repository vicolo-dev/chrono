import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/logic/notification_callbacks.dart';

class NotificationController {
  static void setListeners() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }
}
