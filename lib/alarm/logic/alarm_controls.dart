import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/main.dart';

@pragma('vm:entry-point')
void ringAlarm() async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: alarmNotificationId,
      channelKey: alarmNotificationChannelKey,
      title: 'Alarm Ringing...',
      // body: '',
      category: NotificationCategory.Alarm,
      fullScreenIntent: true,
      autoDismissible: false,
      wakeUpScreen: true,
      locked: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: snoozeActionKey,
        label: dismissActionLabel,
        actionType: ActionType.Default,
        autoDismissible: true,
      ),
      NotificationActionButton(
        key: dismissActionKey,
        label: dismissActionLabel,
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
