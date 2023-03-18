import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  double toHours() => hour + minute / 60.0 + second / 3600.0;
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
  DateTime addTimeDuration(TimeDuration duration) =>
      add(Duration(seconds: duration.inSeconds));
}
