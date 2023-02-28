import 'dart:convert';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:move_to_background/move_to_background.dart';

class FullScreenNotificationData {
  int id;
  final String snoozeActionLabel;
  final String dismissActionLabel;
  final String route;

  FullScreenNotificationData({
    required this.id,
    required this.snoozeActionLabel,
    required this.dismissActionLabel,
    required this.route,
  });
}

Map<ScheduledNotificationType, FullScreenNotificationData>
    alarmNotificationData = {
  ScheduledNotificationType.alarm: FullScreenNotificationData(
    id: 0,
    snoozeActionLabel: "Snooze",
    dismissActionLabel: "Dismiss",
    route: Routes.alarmNotificationRoute,
  ),
  ScheduledNotificationType.timer: FullScreenNotificationData(
    id: 1,
    snoozeActionLabel: "Add 1 Minute",
    dismissActionLabel: "Stop",
    route: Routes.timerNotificationRoute,
  ),
};

class AlarmNotificationManager {
  static const String _snoozeActionKey = "snooze";
  static const String _dismissActionKey = "dismiss";

  static FGBGType _fgbgTypeWhenCreated = FGBGType.foreground;

  static void showFullScreenNotification(
    ScheduledNotificationType type,
    List<int> scheduleIds,
    String title,
    String body,
  ) {
    FullScreenNotificationData data = alarmNotificationData[type]!;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: data.id,
        channelKey: alarmNotificationChannelKey,
        title: title,
        body: body,
        payload: {
          "scheduleIds": json.encode(scheduleIds),
          "type": type.toString(),
        },
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        autoDismissible: false,
        wakeUpScreen: true,
        locked: true,
      ),
      actionButtons: scheduleIds.length == 1
          ? [
              NotificationActionButton(
                showInCompactView: true,
                key: _snoozeActionKey,
                label: data.snoozeActionLabel,
                actionType: ActionType.SilentAction,
                autoDismissible: true,
              ),
              NotificationActionButton(
                showInCompactView: true,
                key: _dismissActionKey,
                label: data.dismissActionLabel,
                actionType: ActionType.SilentAction,
                autoDismissible: true,
              ),
            ]
          : [
              NotificationActionButton(
                showInCompactView: true,
                key: _dismissActionKey,
                label: '${data.dismissActionLabel} All',
                actionType: ActionType.SilentAction,
                autoDismissible: true,
              ),
            ],
    );
  }

  static Future<void> removeNotification(ScheduledNotificationType type) async {
    FullScreenNotificationData data = alarmNotificationData[type]!;

    await AwesomeNotifications().cancel(data.id);
    await AndroidForegroundService.stopForeground(data.id);
  }

  static Future<void> closeNotification(ScheduledNotificationType type) async {
    await removeNotification(type);

    await GetStorage.init();
    await LockScreenFlagManager.clearLockScreenFlags();

    if (Routes.currentRoute == alarmNotificationData[type]?.route) {
      Routes.pop();
    }

    if (_fgbgTypeWhenCreated == FGBGType.background &&
        AppVisibilityListener.state == FGBGType.foreground) {
      MoveToBackground.moveTaskToBack();
    }
    GetStorage().write("fullScreenNotificationRecentlyShown", false);
  }

  static Future<void> snoozeAlarm(
      int scheduleId, ScheduledNotificationType type) async {
    scheduleStopAlarm(scheduleId, AlarmStopAction.snooze, type: type);
    closeNotification(type);
  }

  static Future<void> dismissAlarm(
      int scheduleId, ScheduledNotificationType type) async {
    scheduleStopAlarm(scheduleId, AlarmStopAction.dismiss, type: type);
    closeNotification(type);
  }

  static void handleNotificationCreated(
      ReceivedNotification receivedNotification) {
    _fgbgTypeWhenCreated = AppVisibilityListener.state;
    GetStorage().write("fullScreenNotificationRecentlyShown", false);
  }

  static Future<void> handleNotificationAction(
      ReceivedAction receivedAction) async {
    ScheduledNotificationType type = ScheduledNotificationType.values
        .firstWhere(
            (element) => element.toString() == receivedAction.payload?['type']);

    FullScreenNotificationData data = alarmNotificationData[type]!;

    List<int> scheduleIds =
        (json.decode(receivedAction.payload?['scheduleIds'] ?? "[0]")
                as List<dynamic>)
            .cast<int>();

    switch (receivedAction.buttonKeyPressed) {
      case _snoozeActionKey:
        snoozeAlarm(scheduleIds[0], type);
        break;

      case _dismissActionKey:
        dismissAlarm(scheduleIds[0], type);
        break;

      default:
        await LockScreenFlagManager.setLockScreenFlags();

        if (Routes.currentRoute == data.route) {
          Routes.pop();
        }
        App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          data.route,
          (route) {
            return (route.settings.name != data.route) || route.isFirst;
          },
          arguments: scheduleIds,
        );
        break;
    }
  }
}
