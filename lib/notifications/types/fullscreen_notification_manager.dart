import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_data.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:move_to_background/move_to_background.dart';

class AlarmNotificationManager {
  static const String _snoozeActionKey = "snooze";
  static const String _dismissActionKey = "dismiss";

  static FGBGType _appVisibilityWhenCreated = FGBGType.foreground;

  static void showFullScreenNotification({
    required ScheduledNotificationType type,
    required List<int> scheduleIds,
    required String title,
    required String body,
  }) {
    FullScreenNotificationData data = alarmNotificationData[type]!;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: data.id,
        channelKey: alarmNotificationChannelKey,
        title: title,
        body: body,
        payload: {
          "scheduleIds": json.encode(scheduleIds),
          "type": type.name,
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

    // If we were on the alarm screen, pop it off the stack. Sometimes the system
    // decides to show a heads up notification instead of a full screen one, so
    // we can't always pop the top screen.
    Routes.popIf(alarmNotificationData[type]?.route);

    // If notification was created while app was in background, move app back
    // to background when we close the notification
    if (_appVisibilityWhenCreated == FGBGType.background &&
        AppVisibility.state == FGBGType.foreground) {
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
    sendPort?.send([scheduleId, type.name, action.name]);
    closeNotification(type);
  }

  static void handleNotificationCreated(ReceivedNotification notification) {
    _appVisibilityWhenCreated = AppVisibility.state;
    GetStorage().write("fullScreenNotificationRecentlyShown", false);
  }

  static Future<void> handleNotificationAction(ReceivedAction action) async {
    Payload payload = action.payload!;
    final type = ScheduledNotificationType.values.byName((payload['type'])!);
    FullScreenNotificationData data = alarmNotificationData[type]!;

    List<int> scheduleIds =
        (json.decode((payload['scheduleIds'])!) as List<dynamic>).cast<int>();

    switch (action.buttonKeyPressed) {
      case _snoozeActionKey:
        snoozeAlarm(scheduleIds.first, type);
        break;

      case _dismissActionKey:
        dismissAlarm(scheduleIds.first, type);
        break;

      default:
        await LockScreenFlagManager.setLockScreenFlags();

        // If we're already on the same notification screen, pop it off the
        // stack so we don't have two of them on the stack.
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
