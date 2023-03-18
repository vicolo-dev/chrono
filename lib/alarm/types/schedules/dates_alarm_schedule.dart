import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class DateSchedule extends JsonSerializable {
  DateTime date;
  AlarmRunner alarmRunner;

  DateSchedule(this.date) : alarmRunner = AlarmRunner();

  DateSchedule.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);

  @override
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'alarmRunner': alarmRunner.toJson(),
      };
}

class DatesAlarmSchedule extends AlarmSchedule {
  //  List<WeekdaySchedule> _weekdaySchedules = [];
  final DateTimeSetting _datesSetting;
  final AlarmRunner _alarmRunner;
  bool _isFinished;

  @override
  bool get isDisabled => false;

  @override
  bool get isFinished => _isFinished;

  @override
  DateTime? get currentScheduleDateTime => _alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => _alarmRunner.id;

  DatesAlarmSchedule(Setting datesSetting)
      : _datesSetting = datesSetting as DateTimeSetting,
        _alarmRunner = AlarmRunner(),
        _isFinished = false,
        super() {
    if (_datesSetting.value.isEmpty) {
      _datesSetting.setValueWithoutNotify([DateTime.now()]);
    }
  }

  @override
  void cancel() {
    _alarmRunner.cancel();
  }

  @override
  void schedule(TimeOfDay timeOfDay) {
    List<DateTime> dates = _datesSetting.value;

    for (int i = 0; i < dates.length; i++) {
      DateTime date = DateTime(dates[i].year, dates[i].month, dates[i].day,
          timeOfDay.hour, timeOfDay.minute);
      if (date.isAfter(DateTime.now())) {
        _alarmRunner.schedule(date);
        return;
      }
    }

    _isFinished = true;
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
        'isFinished': _isFinished,
      };

  DatesAlarmSchedule.fromJson(Map<String, dynamic> json, Setting datesSetting)
      : _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']),
        _datesSetting = datesSetting as DateTimeSetting,
        _isFinished = json['isFinished'],
        super();

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
