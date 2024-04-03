import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:flutter/material.dart';

Future<void> createAlarmReminderNotification(
    int id, DateTime time, bool snooze) async {
  DateTime now = DateTime.now();
  DateTime notificationTime = snooze
      ? now.add(const Duration(seconds: 2))
      : time.subtract(const Duration(minutes: 5));
  if (notificationTime.isBefore(now)) {
    notificationTime = now.add(const Duration(seconds: 2));
  }
  String timeFormatString = await loadTextFile("time_format_string");

  // debugPrint(
  //     "Createing alarm reminder notification for $id at $time with title $title");

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: UniqueKey().hashCode,
        channelKey: reminderNotificationChannelKey,
        title: snooze ? "Alarm snoozed" : "Upcoming alarm",
        body: time.toTimeOfDay().formatToString(timeFormatString),
        // wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        // notificationLayout: NotificationLayout.BigPicture,
        // bigPicture: 'asset://assets/images/delivery.jpeg',
        payload: {'scheduleId': '$id'},
        // autoDismissible: false,
      ),
      schedule: NotificationCalendar.fromDate(
          date: notificationTime, preciseAlarm: true, allowWhileIdle: true));
}
