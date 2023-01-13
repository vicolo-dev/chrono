import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

class WeeklyAlarmSchedule extends AlarmSchedule {
  final int _weekday;

  int get weekday => _weekday;

  WeeklyAlarmSchedule(TimeOfDay timeOfDay, this._weekday) : super(timeOfDay);

  @override
  DateTime getNextAlarmDate() {
    return getRepeatAlarmDate(_timeOfDay, _weekday);
  }

  @override
  void schedule() {
    cancel();
    AndroidAlarmManager.periodic(
      const Duration(days: 7),
      id,
      ringAlarm,
      allowWhileIdle: true,
      startAt: getNextAlarmDate(),
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': _id.toString(),
        'timeOfDay': _timeOfDay.encode()
      },
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': _id,
        'timeOfDay': _timeOfDay.toJson(),
        'weekday': _weekday,
      };

  WeeklyAlarmSchedule.fromJson(Map<String, dynamic> json)
      : _weekday = json['weekday'],
        super.fromJson(json);
}

class OneTimeAlarmSchedule extends AlarmSchedule {
  OneTimeAlarmSchedule(TimeOfDay timeOfDay) : super(timeOfDay);

  @override
  DateTime getNextAlarmDate() {
    return getOneTimeAlarmDate(_timeOfDay);
  }

  @override
  void schedule() {
    cancel();
    AndroidAlarmManager.oneShotAt(
      getNextAlarmDate(),
      id,
      ringAlarm,
      allowWhileIdle: true,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': _id.toString(),
        'timeOfDay': _timeOfDay.encode()
      },
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {'id': _id, 'timeOfDay': _timeOfDay.toJson()};

  OneTimeAlarmSchedule.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}

abstract class AlarmSchedule {
  late int _id;
  TimeOfDay _timeOfDay;

  int get id => _id;
  TimeOfDay get timeOfDay => _timeOfDay;

  AlarmSchedule(this._timeOfDay) {
    _id = UniqueKey().hashCode;
  }

  AlarmSchedule.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _timeOfDay = TimeOfDayUtils.fromJson(json['timeOfDay']);

  Map<String, dynamic> toJson();

  void setTimeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
    schedule();
  }

  DateTime getNextAlarmDate();

  void schedule();

  void cancel() {
    AndroidAlarmManager.cancel(_id);
  }
}
