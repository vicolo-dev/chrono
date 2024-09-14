import 'package:audio_session/audio_session.dart';
import 'package:clock_app/alarm/logic/alarm_reminder_notifications.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/range_interval.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/types/time.dart';
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
  late Time _time;
  bool _isEnabled = true;
  bool _markedForDeletion = false;
  // bool _isFinished = false;
  DateTime? _snoozeTime;
  int _snoozeCount = 0;
  DateTime? _skippedTime;
  SettingGroup _settings = SettingGroup(
    "Alarm Settings",
    (context) => "Alarm Settings",
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
  bool get isDeletable => !(isSnoozed && !canBeDeletedWhenSnoozed);
  Time get time => _time;

  bool get isMarkedForDeletion => _markedForDeletion;

  /// If an alarm is enabled, it has an active schedule.
  bool get isEnabled => _isEnabled;

  /// If an alarm is finished, it has no further schedules remaining. Hence, it cannot be enabled again.
  bool get isFinished => activeSchedule.isFinished;
  bool get isSnoozed => _snoozeTime != null;

  /// The date and time when the snoozed alarm will ring again.
  /// Will return null if the alarm is not snoozed.
  DateTime? get snoozeTime => _snoozeTime;
  @override
  SettingGroup get settings => _settings;
  String get label => _settings.getSetting("Label").value;
  Type get scheduleType => _settings.getSetting("Type").value;
  FileItem get ringtone => _settings.getSetting("Melody").value;
  bool get shouldStartMelodyAtRandomPos =>
      _settings.getSetting("start_melody_at_random_pos").value;
  bool get vibrate => _settings.getSetting("Vibration").value;
  double get volume => _settings.getSetting("Volume").value;
  double get volumeDuringTasks => _settings.getSetting("task_volume").value;
  double get snoozeLength => _settings.getSetting("Length").value;
  List<AlarmTask> get tasks => _settings.getSetting("Tasks").value;
  List<Tag> get tags => _settings.getSetting("Tags").value;
  int get maxSnoozes => _settings.getSetting("Max Snoozes").value.toInt();
  bool get canBeDisabledWhenSnoozed =>
      !_settings.getSetting("Prevent Disabling").value;
  bool get canBeDeletedWhenSnoozed =>
      !_settings.getSetting("Prevent Deletion").value;
  TimeDuration get risingVolumeDuration =>
      _settings.getSetting("Rising Volume").value
          ? _settings.getSetting("Time To Full Volume").value
          : TimeDuration.zero;
  AndroidAudioUsage get audioChannel =>
      _settings.getSetting("Audio Channel").value;
  AlarmSchedule get activeSchedule =>
      _schedules.firstWhere((schedule) => schedule.runtimeType == scheduleType);
  List<AlarmRunner> get activeAlarmRunners => activeSchedule.alarmRunners;
  bool get isRepeating =>
      [DailyAlarmSchedule, WeeklyAlarmSchedule].contains(scheduleType);
  DateTime? get currentScheduleDateTime =>
      _snoozeTime ?? activeSchedule.currentScheduleDateTime;
  int get currentScheduleId => activeSchedule.currentAlarmRunnerId;
  int get snoozeCount => _snoozeCount;
  bool get maxSnoozeIsReached => _snoozeCount >= maxSnoozes;
  bool get canBeSnoozed =>
      !maxSnoozeIsReached &&
      _settings.getGroup("Snooze").getSetting("Enabled").value;
  bool get shouldSkipNextAlarm =>
      _skippedTime == currentScheduleDateTime &&
      currentScheduleDateTime != null;
  bool get canBeSkipped => !isSnoozed && !isFinished && isEnabled;
  bool get canBeDisabled =>
      !(isSnoozed && !canBeDisabledWhenSnoozed) && !isFinished;
  bool get shouldDeleteAfterFinish =>
      _settings.getSetting("Delete After Finishing").value;
  bool get shouldDeleteAfterRinging =>
      _settings.getSetting("Delete After Ringing").value;

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
        _time = alarm._time,
        _snoozeCount = alarm._snoozeCount,
        _snoozeTime = alarm._snoozeTime,
        _markedForDeletion = alarm._markedForDeletion,
        _skippedTime = alarm._skippedTime,
        _settings = alarm._settings.copy() {
    _schedules = createSchedules(_settings);
  }

  @override
  void copyFrom(dynamic other) {
    _isEnabled = other._isEnabled;
    _time = other._time;
    _snoozeCount = other._snoozeCount;
    _snoozeTime = other._snoozeTime;
    _skippedTime = other._skippedTime;
    _settings = other._settings.copy();
    _schedules = other._schedules;
    _markedForDeletion = other._markedForDeletion;
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

  // Skipping the alarm doesn't actually remove the scheduled alarm. Instead, it
  // just doesn't ring the alarm when it triggers. We don't remove the schedule
  // because it is required to chain-schedule the next alarms in daily/weekly/date/range schedules
  void skip() {
    _skippedTime = currentScheduleDateTime;
    // We reschedule the alarm as a non-alarmclock so it is no longer visible to the system
    schedule("skip(): Update alarm on skip");
  }

  void cancelSkip() {
    if (_skippedTime == null) return;
    _skippedTime = null;
    updateReminderNotification();
  }

  Future<void> toggle(String description) async {
    if (_isEnabled) {
      await disable();
    } else {
      await enable(description);
    }
  }

  void setShouldSkip(bool shouldSkip) {
    if (shouldSkip) {
      skip();
    } else {
      cancelSkip();
    }
  }

  Future<void> setIsEnabled(bool enabled, String description) async {
    if (enabled) {
      await enable(description);
    } else {
      await disable();
    }
  }

  Future<void> snooze() async {
    // The alarm can only be snoozed the number of times specified in the settings
    _snoozeCount++;
    // When the alarm rang, it was disabled, so we need to enable it again if the user presses snooze
    _isEnabled = true;
    // Snoozing should cancel any skip
    _skippedTime = null;
    _snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeLength.floor()),
    );
    await _scheduleSnooze();
  }

  Future<void> _scheduleSnooze() async {
    await scheduleSnoozeAlarm(
      id,
      Duration(minutes: snoozeLength.floor()),
      ScheduledNotificationType.alarm,
      "_scheduleSnooze(): Alarm snoozed for $snoozeLength minutes",
    );
  }

  Future<void> cancelSnooze() async {
    await cancelAlarm(id, ScheduledNotificationType.alarm);
    _unSnooze();
  }

  void _unSnooze() {
    _snoozeTime = null;
  }

  Future<void> schedule(String description) async {
    _isEnabled = true;

    // Only one of the schedules can be active at a time
    // So we cancel all others and schedule the active one
    for (var schedule in _schedules) {
      if (schedule.runtimeType == scheduleType) {
        // If alarm is skipped, we do not want it to show to the system,
        // So we set alarmClock param of AlarmManager to false
        await schedule.schedule(_time, description, _skippedTime == null);
      } else {
        await schedule.cancel();
      }
    }
    updateReminderNotification();
  }

  Future<void> updateReminderNotification() async {
    if (!isSnoozed &&
        !activeSchedule.isDisabled &&
        currentScheduleDateTime != null &&
        !shouldSkipNextAlarm) {
      await createAlarmReminderNotification(
          id, label, currentScheduleDateTime!, tasks.isNotEmpty);
    } else {
      for (var schedule in _schedules) {
        cancelAlarmReminderNotification(schedule.currentAlarmRunnerId);
      }
    }
  }
  // Future<void> cancelReminderNotification() async {
  //   await cancelAlarmReminderNotification(id);
  // }

  Future<void> cancelAllSchedules() async {}

  Future<void> cancel() async {
    cancelSkip();
    for (var schedule in _schedules) {
      await schedule.cancel();
    }
    updateReminderNotification();
  }

  Future<void> enable(String description) async {
    _unSnooze();
    await schedule(description);
  }

  Future<void> disable() async {
    _isEnabled = false;
    _unSnooze();
    await cancel();
  }

  Future<void> finish() async {
    await disable();
    // _isFinished = true;
  }

  void handleDismiss() {
    _snoozeCount = 0;
    if (scheduleType == OnceAlarmSchedule && shouldDeleteAfterRinging ||
        shouldDeleteAfterFinish && isFinished) {
      _markedForDeletion = true;
    }
  }

  Future<void> handleEdit(String description) async {
    _isEnabled = true;
    _unSnooze();
    await update(description);
  }

  Future<void> update(String description) async {
    if (isEnabled) {
      if (_skippedTime != null &&
          _skippedTime!.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
        cancelSkip();
      }

      await schedule(description);

      if (isSnoozed) {
        if (DateTime.now().isAfter(_snoozeTime!)) {
          _unSnooze();
        } else {
          await _scheduleSnooze();
        }
      }

      // A disabled active schedule means that the schedule is not active, but can be
      // activated again. This is the case for one-time alarms that have already rung.
      // This is different from a finished schedule, which is not active and cannot be activated again.
      // (Date schedules, for which all dates have already passed etc.)
      // We disable this alarm only if there are no active schedules and it is not snoozed
      // Disabling it if it is snoozed will cancel the snooze. This should only be
      // done by the user.
      if (activeSchedule.isDisabled && !isSnoozed) {
        await disable();
      }
      if (isFinished) {
        await finish();
      }
    }
  }

  void setRingtone(BuildContext context, int index) {
    ;
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

  RangeInterval get interval {
    return (getSetting("Interval") as SelectSetting<RangeInterval>).value;
  }

  Alarm.fromJson(Json json) {
    if (json == null) {
      _time = Time.now();
      _schedules = createSchedules(_settings);
      return;
    }
    _time = json['timeOfDay'] != null
        ? Time.fromJson(json['timeOfDay'])
        : Time.now();
    _isEnabled = json['enabled'] ?? false;
    _markedForDeletion = json['markedForDeletion'] ?? false;
    // _isFinished = json['finished'] ?? false;
    _skippedTime = json['skippedTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['skippedTime'])
        : null;
    _snoozeTime = (json['snoozeTime'] != null && json['snoozeTime'] != 0)
        ? DateTime.fromMillisecondsSinceEpoch(json['snoozeTime'])
        : null;
    _snoozeCount = json['snoozeCount'] ?? 0;
    _settings = SettingGroup(
      "Alarm Settings",
      (context) => "Alarm Settings",
      appSettings
          .getGroup("Alarm")
          .getGroup("Default Settings")
          .copy()
          .settingItems,
    );
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
        'markedForDeletion': _markedForDeletion,
        // 'finished': _isFinished,
        'snoozeTime': snoozeTime?.millisecondsSinceEpoch,
        'snoozeCount': _snoozeCount,
        'schedules':
            _schedules.map<Json>((schedule) => schedule.toJson()).toList(),
        'settings': _settings.valueToJson(),
        'skippedTime': _skippedTime?.millisecondsSinceEpoch,
      };
}
