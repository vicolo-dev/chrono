import 'package:clock_app/screens/tabs/alarm_tab.dart';
import 'package:clock_app/screens/tabs/stopwatch_tab.dart';
import 'package:clock_app/screens/tabs/timer_tab.dart';
import 'package:flutter/widgets.dart';

import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/screens/tabs/clock_tab.dart';
import 'package:clock_app/types/tab.dart';

final List<Tab> tabs = [
  Tab(title: 'Alarm', icon: FluxIcons.alarm, widget: const AlarmTab()),
  Tab(title: 'Clock', icon: FluxIcons.clock, widget: const ClockTab()),
  Tab(title: 'Timer', icon: FluxIcons.timer, widget: const TimerTab()),
  Tab(
      title: 'Stopwatch',
      icon: FluxIcons.stopwatch,
      widget: const StopwatchTab()),
];
