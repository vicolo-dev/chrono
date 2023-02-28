import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
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

  static FGBGType _appVisibilityWhenCreated = FGBGType.foreground;

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

    // If notification was created while app was in background, move app back
    // to background when we close the notification
    if (_appVisibilityWhenCreated == FGBGType.background &&
        AppVisibilityListener.state == FGBGType.foreground) {
      MoveToBackground.moveTaskToBack();
    }
    GetStorage().write("fullScreenNotificationRecentlyShown", false);
  }

  static Future<void> snoozeAlarm(
      int scheduleId, ScheduledNotificationType type) async {
    stopAlarm(scheduleId, type, AlarmStopAction.snooze);
  }

  static Future<void> dismissAlarm(
      int scheduleId, ScheduledNotificationType type) async {
    stopAlarm(scheduleId, type, AlarmStopAction.dismiss);
  }

  static Future<void> stopAlarm(int scheduleId, ScheduledNotificationType type,
      AlarmStopAction action) async {
    SendPort? sendPort = IsolateNameServer.lookupPortByName(stopAlarmPortName);
    sendPort?.send([scheduleId, type.toString(), action.toString()]);
    closeNotification(type);
  }

  static void handleNotificationCreated(
      ReceivedNotification receivedNotification) {
    _appVisibilityWhenCreated = AppVisibilityListener.state;
    GetStorage().write("fullScreenNotificationRecentlyShown", false);
  }

  static Future<void> handleNotificationAction(
      ReceivedAction receivedAction) async {
    ScheduledNotificationType type = ScheduledNotificationType.values
        .firstWhere(
            (element) => element.toString() == receivedAction.payload?['type']);

    // print("Action received Isolate: ${Service.getIsolateID(Isolate.current)}");

    // if (type == ScheduledNotificationType.timer) {
    //   await updateTimers();
    //   SettingsManager.notifyListeners("timers");
    // } else if (type == ScheduledNotificationType.alarm) {
    //   updateAlarms();
    //   SettingsManager.notifyListeners("alarms");
    // }

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
          (route) => (route.settings.name != data.route) || route.isFirst,
          arguments: scheduleIds,
        );
        break;
    }
  }
}
