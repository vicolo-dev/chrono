import 'package:clock_app/alarm/data/time_icons.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';

TimeIcon getTimeIcon(Time time) => timeIcons
    .firstWhere((icon) => time.isBetween(icon.startTime, icon.endTime));
