import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
void ringAlarm(int num, Map<String, dynamic> params) async {
  // print("Time of day : ${params['timeOfDay']}, num : $num");
  TimeOfDay timeOfDay = TimeOfDayUtils.decode(params['timeOfDay']);

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: alarmNotificationId,
      channelKey: alarmNotificationChannelKey,
      title: 'Alarm Ringing...',
      body: timeOfDay.formatToString('h:mm a'),
      payload: {
        'scheduleId': params['scheduleId'],
      },
      category: NotificationCategory.Alarm,
      fullScreenIntent: true,
      autoDismissible: false,
      wakeUpScreen: true,
      locked: true,
    ),
    actionButtons: [
      NotificationActionButton(
        showInCompactView: true,
        key: alarmSnoozeActionKey,
        label: alarmSnoozeActionLabel,
        actionType: ActionType.Default,
        autoDismissible: true,
      ),
      NotificationActionButton(
        showInCompactView: true,
        key: alarmDismissActionKey,
        label: alarmDismissActionLabel,
        actionType: ActionType.Default,
        autoDismissible: true,
      ),
    ],
  );
}

void dismissAlarm() {
  AlarmAudioPlayer.stop();
  AwesomeNotifications().cancel(alarmNotificationId);
  AndroidForegroundService.stopForeground(alarmNotificationId);

  if (App.navigatorKey.currentState?.canPop() ?? false) {
    App.navigatorKey.currentState?.pop();
  }
}
