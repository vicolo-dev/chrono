import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_channel.dart';
import 'package:flutter/foundation.dart';

Future<void> initializeNotifications() async {
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          // NotificationPermission.Sound,
          NotificationPermission.Alert,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  });

  await AwesomeNotifications().initialize(null, [alarmNotificationChannel],
      channelGroups: [alarmNotificationChannelGroup], debug: false);
}
