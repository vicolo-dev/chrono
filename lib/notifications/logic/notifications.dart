import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';

void requestNotificationPermissions({Function? onAlreadyGranted}) async {
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          // NotificationPermission.Sound,
          NotificationPermission.Alert,
          NotificationPermission.FullScreenIntent,
        ],
      );
    } else {
      onAlreadyGranted?.call();
    }
  });
}

Future<void> initializeNotifications() async {
  requestNotificationPermissions();
  await AwesomeNotifications().initialize(
    null, // use default app icon
    [
      alarmNotificationChannel,
      reminderNotificationChannel,
      stopwatchNotificationChannel,
      timerNotificationChannel,
      // foregroundNotificationChannel,
    ],
    // channelGroups: [alarmNotificationChannelGroup],
    debug: false,
  );
}
