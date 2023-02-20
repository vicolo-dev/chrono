import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

enum TimerState { stopped, running, paused }

class ClockTimer extends JsonSerializable {
  final TimeDuration _duration;
  int _secondsRemainingOnPause;
  DateTime _startTime;
  TimerState _state;
  final int _id;
  bool vibrate = true;

  int get id => _id;
  TimeDuration get duration => _duration;
  int get remainingSeconds =>
      _secondsRemainingOnPause -
      DateTime.now().difference(_startTime).toTimeDuration().inSeconds;
  TimerState get state => _state;

  ClockTimer(this._duration)
      : _id = UniqueKey().hashCode,
        _secondsRemainingOnPause = _duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped;

  ClockTimer.fromTimer(ClockTimer timer)
      : _duration = timer._duration,
        _secondsRemainingOnPause = timer._duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped,
        _id = UniqueKey().hashCode;

  void start() {
    _startTime = DateTime.now();
    scheduleAlarm(
        _id, DateTime.now().add(Duration(seconds: _secondsRemainingOnPause)),
        type: AlarmType.timer);
    _state = TimerState.running;
  }

  void pause() {
    cancelAlarm(_id);
    _secondsRemainingOnPause = _secondsRemainingOnPause -
        DateTime.now().difference(_startTime).toTimeDuration().inSeconds;
    _state = TimerState.paused;
    print(_secondsRemainingOnPause);
  }

  void reset() {
    cancelAlarm(_id);
    _state = TimerState.stopped;
    _secondsRemainingOnPause = _duration.inSeconds;
  }

  void toggleStart() {
    if (state == TimerState.running) {
      pause();
    } else {
      start();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'duration': _duration.inSeconds,
      'id': _id,
      'durationRemainingOnPause': _secondsRemainingOnPause,
      'startTime': _startTime.toIso8601String(),
      'state': _state.toString(),
    };
  }

  ClockTimer.fromJson(Map<String, dynamic> json)
      : _duration = TimeDuration.fromSeconds(json['duration']),
        _secondsRemainingOnPause = json['durationRemainingOnPause'],
        _startTime = DateTime.parse(json['startTime']),
        _state =
            TimerState.values.firstWhere((e) => e.toString() == json['state']),
        _id = json['id'];
}
