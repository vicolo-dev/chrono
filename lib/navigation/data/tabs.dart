import 'package:clock_app/alarm/screens/alarm_screen.dart';
import 'package:clock_app/stopwatch/screens/stopwatch_screen.dart';
import 'package:clock_app/timer/screens/timer_screen.dart';

import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/clock/screens/clock_screen.dart';
import 'package:clock_app/navigation/types/tab.dart';

final List<Tab> tabs = [
  Tab(title: 'Alarm', icon: FluxIcons.alarm, widget: const AlarmScreen()),
  Tab(title: 'Clock', icon: FluxIcons.clock, widget: const ClockScreen()),
  Tab(title: 'Timer', icon: FluxIcons.timer, widget: const TimerScreen()),
  Tab(
      title: 'Stopwatch',
      icon: FluxIcons.stopwatch,
      widget: const StopwatchScreen()),
];
