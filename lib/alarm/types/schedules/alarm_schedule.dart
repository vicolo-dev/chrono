import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:flutter/material.dart';

abstract class AlarmSchedule extends JsonSerializable {
  DateTime? get currentScheduleDateTime;
  int get currentAlarmRunnerId;
  bool get isDisabled;
  bool get isFinished;

  AlarmSchedule();

  List<AlarmRunner> get alarmRunners;
  Future<bool> schedule(TimeOfDay timeOfDay);
  void cancel();
  bool hasId(int id);
}
