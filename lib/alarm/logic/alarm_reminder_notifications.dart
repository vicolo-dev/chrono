import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/settings/data/settings_schema.dart';

Future<void> cancelAlarmReminderNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}

Future<void> createAlarmReminderNotification(int id, DateTime time) async {
  bool shouldShow = appSettings
      .getGroup("Alarm")
      .getGroup("Notifications")
      .getSetting("Show Upcoming Alarm Notifications")
      .value;

  if (!shouldShow) return;

  double leadTime =
      appSettings.getGroup("Alarm").getSetting("Upcoming Lead Time").value;

  DateTime now = DateTime.now();
  DateTime notificationTime =
      time.subtract(Duration(minutes: leadTime.round()));
  if (notificationTime.isBefore(now)) {
    notificationTime = now.add(const Duration(seconds: 2));
  }
  String timeFormatString = await loadTextFile("time_format_string");

  // debugPrint(
  //     "Createing alarm reminder notification for $id at $time with title $title");

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: reminderNotificationChannelKey,
      title: "Upcoming alarm",
      body: time.toTimeOfDay().formatToString(timeFormatString),
      // wakeUpScreen: true,
      category: NotificationCategory.Reminder,
      // notificationLayout: NotificationLayout.BigPicture,
      // bigPicture: 'asset://assets/images/delivery.jpeg',
      payload: {'scheduleId': '$id'},

      // autoDismissible: false,
    ),
    actionButtons: [
      NotificationActionButton(
        showInCompactView: true,
        key: "alarm_skip",
        label: 'Skip alarm',
        actionType: ActionType.SilentAction,
        autoDismissible: true,
      )
    ],
    schedule: NotificationCalendar.fromDate(
      date: notificationTime,
      preciseAlarm: true,
      allowWhileIdle: true,
    ),
  );
}

Future<void> createSnoozeNotification(int id, DateTime time) async {
  bool shouldShow = appSettings
      .getGroup("Alarm")
      .getGroup("Notifications")
      .getSetting("Show Snooze Notifications")
      .value;
  if (!shouldShow) return;
  String timeFormatString = await loadTextFile("time_format_string");

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: reminderNotificationChannelKey,
      title: "Snoozed alarm",
      body: time.toTimeOfDay().formatToString(timeFormatString),
      // wakeUpScreen: true,
      category: NotificationCategory.Reminder,
      // notificationLayout: NotificationLayout.BigPicture,
      // bigPicture: 'asset://assets/images/delivery.jpeg',
      payload: {'scheduleId': '$id'},
      // autoDismissible: false,
    ),
    actionButtons: [
      NotificationActionButton(
        showInCompactView: true,
        key: "alarm_skip_snooze",
        label: 'Dismiss alarm',
        actionType: ActionType.SilentAction,
        autoDismissible: true,
      )
    ],
  );
}
