import 'package:clock_app/alarm/data/time_of_day_icons.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

TimeOfDayIcon getTimeOfDayIcon(TimeOfDay timeOfDay) => timeOfDayIcons
    .firstWhere((icon) => timeOfDay.isBetween(icon.startTime, icon.endTime));
