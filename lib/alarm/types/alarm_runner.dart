import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:flutter/material.dart';

class AlarmRunner extends JsonSerializable {
  late int _id;
  DateTime? _currentScheduleDateTime;

  int get id => _id;
  DateTime? get currentScheduleDateTime => _currentScheduleDateTime;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  void schedule(DateTime dateTime) {
    _currentScheduleDateTime = dateTime;
    scheduleAlarm(_id, dateTime);
  }

  AlarmRunner.fromJson(Map<String, dynamic> json) : _id = json['id'] {
    int millisecondsSinceEpoch = json['nextScheduleDateTime'];

    _currentScheduleDateTime = millisecondsSinceEpoch == 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['nextScheduleDateTime']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': _id,
        'nextScheduleDateTime':
            _currentScheduleDateTime?.millisecondsSinceEpoch ?? 0,
      };

  void cancel() {
    cancelAlarm(_id);
  }
}
