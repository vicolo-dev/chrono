import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class RangeAlarmSchedule extends AlarmSchedule {
  late final AlarmRunner _alarmRunner;
  final DateTimeSetting _datesRangeSetting;
  final SelectSetting<Duration> _intervalSetting;
  bool _isFinished = false;

  Duration get interval => _intervalSetting.value;
  DateTime get startDate => _datesRangeSetting.value.first;
  DateTime get endDate => _datesRangeSetting.value.last;

  @override
  bool get isDisabled => false;

  @override
  bool get isFinished => _isFinished;

  @override
  DateTime? get currentScheduleDateTime => _alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => _alarmRunner.id;

  RangeAlarmSchedule(Setting datesRangeSetting, Setting intervalSetting)
      : _datesRangeSetting = datesRangeSetting as DateTimeSetting,
        _intervalSetting = intervalSetting as SelectSetting<Duration>,
        _alarmRunner = AlarmRunner(),
        super() {
    if (_datesRangeSetting.value.isEmpty) {
      _datesRangeSetting.rangeOnly
          ? _datesRangeSetting.setValueWithoutNotify(
              [DateTime.now(), DateTime.now().add(const Duration(days: 2))])
          : _datesRangeSetting.setValueWithoutNotify([DateTime.now()]);
    }
  }

  @override
  void schedule(TimeOfDay timeOfDay) {
    // Da
    DateTime alarmDate = getDailyAlarmDate(timeOfDay, scheduledDate: startDate);
    if (alarmDate.day <= endDate.day) {
      _alarmRunner.schedule(alarmDate);
    } else {
      _isFinished = true;
    }
  }

  @override
  void cancel() {
    _alarmRunner.cancel();
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
      };

  RangeAlarmSchedule.fromJson(Map<String, dynamic> json,
      Setting datesRangeSetting, Setting intervalSetting)
      : _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']),
        _datesRangeSetting = datesRangeSetting as DateTimeSetting,
        _intervalSetting = intervalSetting as SelectSetting<Duration>,
        super();

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
