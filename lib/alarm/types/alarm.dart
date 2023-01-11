import 'dart:convert';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/utils/alarm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:just_audio/just_audio.dart';

@pragma('vm:entry-point')
void _ringAlarm() async {
  var alarms = await FlutterSystemRingtones.getAlarmSounds();
  final DateTime now = DateTime.now();
  final player = AudioPlayer();
  await player.setAudioSource(AudioSource.uri(Uri.parse(alarms[0].uri)));
  player.play();
  print("[$now] Alarm ringing");
}

class AlarmId {
  static int _id = 0;
  static int get() => _id++;
}

class WeekdayAlarmSchedule extends AlarmSchedule {
  WeekdayAlarmSchedule(TimeOfDay timeOfDay, int weekday)
      : super(getRepeatAlarmDate(timeOfDay, weekday)) {
    schedule();
  }

  WeekdayAlarmSchedule.withoutScheduling(TimeOfDay timeOfDay, int weekday)
      : super(getRepeatAlarmDate(timeOfDay, weekday));

  int getWeekDay() {
    return dateTime.weekday;
  }

  @override
  DateTime getNextAlarmDate(TimeOfDay timeOfDay) {
    return getRepeatAlarmDate(timeOfDay, getWeekDay());
  }

  @override
  void schedule() {
    AndroidAlarmManager.periodic(
      const Duration(days: 7),
      id,
      _ringAlarm,
      allowWhileIdle: true,
      startAt: dateTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }
}

class OneTimeAlarmSchedule extends AlarmSchedule {
  OneTimeAlarmSchedule(TimeOfDay timeOfDay)
      : super(getOneTimeAlarmDate(timeOfDay)) {
    schedule();
  }

  OneTimeAlarmSchedule.withoutScheduling(TimeOfDay timeOfDay)
      : super(getOneTimeAlarmDate(timeOfDay));

  @override
  DateTime getNextAlarmDate(TimeOfDay timeOfDay) {
    return getOneTimeAlarmDate(timeOfDay);
  }

  @override
  void schedule() {
    AndroidAlarmManager.oneShotAt(
      dateTime,
      id,
      _ringAlarm,
      allowWhileIdle: true,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }
}

abstract class AlarmSchedule {
  late int _id;
  DateTime _dateTime;

  int get id => _id;
  DateTime get dateTime => _dateTime;

  AlarmSchedule(this._dateTime) {
    _id = AlarmId.get();
  }

  void changeDateTime(TimeOfDay timeOfDay) {
    _dateTime = getNextAlarmDate(timeOfDay);
    cancel();
    schedule();
  }

  DateTime getNextAlarmDate(TimeOfDay timeOfDay);

  void schedule();

  void cancel() {
    AndroidAlarmManager.cancel(_id);
  }
}

class Alarm {
  bool _enabled = false;
  TimeOfDay _timeOfDay;
  final List<OneTimeAlarmSchedule> _oneTimeAlarms = [];
  final List<WeekdayAlarmSchedule> _repeatAlarms = [];

  bool get enabled => _enabled;
  TimeOfDay get timeOfDay => _timeOfDay;

  Alarm(this._timeOfDay, {List<int> weekdays = const []}) {
    _enabled = true;
    setSchedules(weekdays);
  }

  void setSchedules(List<int> weekdays) {
    if (weekdays.isEmpty) {
      _oneTimeAlarms.add(OneTimeAlarmSchedule(_timeOfDay));
    } else {
      for (var weekday in weekdays) {
        _repeatAlarms.add(WeekdayAlarmSchedule(_timeOfDay, weekday));
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

  void enable() {
    _enabled = true;
    for (var alarm in _oneTimeAlarms) {
      alarm.schedule();
    }
    for (var alarm in _repeatAlarms) {
      alarm.schedule();
    }
  }

  void disable() {
    _enabled = false;
    for (var alarm in _oneTimeAlarms) {
      alarm.cancel();
    }
    for (var alarm in _repeatAlarms) {
      alarm.cancel();
    }
  }

  void changeTimeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
    for (var alarm in _oneTimeAlarms) {
      alarm.changeDateTime(_timeOfDay);
    }
    for (var alarm in _repeatAlarms) {
      alarm.changeDateTime(_timeOfDay);
    }
  }

  List<int> getWeekdays() {
    return _repeatAlarms.map((e) => e.getWeekDay()).toList();
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDay(
          hour: json['time']['hour'],
          minute: json['time']['minute'],
        ),
        _enabled = json['enabled'] {
    setSchedules(json['weekDays'].cast<int>());
  }

  Map<String, dynamic> toJson() => {
        'time': {
          'hour': _timeOfDay.hour,
          'minute': _timeOfDay.minute,
        },
        'enabled': _enabled,
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
