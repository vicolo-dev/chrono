import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm_id.dart';
import 'package:clock_app/alarm/utils/alarm_utils.dart';
import 'package:flutter/material.dart';

class WeekdayAlarmSchedule extends AlarmSchedule {
  final int _weekday;

  int get weekday => _weekday;

  WeekdayAlarmSchedule(TimeOfDay timeOfDay, this._weekday) : super(timeOfDay);

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
    );
  }
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
    );
  }
}

abstract class AlarmSchedule {
  late int _id;
  TimeOfDay _timeOfDay;

  int get id => _id;
  TimeOfDay get timeOfDay => _timeOfDay;

  AlarmSchedule(this._timeOfDay) {
    _id = AlarmId.get();
  }

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
