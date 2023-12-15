import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  double toHours() => hour + minute / 60.0 + second / 3600.0;
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
  Time getTime() => Time(hour: hour, minute: minute, second: second);
  DateTime addTimeDuration(TimeDuration duration) =>
      add(Duration(seconds: duration.inSeconds));
  static DateTime fromNow(Duration duration) => DateTime.now().add(duration);
  static Time getTimeFromNow(Duration duration) =>
      Time.fromDateTime(fromNow(duration));

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  String toIso8601Date() => toIso8601String().substring(0, 10);
}
