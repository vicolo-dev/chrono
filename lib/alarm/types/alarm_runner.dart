import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:flutter/material.dart';

class AlarmRunner extends JsonSerializable {
  late int _id;
  DateTime _nextScheduleDateTime = DateTime.now();

  int get id => _id;
  DateTime get nextScheduleDateTime => _nextScheduleDateTime;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  void schedule(DateTime dateTime, String ringtoneUri,
      {Duration repeatInterval = Duration.zero}) {
    _nextScheduleDateTime = dateTime;
    scheduleAlarm(_id, dateTime, ringtoneUri, repeatInterval: repeatInterval);
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
