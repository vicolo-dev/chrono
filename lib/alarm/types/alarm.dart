import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/alarm_schedules.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:flutter/material.dart';

class Alarm extends JsonSerializable {
  bool _enabled = true;
  TimeOfDay _timeOfDay;
  Settings _settings = alarmSettingsSchema.copy();

  late List<AlarmSchedule> _schedules;

  bool get enabled => _enabled;
  TimeOfDay get timeOfDay => _timeOfDay;
  Settings get settings => _settings;
  String get label => _settings.getSetting("Label").value;
  Type get scheduleType => _settings.getSetting("Schedule Type").value;
  String get ringtoneUri => _settings.getSetting("Melody").value;
  bool get vibrate => _settings.getSetting("Vibrate").value;
  double get snoozeLength => _settings.getSetting("Length").value;
  AlarmSchedule get activeSchedule =>
      _schedules.firstWhere((schedule) => schedule.runtimeType == scheduleType);
  List<AlarmRunner> get activeAlarmRunners => activeSchedule.alarmRunners;
  bool get isRepeating => [
        RangeAlarmSchedule,
        DailyAlarmSchedule,
        WeeklyAlarmSchedule
      ].contains(scheduleType);
  DateTime get nextScheduleDateTime => activeSchedule.nextScheduleDateTime;

  Alarm(this._timeOfDay) {
    _schedules = [
      OnceAlarmSchedule(_settings),
      DailyAlarmSchedule(_settings),
      WeeklyAlarmSchedule(_settings),
      DatesAlarmSchedule(_settings),
      RangeAlarmSchedule(_settings)
    ];
  }

  Alarm.fromAlarm(Alarm alarm)
      : _enabled = alarm._enabled,
        _timeOfDay = alarm._timeOfDay,
        _schedules = alarm._schedules,
        _settings = alarm._settings;

  T getSchedule<T extends AlarmSchedule>() {
    return _schedules.whereType<T>().first;
  }

  dynamic getSetting(String name) {
    return _settings.getSetting(name);
  }

  void setSetting(String name, dynamic value) {
    _settings.getSetting(name).setValue(value);
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
    for (var schedule in _schedules) {
      if (schedule.runtimeType == scheduleType) {
        schedule.schedule(_timeOfDay);
      } else {
        schedule.cancel();
      }
    }
  }

  void cancel() {
    for (var alarm in _schedules) {
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
  }

  bool hasScheduleWithId(int scheduleId) {
    return _schedules.any((schedule) => schedule.hasId(scheduleId));
  }

  // bool hasId(int scheduleId) {
  //   return activeSchedule.hasId(scheduleId);
  // }

  List<Weekday> getWeekdays() {
    return (getSetting("Week Days") as ToggleSetting<int>)
        .selected
        .map((weekdayId) =>
            weekdays.firstWhere((weekday) => weekday.id == weekdayId))
        .toList();
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDayUtils.fromJson(json['timeOfDay']),
        _enabled = json['enabled'],
        _settings = alarmSettingsSchema.copy() {
    _settings.load(json['settings']);
    _schedules = [
      OnceAlarmSchedule.fromJson(json['schedules'][0], _settings),
      DailyAlarmSchedule.fromJson(json['schedules'][1], _settings),
      WeeklyAlarmSchedule.fromJson(json['schedules'][2], _settings),
      DatesAlarmSchedule.fromJson(json['schedules'][3], _settings),
      RangeAlarmSchedule.fromJson(json['schedules'][4], _settings),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        'timeOfDay': _timeOfDay.toJson(),
        'enabled': _enabled,
        'schedules': _schedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(),
        'settings': _settings.toJson(),
      };
}
