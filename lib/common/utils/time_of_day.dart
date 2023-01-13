import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayUtils on TimeOfDay {
  double toHours() => hour + minute / 60.0;

  String formatToString(String format) =>
      DateFormat(format).format(toDateTime());

  static TimeOfDay fromHours(double hours) {
    int hour = hours.floor();
    int minute = ((hours - hour) * 60).round();
    return TimeOfDay(hour: hour, minute: minute);
  }

  static TimeOfDay fromJson(Map<String, dynamic> json) => TimeOfDay(
        hour: json['hour'],
        minute: json['minute'],
      );

  DateTime toDateTime() => DateTime(0, 0, 0, hour, minute);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'hour': hour, 'minute': minute};

  String encode() => toHours().toString();

  static TimeOfDay decode(String encoded) => fromHours(double.parse(encoded));
}
