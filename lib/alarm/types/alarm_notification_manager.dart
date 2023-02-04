import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_channel.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:move_to_background/move_to_background.dart';

class AlarmNotificationManager {
  static const _notificationId = 0;

  static const String _snoozeActionKey = "snooze";
  static const String _dismissActionKey = "dismiss";

  static const String snoozeActionLabel = "Snooze";
  static const String dismissActionLabel = "Dismiss";

  static FGBGType _fgbgType = FGBGType.foreground;

  static void showNotification(Map<String, dynamic> params) {
    TimeOfDay timeOfDay = TimeOfDayUtils.decode(params['timeOfDay']);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationId,
        channelKey: alarmNotificationChannelKey,
        title: 'Alarm Ringing...',
        body: timeOfDay.formatToString('h:mm a'),
        payload: {
          'scheduleId': params['scheduleId'],
          'ringtoneIndex': params['ringtoneIndex'],
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
          key: _snoozeActionKey,
          label: snoozeActionLabel,
          actionType: ActionType.Default,
          autoDismissible: true,
        ),
        NotificationActionButton(
          showInCompactView: true,
          key: _dismissActionKey,
          label: dismissActionLabel,
          actionType: ActionType.Default,
          autoDismissible: true,
        ),
      ],
    );
  }

  static void dismissAlarm() {
    AlarmAudioPlayer.stop();
    AwesomeNotifications().cancel(_notificationId);
    AndroidForegroundService.stopForeground(_notificationId);

    if (Routes.currentRoute == Routes.alarmNotificationRoute) {
      App.navigatorKey.currentState?.pop();
    }

    if (_fgbgType == FGBGType.background) {
      MoveToBackground.moveTaskToBack();
    }
  }

  static void handleNotificationCreated(
      ReceivedNotification receivedNotification) {
    int ringtoneIndex =
        int.parse((receivedNotification.payload?['ringtoneIndex']) ?? '0');
    AlarmAudioPlayer.play(ringtoneIndex);

    int scheduleId =
        int.parse((receivedNotification.payload?['scheduleId']) ?? '-1');

    List<Alarm> alarms = loadList("alarms");
    int alarmIndex =
        alarms.indexWhere((alarm) => alarm.activeSchedule.hasId(scheduleId));

    // print('scheduleId: $scheduleId');
    // print('alarms: ${encodeList(alarms)}');
    // print('alarmIndex: $alarmIndex');
    Alarm alarm = alarms[alarmIndex];

    if (alarm.isRepeating) {
      alarm.schedule();
    } else {
      alarm.disable();
    }

    alarms[alarmIndex] = alarm;
    saveList("alarms", alarms);

    SettingsManager.notifyListeners("alarms");

    _fgbgType = AppVisibilityListener.state;

    print("AAAAAAAAAAAAA $_fgbgType");
  }

  static Future<void> handleNotificationAction(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case _snoozeActionKey:
        await clearLockScreenFlags();
        break;

      case _dismissActionKey:
        await clearLockScreenFlags();
        dismissAlarm();
        break;

      default:
        await setLockScreenFlags();
        App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.alarmNotificationRoute,
          (route) {
            return (route.settings.name != Routes.alarmNotificationRoute) ||
                route.isFirst;
          },
          arguments: receivedAction,
        );
        break;
    }
  }
}
