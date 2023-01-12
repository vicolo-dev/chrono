import 'dart:convert';

import 'package:clock_app/alarm/types/alarm_schedule.dart';
import 'package:flutter/material.dart';

class Alarm {
  bool _enabled;
  TimeOfDay _timeOfDay;
  final String _label;
  final List<OneTimeAlarmSchedule> _oneTimeSchedules = [];
  final List<WeekdayAlarmSchedule> _repeatSchedules = [];

  bool get enabled => _enabled;
  TimeOfDay get timeOfDay => _timeOfDay;
  String get label => _label;

  Alarm(this._timeOfDay, {List<int> weekdays = const []})
      : _enabled = true,
        _label = "" {
    _enabled = true;
    setSchedules(weekdays, shouldSchedule: true);
  }

  void setSchedules(List<int> weekdays, {bool shouldSchedule = false}) {
    if (weekdays.isEmpty) {
      _oneTimeSchedules.add(OneTimeAlarmSchedule(_timeOfDay));
      if (shouldSchedule) _oneTimeSchedules.last.schedule();
    } else {
      for (var weekday in weekdays) {
        _repeatSchedules.add(WeekdayAlarmSchedule(_timeOfDay, weekday));
        if (shouldSchedule) _repeatSchedules.last.schedule();
      }
    }
  }

  void toggle() {
    if (_enabled) {
      disable();
    } else {
      enable();
    }
  }

  void setIsEnabled(bool enabled) {
    if (enabled) {
      enable();
    } else {
      disable();
    }
  }

  void schedule() {
    for (var alarm in _oneTimeSchedules) {
      alarm.schedule();
    }
    for (var alarm in _repeatSchedules) {
      alarm.schedule();
    }
  }

  void cancel() {
    for (var alarm in _oneTimeSchedules) {
      alarm.cancel();
    }
    for (var alarm in _repeatSchedules) {
      alarm.cancel();
    }
  }

  void enable() {
    _enabled = true;
    schedule();
  }

  void disable() {
    _enabled = false;
    cancel();
  }

  void setTimeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
    for (var alarm in _oneTimeSchedules) {
      alarm.setTimeOfDay(timeOfDay);
    }
    for (var alarm in _repeatSchedules) {
      alarm.setTimeOfDay(timeOfDay);
    }
  }

  List<int> getWeekdays() {
    return _repeatSchedules.map((e) => e.weekday).toList();
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDay(
          hour: json['time']['hour'],
          minute: json['time']['minute'],
        ),
        _enabled = json['enabled'],
        _label = json['label'] {
    setSchedules(json['weekDays'].cast<int>());
  }

  Map<String, dynamic> toJson() => {
        'time': {
          'hour': _timeOfDay.hour,
          'minute': _timeOfDay.minute,
        },
        'enabled': _enabled,
        'label': _label,
        'weekDays': getWeekdays(),
      };

  static String encode(List<Alarm> alarms) => json.encode(
        alarms.map<Map<String, dynamic>>((alarm) => alarm.toJson()).toList(),
      );

  static List<Alarm> decode(String alarms) =>
      (json.decode(alarms) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}
