import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

const int alarmNotificationId = 10;

const String alarmNotificationChannelGroupKey = 'clock_alarm_group';
const String alarmNotificationChannelKey = 'clock_alarm';

const String snoozeActionKey = "snooze";
const String dismissActionKey = "dismiss";

const String snoozeActionLabel = "Snooze";
const String dismissActionLabel = "Dismiss";

NotificationChannel alarmNotificationChannel = NotificationChannel(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelKey: alarmNotificationChannelKey,
  channelName: 'Clock Alarm',
  channelDescription: 'Notification channel for clock alarms',
  defaultColor: ColorTheme.accentColor,
  ledColor: Colors.white,
  locked: true,
  importance: NotificationImportance.Max,
);

NotificationChannelGroup alarmNotificationChannelGroup =
    NotificationChannelGroup(
  channelGroupKey: alarmNotificationChannelGroupKey,
  channelGroupName: 'Clock Alarm Group',
);
