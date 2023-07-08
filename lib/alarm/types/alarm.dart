import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

List<AlarmSchedule> createSchedules(Settings settings) {
  return [
    OnceAlarmSchedule(),
    DailyAlarmSchedule(),
    WeeklyAlarmSchedule(settings.getSetting("Week Days")),
    DatesAlarmSchedule(settings.getSetting("Dates")),
    RangeAlarmSchedule(
      settings.getSetting("Date Range"),
      settings.getSetting("Interval"),
    ),
  ];
}

class Alarm extends ListItem {
  bool _isEnabled = true;
  DateTime? _snoozeTime;
  bool _isFinished = false;
  TimeOfDay _timeOfDay;
  Settings _settings =
      Settings(appSettings.getGroup("Default Settings").copy().settingItems);

  late List<AlarmSchedule> _schedules;

  @override
  int get id => currentScheduleId;
  bool get isEnabled => _isEnabled;
  bool get isFinished => _isFinished;
  bool get isSnoozed => _snoozeTime != null;
  DateTime? get snoozeTime => _snoozeTime;
  TimeOfDay get timeOfDay => _timeOfDay;
  Settings get settings => _settings;
  String get label => _settings.getSetting("Label").value;
  Type get scheduleType => _settings.getSetting("Type").value;
  String get ringtoneUri => _settings.getSetting("Melody").value;
  bool get vibrate => _settings.getSetting("Vibration").value;
  double get snoozeLength => _settings.getSetting("Length").value;
  TimeDuration get risingVolumeDuration =>
      _settings.getSetting("Rising Volume").value
          ? _settings.getSetting("Time To Full Volume").value
          : TimeDuration.zero;
  AlarmSchedule get activeSchedule =>
      _schedules.firstWhere((schedule) => schedule.runtimeType == scheduleType);
  List<AlarmRunner> get activeAlarmRunners => activeSchedule.alarmRunners;
  bool get isRepeating =>
      [DailyAlarmSchedule, WeeklyAlarmSchedule].contains(scheduleType);
  DateTime? get currentScheduleDateTime =>
      activeSchedule.currentScheduleDateTime;
  int get currentScheduleId => activeSchedule.currentAlarmRunnerId;

  Alarm(this._timeOfDay) {
    _schedules = createSchedules(_settings);
  }

  Alarm.fromAlarm(Alarm alarm)
      : _isEnabled = alarm._isEnabled,
        _isFinished = alarm._isFinished,
        _timeOfDay = alarm._timeOfDay,
        _settings = alarm._settings.copy() {
    _schedules = createSchedules(_settings);
  }

  T getSchedule<T extends AlarmSchedule>() {
    return _schedules.whereType<T>().first;
  }

  dynamic getSetting(String name) {
    return _settings.getSetting(name);
  }

  void setSetting(BuildContext context, String name, dynamic value) {
    _settings.getSetting(name).setValue(context, value);
  }

  void setSettingWithoutNotify(String name, dynamic value) {
    _settings.getSetting(name).setValueWithoutNotify(value);
  }

  void toggle() {
    if (_isEnabled) {
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

  void snooze() {
    _snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeLength.toInt()),
    );
    _isEnabled = true;
    scheduleSnoozeAlarm(
      id,
      Duration(minutes: snoozeLength.floor()),
      ScheduledNotificationType.alarm,
    );
  }

  void unSnooze() {
    _snoozeTime = null;
  }

  void schedule() {
    _isEnabled = true;

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
    schedule();
  }

  void disable() {
    _isEnabled = false;
    cancel();
  }

  void finish() {
    disable();
    _isFinished = true;
  }

  void update() {
    if (_isEnabled) {
      schedule();

      if (activeSchedule.isDisabled && !isSnoozed) {
        disable();
      }
      if (activeSchedule.isFinished) {
        finish();
      }
    }
  }

  void setTimeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
  }

  bool hasScheduleWithId(int scheduleId) {
    return _schedules.any((schedule) => schedule.hasId(scheduleId));
  }

  List<Weekday> get weekdays =>
      getSchedule<WeeklyAlarmSchedule>().scheduledWeekdays;

  List<DateTime> get dates {
    return (getSetting("Dates") as DateTimeSetting).value;
  }

  DateTime get startDate {
    return (getSetting("Date Range") as DateTimeSetting).value[0];
  }

  DateTime get endDate {
    return (getSetting("Date Range") as DateTimeSetting).value[1];
  }

  Duration get interval {
    return (getSetting("Interval") as SelectSetting<Duration>).value;
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDayUtils.fromJson(json['timeOfDay']),
        _isEnabled = json['enabled'],
        _isFinished = json['finished'],
        _snoozeTime = json['snoozeTime'] != 0
            ? DateTime.fromMillisecondsSinceEpoch(json['snoozeTime'])
            : null,
        _settings = Settings(
            appSettings.getGroup("Default Settings").copy().settingItems) {
    _settings.fromJson(json['settings']);
    _schedules = [
      OnceAlarmSchedule.fromJson(json['schedules'][0]),
      DailyAlarmSchedule.fromJson(json['schedules'][1]),
      WeeklyAlarmSchedule.fromJson(
        json['schedules'][2],
        _settings.getSetting("Week Days"),
      ),
      DatesAlarmSchedule.fromJson(
        json['schedules'][3],
        settings.getSetting("Dates"),
      ),
      RangeAlarmSchedule.fromJson(
        json['schedules'][4],
        settings.getSetting("Date Range"),
        settings.getSetting("Interval"),
      ),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        'timeOfDay': _timeOfDay.toJson(),
        'enabled': _isEnabled,
        'finished': _isFinished,
        'snoozeTime':
            snoozeTime != null ? snoozeTime!.millisecondsSinceEpoch : 0,
        'schedules': _schedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(),
        'settings': _settings.toJson(),
      };
}
