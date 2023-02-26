import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/theme/color.dart';

const String alarmNotificationChannelGroupKey = 'clock_group';
const String alarmNotificationChannelKey = 'clock';

final NotificationChannel alarmNotificationChannel = NotificationChannel(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelKey: alarmNotificationChannelKey,
  channelName: 'Clock',
  channelDescription: 'Notification channel for clock alarms and timers',
  defaultColor: lightColorScheme.primary,
  locked: true,
  importance: NotificationImportance.Max,
  playSound: false,
  enableVibration: false,
  enableLights: false,
);

final NotificationChannelGroup alarmNotificationChannelGroup =
    NotificationChannelGroup(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelGroupName: 'Clock Group',
);
