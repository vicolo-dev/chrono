import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/schedule_type.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:flutter/material.dart';

abstract class AlarmRunner extends JsonSerializable {
  late int _id;

  int get id => _id;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  AlarmRunner.fromJson(Map<String, dynamic> json) : _id = json['id'];

  @override
  Map<String, dynamic> toJson() => {
        'id': _id,
      };

  void schedule(DateTime startDate, int ringtoneIndex);

  void cancel() {
    AndroidAlarmManager.cancel(_id);
  }
}

class PeriodicAlarmRunner extends AlarmRunner {
  final Duration _interval;

  PeriodicAlarmRunner(this._interval) : super();

  @override
  void schedule(DateTime startDate, int ringtoneIndex) {
    cancel();
    AndroidAlarmManager.periodic(
      _interval,
      id,
      ringAlarm,
      allowWhileIdle: true,
      startAt: startDate,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': _id.toString(),
        'timeOfDay': startDate.toTimeOfDay().encode(),
        'ringtoneIndex': ringtoneIndex.toString(),
      },
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'interval': _interval.inMilliseconds,
      };

  PeriodicAlarmRunner.fromJson(Map<String, dynamic> json)
      : _interval = Duration(milliseconds: json['interval']),
        super.fromJson(json);
}

class OneTimeAlarmRunner extends AlarmRunner {
  OneTimeAlarmRunner() : super();

  @override
  void schedule(DateTime startDate, int ringtoneIndex) {
    cancel();
    AndroidAlarmManager.oneShotAt(
      startDate,
      id,
      ringAlarm,
      allowWhileIdle: true,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': _id.toString(),
        'timeOfDay': startDate.toTimeOfDay().encode(),
        'ringtoneIndex': ringtoneIndex.toString(),
      },
    );
  }

  OneTimeAlarmRunner.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
