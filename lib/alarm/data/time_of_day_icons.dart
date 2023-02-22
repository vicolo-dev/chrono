import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

List<TimeOfDayIcon> timeOfDayIcons = [
  TimeOfDayIcon(
    FluxIcons.sunrise,
    const Color.fromARGB(255, 176, 213, 224),
    const TimeOfDay(hour: 5, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.noon,
    const Color.fromARGB(255, 226, 216, 158),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.sunset,
    const Color.fromARGB(255, 231, 189, 164),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 19, minute: 0),
  ),
  TimeOfDayIcon(
    FluxIcons.night,
    const Color.fromARGB(255, 195, 157, 238),
    const TimeOfDay(hour: 19, minute: 0),
    const TimeOfDay(hour: 5, minute: 0),
  ),
];
