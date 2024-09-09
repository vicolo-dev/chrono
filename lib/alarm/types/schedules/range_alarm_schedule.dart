import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/range_interval.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/settings/types/setting.dart';

class RangeAlarmSchedule extends AlarmSchedule {
  late final AlarmRunner _alarmRunner;
  late final DateTimeSetting _datesRangeSetting;
  late final SelectSetting<RangeInterval> _intervalSetting;
  bool _isFinished = false;

  RangeInterval get interval => _intervalSetting.value;
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
        _intervalSetting = intervalSetting as SelectSetting<RangeInterval>,
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
  Future<void> schedule(Time time, String description, [bool alarmClock = false]) async {
    int intervalDays = interval == RangeInterval.daily ? 1 : 7;
    // All the dates are not scheduled at once
    // Instead we schedule the next date after the current one is finished
    DateTime alarmDate = getDailyAlarmDate(time,
        scheduleStartDate: startDate, interval: intervalDays);
    if (alarmDate.isAfter(endDate)) {
      _isFinished = true;
    } else {
      await _alarmRunner.schedule(alarmDate, description, alarmClock);
      _isFinished = false;
    }
  }

  @override
  Future<void> cancel() async {
    await _alarmRunner.cancel();
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
      };

  RangeAlarmSchedule.fromJson(
      Json json, Setting datesRangeSetting, Setting intervalSetting) {
    _datesRangeSetting = datesRangeSetting as DateTimeSetting;
    _intervalSetting = intervalSetting as SelectSetting<RangeInterval>;
    if (json == null) {
      _alarmRunner = AlarmRunner();
      return;
    }
    _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);
  }

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
