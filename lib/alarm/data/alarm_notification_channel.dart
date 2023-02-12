import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/theme/color.dart';

const String alarmNotificationChannelGroupKey = 'clock_alarm_group';
const String alarmNotificationChannelKey = 'clock_alarm';

final NotificationChannel alarmNotificationChannel = NotificationChannel(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelKey: alarmNotificationChannelKey,
  channelName: 'Clock Alarm',
  channelDescription: 'Notification channel for clock alarms',
  defaultColor: ColorTheme.accentColor,
  locked: true,
  importance: NotificationImportance.Max,
  playSound: false,
  enableVibration: false,
  enableLights: false,
);

final NotificationChannelGroup alarmNotificationChannelGroup =
    NotificationChannelGroup(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelGroupName: 'Clock Alarm Group',
);
