import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayUtils on TimeOfDay {
  double toHours() => hour + minute / 60.0;

  bool isBetween(TimeOfDay start, TimeOfDay end) {
    double time = toHours();
    double startTime = start.toHours();
    double endTime = end.toHours();
    if (startTime < endTime) {
      return time >= startTime && time <= endTime;
    } else {
      return time >= startTime || time <= endTime;
    }
  }

  String formatToString(String format) =>
      DateFormat(format).format(toDateTime());

  static TimeOfDay fromHours(double hours) {
    int hour = hours.floor();
    int minute = ((hours - hour) * 60).round();
    return TimeOfDay(hour: hour, minute: minute);
  }

  static TimeOfDay fromJson(Json json) => TimeOfDay(
        hour: json != null ? json['hour'] ?? 0 : 0,
        minute: json != null ? json['minute'] ?? 0 : 0,
      );

  DateTime toDateTime() {
    DateTime currentDateTime = DateTime.now();
    return DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, hour, minute);
  }

  Time toTime() => Time.fromTimeOfDay(this);

  Json toJson() => <String, dynamic>{'hour': hour, 'minute': minute};

  String encode() => toHours().toString();

  static TimeOfDay decode(String encoded) => fromHours(double.parse(encoded));
}
