import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  double toHours() => hour + minute / 60.0;
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}
