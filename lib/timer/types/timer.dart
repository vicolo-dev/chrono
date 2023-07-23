import 'dart:math' as math;

import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/timer/types/time_duration.dart';

class ClockTimer extends ListItem {
  TimeDuration _duration;
  TimeDuration _currentDuration;
  int _secondsRemainingOnPause;
  DateTime _startTime;
  TimerState _state;
  final int _id;
  SettingGroup _settings = SettingGroup(
    "Timer Settings",
    appSettings
        .getGroup("Timer")
        .getGroup("Default Settings")
        .copy()
        .settingItems,
  );

  @override
  int get id => _id;
  SettingGroup get settings => _settings;
  String get label => _settings.getSetting("Label").value.isNotEmpty
      ? _settings.getSetting("Label").value
      : '${_duration.toString()} timer';
  String get ringtoneUri => _settings.getSetting("Melody").value;
  bool get vibrate => _settings.getSetting("Vibration").value;
  TimeDuration get risingVolumeDuration =>
      _settings.getSetting("Rising Volume").value
          ? _settings.getSetting("Time To Full Volume").value
          : TimeDuration.zero;
  double get addLength => _settings.getSetting("Add Length").value;
  TimeDuration get duration => _duration;
  TimeDuration get currentDuration => _currentDuration;
  int get remainingSeconds {
    if (isRunning) {
      return math.max(
          _secondsRemainingOnPause -
              DateTime.now().difference(_startTime).toTimeDuration().inSeconds,
          0);
    } else {
      return _secondsRemainingOnPause;
    }
  }

  bool get isRunning => _state == TimerState.running;
  TimerState get state => _state;

  ClockTimer(this._duration)
      : _id = UniqueKey().hashCode,
        _currentDuration = TimeDuration.from(_duration),
        _secondsRemainingOnPause = _duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped;

  ClockTimer.from(ClockTimer timer)
      : _duration = timer._duration,
        _currentDuration = TimeDuration.from(timer._duration),
        _secondsRemainingOnPause = timer._duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped,
        _settings = timer._settings.copy(),
        _id = timer.id;

  void setSetting(BuildContext context, String name, dynamic value) {
    _settings.getSetting(name).setValue(context, value);
  }

  void setSettingWithoutNotify(String name, dynamic value) {
    _settings.getSetting(name).setValueWithoutNotify(value);
  }

  void start() {
    _startTime = DateTime.now();
    scheduleAlarm(
        _id, DateTime.now().add(Duration(seconds: _secondsRemainingOnPause)),
        type: ScheduledNotificationType.timer);
    _state = TimerState.running;
  }

  void setDuration(TimeDuration newDuration) {
    _duration = TimeDuration.from(newDuration);
    _currentDuration = TimeDuration.from(newDuration);
    _secondsRemainingOnPause = newDuration.inSeconds;
  }

  void setTime(TimeDuration newDuration) {
    _currentDuration = TimeDuration.from(newDuration);
    _secondsRemainingOnPause = newDuration.inSeconds;
    scheduleAlarm(_id, DateTime.now().add(Duration(seconds: remainingSeconds)),
        type: ScheduledNotificationType.timer);
  }

  void addTime() {
    TimeDuration addedDuration = TimeDuration(minutes: addLength.floor());
    _currentDuration = _currentDuration.add(addedDuration);
    // _startTime = _startTime.subtract(addedDuration.toDuration);
    _secondsRemainingOnPause =
        _secondsRemainingOnPause + addedDuration.inSeconds;
    scheduleAlarm(_id, DateTime.now().add(Duration(seconds: remainingSeconds)),
        type: ScheduledNotificationType.timer);
  }

  void pause() {
    cancelAlarm(_id);
    _secondsRemainingOnPause = _secondsRemainingOnPause -
        DateTime.now().difference(_startTime).toTimeDuration().inSeconds;
    _state = TimerState.paused;
  }

  void reset() {
    cancelAlarm(_id);
    _state = TimerState.stopped;
    _currentDuration = TimeDuration.from(_duration);
    _secondsRemainingOnPause = _duration.inSeconds;
  }

  void toggleState() {
    if (state == TimerState.running) {
      pause();
    } else {
      start();
    }
  }

  bool equals(ClockTimer timer) {
    return _duration == timer._duration &&
        _currentDuration == timer._currentDuration &&
        _secondsRemainingOnPause == timer._secondsRemainingOnPause &&
        _startTime == timer._startTime &&
        _state == timer._state &&
        _id == timer._id;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'duration': _duration.inSeconds,
      'currentDuration': _currentDuration.inSeconds,
      'id': _id,
      'durationRemainingOnPause': _secondsRemainingOnPause,
      'startTime': _startTime.toIso8601String(),
      'state': _state.toString(),
      'settings': _settings.toJson(),
    };
  }

  ClockTimer.fromJson(Map<String, dynamic> json)
      : _duration = TimeDuration.fromSeconds(json['duration']),
        _currentDuration = TimeDuration.fromSeconds(json['currentDuration']),
        _secondsRemainingOnPause = json['durationRemainingOnPause'],
        _startTime = DateTime.parse(json['startTime']),
        _state =
            TimerState.values.firstWhere((e) => e.toString() == json['state']),
        _id = json['id'],
        _settings = SettingGroup(
          "Timer Settings",
          appSettings
              .getGroup("Timer")
              .getGroup("Default Settings")
              .copy()
              .settingItems,
        ) {
    _settings.fromJson(json['settings']);
  }
}
