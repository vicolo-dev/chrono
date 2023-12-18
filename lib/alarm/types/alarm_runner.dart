import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:flutter/material.dart';

class AlarmRunner extends JsonSerializable {
  late int _id;
  DateTime? _currentScheduleDateTime;

  int get id => _id;
  DateTime? get currentScheduleDateTime => _currentScheduleDateTime;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  Future<bool> schedule(DateTime dateTime) async {
    _currentScheduleDateTime = dateTime;
    return await scheduleAlarm(_id, dateTime);
  }

  void cancel() {
    _currentScheduleDateTime = null;
    cancelAlarm(_id);
  }

  AlarmRunner.fromJson(Json? json) {
    if (json == null) {
      _id = UniqueKey().hashCode;
      return;
    }
    _id = json['id'];
    int millisecondsSinceEpoch = json['currentScheduleDateTime'];
    _currentScheduleDateTime = millisecondsSinceEpoch == 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['currentScheduleDateTime']);
  }

  @override
  Json toJson() => {
        'id': _id,
        'currentScheduleDateTime':
            _currentScheduleDateTime?.millisecondsSinceEpoch ?? 0,
      };
}
