import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:flutter/material.dart';

class AlarmRunner extends JsonSerializable {
  late int _id;
  DateTime? _currentScheduleDateTime;

  int get id => _id;
  DateTime? get currentScheduleDateTime => _currentScheduleDateTime;

  AlarmRunner() {
    _id = UniqueKey().hashCode;
  }

  Future<void> schedule(DateTime dateTime, String description) async {
    _currentScheduleDateTime = dateTime;
    await scheduleAlarm(_id, dateTime, description);
  }

  Future<void> cancel() async {
    if (_currentScheduleDateTime == null) return;
    _currentScheduleDateTime = null;
    await cancelAlarm(_id, ScheduledNotificationType.alarm);
  }

  AlarmRunner.fromJson(Json? json) {
    if (json == null) {
      _id = UniqueKey().hashCode;
      return;
    }
    _id = json['id'] ?? UniqueKey().hashCode;
    int millisecondsSinceEpoch = json['currentScheduleDateTime'] ?? 0;
    _currentScheduleDateTime = millisecondsSinceEpoch == 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            json['currentScheduleDateTime'] ?? 0);
  }

  @override
  Json toJson() => {
        'id': _id,
        'currentScheduleDateTime':
            _currentScheduleDateTime?.millisecondsSinceEpoch ?? 0,
      };
}
