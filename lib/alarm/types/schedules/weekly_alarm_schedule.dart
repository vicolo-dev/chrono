import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/foundation.dart';

class WeekdaySchedule extends JsonSerializable {
  int weekday = 0;
  late AlarmRunner alarmRunner;

  WeekdaySchedule(this.weekday) : alarmRunner = AlarmRunner();

  WeekdaySchedule.fromJson(Json json) {
    if (json == null) {
      alarmRunner = AlarmRunner();
      return;
    }
    weekday = json['weekday'];
    alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);
  }

  @override
  Json toJson() => {
        'weekday': weekday,
        'alarmRunner': alarmRunner.toJson(),
      };
}

class WeeklyAlarmSchedule extends AlarmSchedule {
  // This is just a dummy alarmRunner so we get a consistent currentAlarmRunnerId;
  late final AlarmRunner _alarmRunner;

  late List<WeekdaySchedule> _weekdaySchedules = [];
  late final ToggleSetting<int> _weekdaySetting;

  @override
  bool get isDisabled => false;

  @override
  bool get isFinished => false;

  List<Weekday> get scheduledWeekdays {
    return _weekdaySetting.selected
        .map((weekdayId) =>
            weekdays.firstWhere((weekday) => weekday.id == weekdayId))
        .toList();
  }

  WeekdaySchedule get nextWeekdaySchedule {
    if (_weekdaySchedules.isEmpty) return WeekdaySchedule(0);
    if (_weekdaySchedules.every(
        (element) => element.alarmRunner.currentScheduleDateTime == null)) {
      return WeekdaySchedule(0);
    }
    return _weekdaySchedules.reduce((a, b) {
      if (a.alarmRunner.currentScheduleDateTime == null) return b;
      if (b.alarmRunner.currentScheduleDateTime == null) return a;

      if (a.alarmRunner.currentScheduleDateTime!
          .isBefore(b.alarmRunner.currentScheduleDateTime!)) {
        return a;
      } else {
        return b;
      }
    });
  }

  @override
  DateTime? get currentScheduleDateTime =>
      nextWeekdaySchedule.alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => _alarmRunner.id;

  int get currentWeekdayAlarmRunnerId => nextWeekdaySchedule.alarmRunner.id;

  WeeklyAlarmSchedule(Setting weekdaySetting)
      : _weekdaySetting = weekdaySetting as ToggleSetting<int>,
        _alarmRunner = AlarmRunner(),
        super();

  @override
  Future<void> schedule(Time time,String description, [bool alarmClock = false]) async {
    // for (WeekdaySchedule weekdaySchedule in _weekdaySchedules) {
    //   await weekdaySchedule.alarmRunner.cancel();
    // }

    // We schedule the next occurence for each weekday. 
    // Subsequent occurences will be scheduled after the first one passes.

    List<int> weekdays = _weekdaySetting.selected.toList();
    List<int> existingWeekdays =
        _weekdaySchedules.map((schedule) => schedule.weekday).toList();

    if (!listEquals(weekdays, existingWeekdays)) {
      _weekdaySchedules =
          weekdays.map((weekday) => WeekdaySchedule(weekday)).toList();
    }

    for (WeekdaySchedule weekdaySchedule in _weekdaySchedules) {
      DateTime alarmDate = getWeeklyScheduleDateForTIme(time, weekdaySchedule.weekday);
      await weekdaySchedule.alarmRunner.schedule(alarmDate,description, alarmClock);
    }
  }

  @override
  Future<void> cancel() async {
    for (WeekdaySchedule weekday in _weekdaySchedules) {
      await weekday.alarmRunner.cancel();
    }
  }

  @override
  toJson() {
    return {
      'alarmRunner': _alarmRunner.toJson(),
      'weekdaySchedules': _weekdaySchedules.map((e) => e.toJson()).toList(),
    };
  }

  WeeklyAlarmSchedule.fromJson(Json json, Setting weekdaySetting) {
    _weekdaySetting = weekdaySetting as ToggleSetting<int>;
    if (json == null) {
      _alarmRunner = AlarmRunner();
      return;
    }
    _weekdaySchedules = ((json['weekdaySchedules'] ?? []) as List)
        .map((e) => WeekdaySchedule.fromJson(e))
        .toList();
    _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);
  }

  @override
  bool hasId(int id) {
    return _weekdaySchedules
        .any((weekdaySchedule) => weekdaySchedule.alarmRunner.id == id);
  }

  @override
  List<AlarmRunner> get alarmRunners =>
      _weekdaySchedules.map((e) => e.alarmRunner).toList();
}
