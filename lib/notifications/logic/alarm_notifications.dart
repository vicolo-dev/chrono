import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/alarm_isolate.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/notifications/data/action_keys.dart';
import 'package:clock_app/notifications/data/fullscreen_notification_data.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/alarm_notification_arguments.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_data.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:receive_intent/receive_intent.dart';

FGBGType appVisibilityWhenAlarmNotificationCreated = FGBGType.foreground;

void showAlarmNotification({
  required ScheduledNotificationType type,
  required List<int> scheduleIds,
  bool showSnoozeButton = true,
  bool tasksRequired = false,
  required String title,
  required String body,
  required String dismissActionLabel,
  required String snoozeActionLabel,
}) {
  logger.t("[showAlarmNotification]");
  FullScreenNotificationData data = alarmNotificationData[type]!;

  List<NotificationActionButton> actionButtons = [];

  if (scheduleIds.length > 1) {
    actionButtons.add(NotificationActionButton(
      showInCompactView: true,
      key: dismissActionKey,
      label: '$dismissActionLabel All',
      actionType: ActionType.SilentAction,
      autoDismissible: true,
    ));
  } else {
    if (showSnoozeButton) {
      actionButtons.add(NotificationActionButton(
        showInCompactView: true,
        key: snoozeActionKey,
        label: snoozeActionLabel,
        actionType: ActionType.SilentAction,
        autoDismissible: true,
      ));
    }

    actionButtons.add(NotificationActionButton(
      showInCompactView: true,
      key: dismissActionKey,
      label: "${tasksRequired ? "Solve tasks to " : ""}$dismissActionLabel",
      actionType: tasksRequired ? ActionType.Default : ActionType.SilentAction,
      autoDismissible: tasksRequired ? false : true,
    ));
  }

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: data.id,
        channelKey: alarmNotificationChannelKey,
        title: title,
        body: body,
        payload: {
          "scheduleIds": json.encode(scheduleIds),
          "type": type.name,
          "tasksRequired": tasksRequired.toString(),
        },
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        autoDismissible: false,
        wakeUpScreen: true,
        locked: true,
      ),
      actionButtons: actionButtons);
}

Future<void> removeAlarmNotification(ScheduledNotificationType type) async {
  logger.t("[removeAlarmNotification]");
  FullScreenNotificationData data = alarmNotificationData[type]!;

  await AwesomeNotifications()
      .cancelNotificationsByChannelKey(alarmNotificationChannelKey);
  await AndroidForegroundService.stopForeground(data.id);
}

Future<void> closeAlarmNotification(ScheduledNotificationType type) async {
  logger.t("[closeAlarmNotification]");
  final intent = await ReceiveIntent.getInitialIntent();

  await removeAlarmNotification(type);

  await FlutterShowWhenLocked().hide();

  // If app was launched from a notification, close the app when the notification
  // is closed
  if (intent?.action == "SELECT_NOTIFICATION") {
    logger.t(
        "[closeAlarmNotification] Moving app to background because it was launched from notification");
    await MoveToBackground.moveTaskToBack();
    // SystemNavigator.pop();
  } else {
    // If notification was created while app was in background, move app back
    // to background when we close the notification
    if (appVisibilityWhenAlarmNotificationCreated == FGBGType.background) {
      logger.t(
          "[closeAlarmNotification] Moving app to background because notification moved it to foreground");
      appVisibilityWhenAlarmNotificationCreated = FGBGType.foreground;
      await MoveToBackground.moveTaskToBack();
    }
  }
  // If we were on the alarm screen, pop it off the stack. Sometimes the system
  // decides to show a heads up notification instead of a full screen one, so
  // we can't always pop the top screen.
  Routes.popIf(alarmNotificationData[type]?.route);
  logger.t("[closeAlarmNotification] Notification closed");
}

Future<void> snoozeAlarm(int scheduleId, ScheduledNotificationType type) async {
  await stopAlarm(scheduleId, type, AlarmStopAction.snooze);
}

Future<void> dismissAlarm(
    int scheduleId, ScheduledNotificationType type) async {
  await stopAlarm(scheduleId, type, AlarmStopAction.dismiss);
}

Future<void> stopAlarm(int scheduleId, ScheduledNotificationType type,
    AlarmStopAction action) async {
  // Send a message to tell the alarm isolate to run the code to stop alarm
  // See stopScheduledNotification in lib/alarm/logic/alarm_isolate.dart
  IsolateNameServer.lookupPortByName(stopAlarmPortName)
      ?.send([scheduleId, type.name, action.name]);
}

Future<void> dismissAlarmNotification(int scheduleId,
    AlarmDismissType dismissType, ScheduledNotificationType type) async {
  logger.t("[dismissAlarmNotification]");

  switch (dismissType) {
    case AlarmDismissType.dismiss:
      await dismissAlarm(scheduleId, type);
      break;
    case AlarmDismissType.skip:
      await updateAlarmById(scheduleId, (alarm) async {
        alarm.setShouldSkip(true);
      });
      break;
    case AlarmDismissType.snooze:
      await snoozeAlarm(scheduleId, type);
      break;

    case AlarmDismissType.unsnooze:
      await updateAlarmById(scheduleId, (alarm) async {
        await alarm.cancelSnooze();
        await alarm.update("Skipped snooze");
      });
      break;
  }
  await closeAlarmNotification(type);
}

Future<void> openAlarmNotificationScreen(
  FullScreenNotificationData data,
  List<int> scheduleIds, {
  bool tasksOnly = false,
  AlarmDismissType dismissType = AlarmDismissType.dismiss,
}) async {
  logger.t("[openAlarmNotificationScreen]");
  await FlutterShowWhenLocked().show();
  // If we're already on the same notification screen, pop it off the
  // stack so we don't have two of them on the stack.
  if (Routes.currentRoute == data.route) {
    logger.t(
        "[openAlarmNotificationScreen] Popping current route because a new alarm notification needs to be pushed");
    Routes.pop();
  }
  App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    data.route,
    (route) => (route.settings.name != data.route) || route.isFirst,
    arguments: AlarmNotificationArguments(
        scheduleIds: scheduleIds,
        tasksOnly: tasksOnly,
        dismissType: dismissType),
  );
}

Future<void> handleAlarmNotificationDismiss(
    ReceivedAction action, AlarmDismissType dismissType) async {
  logger.t("[handleAlarmNotificationDismiss]");

  Payload payload = action.payload!;
  final type = ScheduledNotificationType.values.byName((payload['type'])!);
  FullScreenNotificationData data = alarmNotificationData[type]!;
  bool tasksRequired = payload['tasksRequired'] == 'true';
  List<int> scheduleIds =
      (json.decode((payload['scheduleIds'])!) as List<dynamic>).cast<int>();
  if (scheduleIds.isEmpty) return;

  if (tasksRequired && dismissType != AlarmDismissType.snooze) {
    await openAlarmNotificationScreen(data, scheduleIds,
        tasksOnly: true, dismissType: dismissType);
  } else {
    await dismissAlarmNotification(scheduleIds.first, dismissType, type);
  }
}

Future<void> handleAlarmNotificationAction(ReceivedAction action) async {
  logger.t("[handleAlarmNotificationAction]");
  Payload payload = action.payload!;
  final type = ScheduledNotificationType.values.byName((payload['type'])!);
  FullScreenNotificationData data = alarmNotificationData[type]!;

  List<int> scheduleIds =
      (json.decode((payload['scheduleIds'])!) as List<dynamic>).cast<int>();

  switch (action.buttonKeyPressed) {
    case snoozeActionKey:
      await handleAlarmNotificationDismiss(action, AlarmDismissType.snooze);
      break;

    case dismissActionKey:
      await handleAlarmNotificationDismiss(action, AlarmDismissType.dismiss);
      break;

    // When notification is created or notification is clicked
    default:
      await openAlarmNotificationScreen(data, scheduleIds);
      break;
  }
}
