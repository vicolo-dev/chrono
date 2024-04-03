import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:flutter/material.dart';

Future<void> createAlarmReminderNotification(int id, DateTime time) async {
  DateTime now = DateTime.now();
  DateTime notificationTime = time.subtract(const Duration(minutes: 5));
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
    schedule: NotificationCalendar.fromDate(
      date: notificationTime,
      preciseAlarm: true,
      allowWhileIdle: true,
    ),
  );
}

Future<void> createSnoozeNotification(int id, DateTime time) async {
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
  );
}
