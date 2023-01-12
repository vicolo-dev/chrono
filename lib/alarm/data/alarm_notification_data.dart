import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/theme/color.dart';

const int alarmNotificationId = 10;

const String alarmNotificationChannelGroupKey = 'clock_alarm_group';
const String alarmNotificationChannelKey = 'clock_alarm';

const String alarmSnoozeActionKey = "snooze";
const String alarmDismissActionKey = "dismiss";

const String alarmSnoozeActionLabel = "Snooze";
const String alarmDismissActionLabel = "Dismiss";

NotificationChannel alarmNotificationChannel = NotificationChannel(
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

NotificationChannelGroup alarmNotificationChannelGroup =
    NotificationChannelGroup(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelGroupName: 'Clock Alarm Group',
);
