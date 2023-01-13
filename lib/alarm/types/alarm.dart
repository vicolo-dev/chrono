import 'dart:convert';

import 'package:clock_app/alarm/types/alarm_schedule.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:flutter/material.dart';

class Alarm extends JsonSerializable {
  bool _enabled;
  TimeOfDay _timeOfDay;
  final String _label;
  final List<OneTimeAlarmSchedule> _oneTimeSchedules;
  final List<WeeklyAlarmSchedule> _repeatSchedules;

  bool get enabled => _enabled;
  TimeOfDay get timeOfDay => _timeOfDay;
  String get label => _label;

  Alarm(this._timeOfDay, {List<int> weekdays = const []})
      : _enabled = true,
        _label = "",
        _oneTimeSchedules = [],
        _repeatSchedules = [] {
    setSchedules(weekdays, shouldSchedule: true);
  }

  void setSchedules(List<int> weekdays, {bool shouldSchedule = false}) {
    if (weekdays.isEmpty) {
      _oneTimeSchedules.add(OneTimeAlarmSchedule(_timeOfDay));
      if (shouldSchedule) _oneTimeSchedules.last.schedule();
    } else {
      for (var weekday in weekdays) {
        _repeatSchedules.add(WeeklyAlarmSchedule(_timeOfDay, weekday));
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

  bool hasOneTimeScheduleWithId(int scheduleId) {
    return _oneTimeSchedules.any((e) => e.id == scheduleId);
  }

  List<int> getWeekdays() {
    return _repeatSchedules.map((e) => e.weekday).toList();
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDay(
          hour: json['timeOfDay']['hour'],
          minute: json['timeOfDay']['minute'],
        ),
        _enabled = json['enabled'],
        _label = json['label'],
        _oneTimeSchedules = (json['oneTimeSchedules'] as List<dynamic>)
            .map<OneTimeAlarmSchedule>(
                (item) => OneTimeAlarmSchedule.fromJson(item))
            .toList(),
        _repeatSchedules = (json['repeatSchedules'] as List<dynamic>)
            .map<WeeklyAlarmSchedule>(
                (item) => WeeklyAlarmSchedule.fromJson(item))
            .toList();

  @override
  Map<String, dynamic> toJson() => {
        'timeOfDay': {
          'hour': _timeOfDay.hour,
          'minute': _timeOfDay.minute,
        },
        'enabled': _enabled,
        'label': _label,
        'oneTimeSchedules': _oneTimeSchedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(),
        'repeatSchedules': _repeatSchedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(), //
      };
}
