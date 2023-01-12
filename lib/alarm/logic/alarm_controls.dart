import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/main.dart';

@pragma('vm:entry-point')
void ringAlarm(int num, Map<String, dynamic> params) async {
  // print("Time of day : ${params['timeOfDay']}, num : $num");

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: alarmNotificationId,
      channelKey: alarmNotificationChannelKey,
      title: 'Alarm Ringing...',
      payload: {
        'timeOfDay': params['timeOfDay'].toString(),
      },
      // body: '',
      category: NotificationCategory.Alarm,
      fullScreenIntent: true,
      autoDismissible: false,
      wakeUpScreen: true,
      locked: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: alarmSnoozeActionKey,
        label: alarmSnoozeActionLabel,
        actionType: ActionType.Default,
        autoDismissible: true,
      ),
      NotificationActionButton(
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
  App.navigatorKey.currentState?.pop();
}
