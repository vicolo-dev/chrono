import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

List<TimeIcon> timeIcons = [
  TimeIcon(
    FluxIcons.sunrise,
    const Color.fromARGB(255, 80, 218, 183),
    const Time(hour: 5, minute: 0),
    const Time(hour: 10, minute: 0),
  ),
  TimeIcon(
    FluxIcons.noon,
    const Color.fromARGB(255, 243, 222, 127),
    const Time(hour: 10, minute: 0),
    const Time(hour: 16, minute: 0),
  ),
  TimeIcon(
    FluxIcons.sunset,
    const Color.fromARGB(255, 255, 201, 169),
    const Time(hour: 16, minute: 0),
    const Time(hour: 19, minute: 0),
  ),
  TimeIcon(
    FluxIcons.night,
    const Color.fromARGB(255, 211, 172, 255),
    const Time(hour: 19, minute: 0),
    const Time(hour: 5, minute: 0),
  ),
];
