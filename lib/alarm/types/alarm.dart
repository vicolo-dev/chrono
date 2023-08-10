import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

List<AlarmSchedule> createSchedules(SettingGroup settings) {
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

class Alarm extends CustomizableListItem {
  Time _time;
  bool _isEnabled = true;
  bool _isFinished = false;
  DateTime? _snoozeTime;
  int _snoozeCount = 0;
  SettingGroup _settings = SettingGroup(
    "Alarm Settings",
    appSettings
        .getGroup("Alarm")
        .getGroup("Default Settings")
        .copy()
        .settingItems,
  );

  late List<AlarmSchedule> _schedules;

  @override
  int get id => currentScheduleId;
  @override
  bool get isDeletable => true;
  Time get time => _time;

  /// If an alarm is enabled, it has an active schedule.
  bool get isEnabled => _isEnabled;

  /// If an alarm is finished, it has no further schedules remaining. Hence, it cannot be enabled again.
  bool get isFinished => _isFinished;
  bool get isSnoozed => _snoozeTime != null;

  /// The date and time when the snoozed alarm will ring again.
  /// Will return null if the alarm is not snoozed.
  DateTime? get snoozeTime => _snoozeTime;
  @override
  SettingGroup get settings => _settings;
  String get label => _settings.getSetting("Label").value;
  Type get scheduleType => _settings.getSetting("Type").value;
  Audio get ringtone => _settings.getSetting("Melody").value;
  bool get vibrate => _settings.getSetting("Vibration").value;
  double get snoozeLength => _settings.getSetting("Length").value;
  List<AlarmTask> get tasks => _settings.getSetting("Tasks").value;
  int get maxSnoozes => _settings.getSetting("Max Snoozes").value.toInt();
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
  int get snoozeCount => _snoozeCount;
  bool get maxSnoozeIsReached => _snoozeCount >= maxSnoozes;

  Alarm(this._time) {
    _schedules = createSchedules(_settings);
  }

  Alarm.fromTimeOfDay(TimeOfDay timeOfDay)
      : _time = Time.fromTimeOfDay(timeOfDay) {
    _schedules = createSchedules(_settings);
  }

  @override
  copy() {
    return Alarm.fromAlarm(this);
  }

  Alarm.fromAlarm(Alarm alarm)
      : _isEnabled = alarm._isEnabled,
        _isFinished = alarm._isFinished,
        _time = alarm._time,
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

  /// Sets the value of am alarm setting without notifying any listeners.
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
    // The alarm can only be snoozed the number of times specified in the settings
    _snoozeCount++;
    // When the alarm rang, it was disabled, so we need to enable it again if the user presses snooze
    _isEnabled = true;
    _snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeLength.toInt()),
    );
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

    // Only one of the schedules can be active at a time
    // So we cancel all others and schedule the active one
    for (var schedule in _schedules) {
      if (schedule.runtimeType == scheduleType) {
        schedule.schedule(_time);
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

      // A disable active schedule means that the schedule is not active, but can be
      // activated again. This is the case for one-time alarms that have already rung.
      // This is opposed to a finished schedule, which is not active and cannot be activated again.
      // We disable this alarm only if there are no active schedules and it is not snoozed
      // Disabling it if it is snoozed will cancel the snooze. This should only be
      // done by the user.
      if (activeSchedule.isDisabled && !isSnoozed) {
        disable();
      }
      if (activeSchedule.isFinished) {
        finish();
      }
    }
  }

  void setTime(Time time) {
    _time = time;
  }

  void setTimeFromTimeOfDay(TimeOfDay timeOfDay) {
    _time = Time.fromTimeOfDay(timeOfDay);
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

  Alarm.fromJson(Json json)
      : _time = Time.fromJson(json['timeOfDay']),
        _isEnabled = json['enabled'],
        _isFinished = json['finished'],
        _snoozeTime = json['snoozeTime'] != 0
            ? DateTime.fromMillisecondsSinceEpoch(json['snoozeTime'])
            : null,
        _snoozeCount = json['snoozeCount'],
        _settings = SettingGroup(
          "Alarm Settings",
          appSettings
              .getGroup("Alarm")
              .getGroup("Default Settings")
              .copy()
              .settingItems,
        ) {
    _settings.loadValueFromJson(json['settings']);
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
  Json toJson() => {
        'timeOfDay': _time.toJson(),
        'enabled': _isEnabled,
        'finished': _isFinished,
        'snoozeTime':
            snoozeTime != null ? snoozeTime!.millisecondsSinceEpoch : 0,
        'snoozeCount': _snoozeCount,
        'schedules':
            _schedules.map<Json>((schedule) => schedule.toJson()).toList(),
        'settings': _settings.valueToJson(),
      };
}
