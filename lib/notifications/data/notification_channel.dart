import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/theme/theme.dart';

const String alarmNotificationChannelGroupKey = 'alarms_and_timers';
const String alarmNotificationChannelKey = 'Chrono';

final NotificationChannel alarmNotificationChannel = NotificationChannel(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelKey: alarmNotificationChannelKey,
  channelName: 'Chrono',
  channelDescription: 'Notification channel for clock alarms and timers',
  defaultColor: defaultColorScheme.accent,
  locked: true,
  importance: NotificationImportance.Max,
  playSound: false,
  enableVibration: false,
  enableLights: false,
);

final NotificationChannelGroup alarmNotificationChannelGroup =
    NotificationChannelGroup(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelGroupName: 'Alarms and timers',
);
