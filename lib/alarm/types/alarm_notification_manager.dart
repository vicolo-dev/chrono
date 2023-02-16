import 'dart:developer';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/data/alarm_notification_channel.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
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

  static void showNotification(int scheduleId, TimeOfDay timeOfDay) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationId,
        channelKey: alarmNotificationChannelKey,
        title: 'Alarm Ringing...',
        body: timeOfDay.formatToString('h:mm a'),
        payload: {
          'scheduleId': scheduleId.toString(),
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
          actionType: ActionType.SilentAction,
          autoDismissible: true,
        ),
        NotificationActionButton(
          showInCompactView: true,
          key: _dismissActionKey,
          label: dismissActionLabel,
          actionType: ActionType.SilentAction,
          autoDismissible: true,
        ),
      ],
    );
  }

  static Future<void> removeNotification() async {
    await AwesomeNotifications().cancel(_notificationId);
    await AndroidForegroundService.stopForeground(_notificationId);
  }

  static Future<void> closeNotification() async {
    await removeNotification();

    await SettingsManager.initialize();
    await LockScreenFlagManager.clearLockScreenFlags();

    if (Routes.currentRoute == Routes.alarmNotificationRoute) {
      App.navigatorKey.currentState?.pop();
      Routes.setCurrentRoute(Routes.rootRoute);
    }

    if (_fgbgType == FGBGType.background &&
        AppVisibilityListener.state == FGBGType.foreground) {
      MoveToBackground.moveTaskToBack();
    }

    SettingsManager.preferences?.setBool("alarmRecentlyTriggered", false);
  }

  static Future<void> snoozeAlarm(int scheduleId) async {
    print("Snooze Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

    scheduleStopAlarm(scheduleId, AlarmStopAction.snooze);
    closeNotification();
  }

  static Future<void> dismissAlarm(int scheduleId) async {
    print("Dismiss Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

    scheduleStopAlarm(scheduleId, AlarmStopAction.dismiss);
    closeNotification();
  }

  static void handleNotificationCreated(
      ReceivedNotification receivedNotification) {
    _fgbgType = AppVisibilityListener.state;

    print("FGBGType on NotificationCreated: $_fgbgType");

    SettingsManager.preferences?.setBool("alarmRecentlyTriggered", false);
  }

  static Future<void> handleNotificationAction(
      ReceivedAction receivedAction) async {
    print(
        "Notification Action Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

    switch (receivedAction.buttonKeyPressed) {
      case _snoozeActionKey:
        int scheduleId =
            int.parse(receivedAction.payload?['scheduleId'] ?? "0");
        snoozeAlarm(scheduleId);
        break;

      case _dismissActionKey:
        int scheduleId =
            int.parse(receivedAction.payload?['scheduleId'] ?? "0");
        // print("DISMISS ALARM: $scheduleId");
        dismissAlarm(scheduleId);
        break;

      default:
        await LockScreenFlagManager.setLockScreenFlags();
        if (Routes.currentRoute == Routes.alarmNotificationRoute) {
          App.navigatorKey.currentState?.pop();
        }
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
