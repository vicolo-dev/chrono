import 'package:flutter/material.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class Alarm {
  TimeOfDay time;
  List<WeekDay> weekDays;

  Alarm(this.time, {this.weekDays = const []});
}
