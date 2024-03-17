import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';

enum ScheduledNotificationType {
  alarm,
  timer,
}

Future<bool> scheduleAlarm(
  int scheduleId,
  DateTime startDate, {
  ScheduledNotificationType type = ScheduledNotificationType.alarm,
}) async {
  if (startDate.isBefore(DateTime.now())) {
    throw Exception('Attempted to schedule alarm in the past ($startDate)');
  }
  await cancelAlarm(scheduleId);
  // FullScreenNotificationData data = alarmNotificationData[type]!;
  //
  // List<NotificationActionButton> actionButtons = [];
  //
  // if (scheduleIds.length > 1) {
  //   actionButtons.add(NotificationActionButton(
  //     showInCompactView: true,
  //     key: _dismissActionKey,
  //     label: '$dismissActionLabel All',
  //     actionType: ActionType.SilentAction,
  //     autoDismissible: true,
  //   ));
  // } else {
  //   if (showSnoozeButton) {
  //     actionButtons.add(NotificationActionButton(
  //       showInCompactView: true,
  //       key: _snoozeActionKey,
  //       label: snoozeActionLabel,
  //       actionType: ActionType.SilentAction,
  //       autoDismissible: true,
  //     ));
  //   }
  //
  //   actionButtons.add(NotificationActionButton(
  //     showInCompactView: true,
  //     key: _dismissActionKey,
  //     label: "${tasksRequired ? "Solve tasks to " : ""}$dismissActionLabel",
  //     actionType:
  //         tasksRequired ? ActionType.Default : ActionType.SilentAction,
  //     autoDismissible: tasksRequired ? false : true,
  //   ));
  // }
  //
  // AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: data.id,
  //       channelKey: alarmNotificationChannelKey,
  //       title: title,
  //       body: body,
  //       payload: {
  //         "scheduleIds": json.encode(scheduleIds),
  //         "type": type.name,
  //         "tasksRequired": tasksRequired.toString(),
  //       },
  //       category: NotificationCategory.Alarm,
  //       fullScreenIntent: true,
  //       autoDismissible: false,
  //       wakeUpScreen: true,
  //       locked: true,
  //     ),
  //     actionButtons: actionButtons);
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       id: id,
    //       channelKey: 'scheduled',
    //       title: 'Just in time!',
    //       body: 'This notification was scheduled to shows at ' +
    //           (Utils.DateUtils.parseDateToString(scheduleTime.toLocal()) ??
    //               '?') +
    //           ' $timeZoneIdentifier (' +
    //           (Utils.DateUtils.parseDateToString(scheduleTime.toUtc()) ?? '?') +
    //           ' utc)',
    //       wakeUpScreen: true,
    //       category: NotificationCategory.Reminder,
    //       notificationLayout: NotificationLayout.BigPicture,
    //       bigPicture: 'asset://assets/images/delivery.jpeg',
    //       payload: {'uuid': 'uuid-test'},
    //       autoDismissible: false,
    //     ),
    //     schedule: NotificationCalendar.fromDate(date: scheduleTime));
    return AndroidAlarmManager.oneShotAt(
      startDate,
      scheduleId,
      triggerScheduledNotification,
      allowWhileIdle: true,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': scheduleId.toString(),
        'timeOfDay': startDate.toTimeOfDay().encode(),
        'type': type.name,
      },
    );
  } else {
    return true;
  }
}

Future<void> cancelAlarm(int scheduleId) async {
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    // await AwesomeNotifications().cancel(scheduleId);
    await AndroidAlarmManager.cancel(scheduleId);
  }
}

enum AlarmStopAction {
  dismiss,
  snooze,
}

Future<void> scheduleSnoozeAlarm(
    int scheduleId, Duration delay, ScheduledNotificationType type) async {
  await scheduleAlarm(scheduleId, DateTime.now().add(delay), type: type);
}
