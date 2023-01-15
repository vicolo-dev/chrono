import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm_schedule.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

class Alarm extends JsonSerializable {
  bool _enabled = true;
  TimeOfDay _timeOfDay;
  String _label = "";
  int _scheduleType = 0;
  int _ringtone = 0;
  bool _vibrate = true;
  List<OneTimeAlarmSchedule> _oneTimeSchedules = [];
  List<WeeklyAlarmSchedule> _repeatSchedules = [];

  bool get enabled => _enabled;
  TimeOfDay get timeOfDay => _timeOfDay;
  String get label => _label;
  int get scheduleType => _scheduleType;
  int get ringtone => _ringtone;
  bool get vibrate => _vibrate;

  Alarm(this._timeOfDay, {List<int> weekdays = const []}) {
    setSchedules(weekdays);
  }

  Alarm.fromAlarm(Alarm alarm)
      : _enabled = alarm._enabled,
        _timeOfDay = alarm._timeOfDay,
        _label = alarm._label,
        _oneTimeSchedules = alarm._oneTimeSchedules,
        _repeatSchedules = alarm._repeatSchedules,
        _scheduleType = alarm._scheduleType;

  void setSchedules(List<int> weekdays) {
    if (weekdays.isEmpty) {
      _oneTimeSchedules.add(OneTimeAlarmSchedule(_timeOfDay));
    } else {
      for (var weekday in weekdays) {
        _repeatSchedules.add(WeeklyAlarmSchedule(_timeOfDay, weekday));
      }
    }
  }

  void setRingtone(int ringtone) {
    _ringtone = ringtone;
  }

  void setScheduleType(int scheduleType) {
    _scheduleType = scheduleType;
  }

  void setLabel(String label) {
    _label = label;
  }

  void setVibrate(bool vibrate) {
    _vibrate = vibrate;
  }

  void addWeekday(int weekday) {
    _repeatSchedules.add(WeeklyAlarmSchedule(_timeOfDay, weekday));
  }

  void removeWeekday(int weekday) {
    _repeatSchedules
        .firstWhere((element) => element.weekday == weekday)
        .cancel();
    _repeatSchedules.removeWhere((schedule) => schedule.weekday == weekday);
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
      alarm.schedule(_ringtone);
    }
    for (var alarm in _repeatSchedules) {
      alarm.schedule(_ringtone);
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

  List<Weekday> getWeekdays() {
    return _repeatSchedules
        .map((schedule) => schedule.weekday)
        .map((weekdayId) =>
            weekdays.firstWhere((weekday) => weekday.id == weekdayId))
        .toList();
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDayUtils.fromJson(json['timeOfDay']),
        _enabled = json['enabled'],
        _label = json['label'],
        _oneTimeSchedules = (json['oneTimeSchedules'] as List<dynamic>)
            .map<OneTimeAlarmSchedule>(
                (item) => OneTimeAlarmSchedule.fromJson(item))
            .toList(),
        _repeatSchedules = (json['repeatSchedules'] as List<dynamic>)
            .map<WeeklyAlarmSchedule>(
                (item) => WeeklyAlarmSchedule.fromJson(item))
            .toList(),
        _scheduleType = json['scheduleType'],
        _ringtone = json['ringtone'],
        _vibrate = json['vibrate'];

  @override
  Map<String, dynamic> toJson() => {
        'timeOfDay': _timeOfDay.toJson(),
        'enabled': _enabled,
        'label': _label,
        'oneTimeSchedules': _oneTimeSchedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(),
        'repeatSchedules': _repeatSchedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(), //
        'scheduleType': _scheduleType,
        'ringtone': _ringtone,
        'vibrate': _vibrate,
      };
}
