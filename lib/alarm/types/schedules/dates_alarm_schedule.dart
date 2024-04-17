import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/settings/types/setting.dart';

class DateSchedule extends JsonSerializable {
  late DateTime date;
  late AlarmRunner alarmRunner;

  DateSchedule(this.date) : alarmRunner = AlarmRunner();

  DateSchedule.fromJson(Json json) {
    if (json == null) {
      date = DateTime.now();
      return;
    }
    date = json['date'] != null ? DateTime.parse(json['date']) : DateTime.now();
    alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);
  }

  @override
  Json toJson() => {
        'date': date.toIso8601String(),
        'alarmRunner': alarmRunner.toJson(),
      };
}

class DatesAlarmSchedule extends AlarmSchedule {
  //  List<WeekdaySchedule> _weekdaySchedules = [];
  late final DateTimeSetting _datesSetting;
  late final AlarmRunner _alarmRunner;
  late bool _isFinished;

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
  Future<void> schedule(Time time, String description) async {
    List<DateTime> dates = _datesSetting.value;

    for (int i = 0; i < dates.length; i++) {
      DateTime date = DateTime(
        dates[i].year,
        dates[i].month,
        dates[i].day,
        time.hour,
        time.minute,
        time.second,
      );
      // Only schedule if the date is in the future
      // We also schedule just the next upcoming date
      // When that schedule is finished, we will schedule the next one and so on
      if (date.isAfter(DateTime.now())) {
        await _alarmRunner.schedule(date, description);
        return;
      }
    }

    // There are no more dates to schedule, so finish the schedule
    _isFinished = true;
  }

  @override
  Future<void> cancel() async {
    await _alarmRunner.cancel();
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
        'isFinished': _isFinished,
      };

  DatesAlarmSchedule.fromJson(Json json, Setting datesSetting) : super() {
    _datesSetting = datesSetting as DateTimeSetting;
    if (json == null) {
      _alarmRunner = AlarmRunner();
      _isFinished = false;
      return;
    }
    _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);
    _isFinished = json['isFinished'] ?? false;
  }

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
