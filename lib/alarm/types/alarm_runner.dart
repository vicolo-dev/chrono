import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/types/schedule_type.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:flutter/material.dart';

// abstract class AlarmRunner extends JsonSerializable {
//   late int _id;

//   int get id => _id;

//   AlarmRunner() {
//     _id = UniqueKey().hashCode;
//   }

//   AlarmRunner.fromJson(Map<String, dynamic> json) : _id = json['id'];

//   @override
//   Map<String, dynamic> toJson() => {
//         'id': _id,
//       };

//   void schedule(DateTime startDate, int ringtoneIndex);

//   void cancel() {
//     AndroidAlarmManager.cancel(_id);
//   }
// }

// class PeriodicAlarmRunner extends AlarmRunner {
//   final Duration _interval;

//   PeriodicAlarmRunner(this._interval) : super();

//   @override
//   void schedule(DateTime startDate, int ringtoneIndex) {
//     cancel();
//     AndroidAlarmManager.periodic(
//       _interval,
//       id,
//       ringAlarm,
//       allowWhileIdle: true,
//       startAt: startDate,
//       exact: true,
//       wakeup: true,
//       rescheduleOnReboot: true,
//       params: <String, String>{
//         'scheduleId': _id.toString(),
//         'timeOfDay': startDate.toTimeOfDay().encode(),
//         'ringtoneIndex': ringtoneIndex.toString(),
//         'type': "repeat",
//       },
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() => {
//         ...super.toJson(),
//         'interval': _interval.inMilliseconds,
//       };

//   PeriodicAlarmRunner.fromJson(Map<String, dynamic> json)
//       : _interval = Duration(milliseconds: json['interval']),
//         super.fromJson(json);
// }

class AlarmRunner extends JsonSerializable {
  late int _id;
  DateTime _nextScheduleDateTime = DateTime.now();

  int get id => _id;
  DateTime get nextScheduleDateTime => _nextScheduleDateTime;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  void schedule(DateTime dateTime, int ringtoneIndex,
      {Duration repeatInterval = Duration.zero}) {
    _nextScheduleDateTime = dateTime;
    scheduleAlarm(_id, dateTime, ringtoneIndex, repeatInterval: repeatInterval);
  }

  AlarmRunner.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _nextScheduleDateTime =
            DateTime.fromMillisecondsSinceEpoch(json['nextScheduleDateTime']);

  @override
  Map<String, dynamic> toJson() => {
        'id': _id,
        'nextScheduleDateTime': _nextScheduleDateTime.millisecondsSinceEpoch,
      };

  void cancel() {
    cancelAlarm(_id);
  }
}
