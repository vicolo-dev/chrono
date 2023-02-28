import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

List<TimeOfDayIcon> timeOfDayIcons = [
  TimeOfDayIcon(
    FluxIcons.sunrise,
    const Color.fromARGB(255, 80, 218, 183),
    const TimeOfDay(hour: 5, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.noon,
    const Color.fromARGB(255, 243, 222, 127),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.sunset,
    const Color.fromARGB(255, 255, 201, 169),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 19, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.night,
    const Color.fromARGB(255, 211, 172, 255),
    const TimeOfDay(hour: 19, minute: 0),
    const TimeOfDay(hour: 5, minute: 0),
  ),
];
