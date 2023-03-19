import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:flutter/material.dart';

class DailyAlarmSchedule extends AlarmSchedule {
  final AlarmRunner _alarmRunner;

  @override
  DateTime? get currentScheduleDateTime => _alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => _alarmRunner.id;

  @override
  bool get isDisabled => false;

  @override
  bool get isFinished => false;

  DailyAlarmSchedule()
      : _alarmRunner = AlarmRunner(),
        super();

  @override
  Future<bool> schedule(TimeOfDay timeOfDay) async {
    DateTime alarmDate = getDailyAlarmDate(timeOfDay);
    return _alarmRunner.schedule(alarmDate);
  }

  @override
  void cancel() {
    _alarmRunner.cancel();
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
      };

  DailyAlarmSchedule.fromJson(Map<String, dynamic> json)
      : _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']),
        super();

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
