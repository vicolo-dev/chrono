import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';

class OnceAlarmSchedule extends AlarmSchedule {
  late final AlarmRunner _alarmRunner;
  bool _isDisabled = false;

  @override
  DateTime? get currentScheduleDateTime => _alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => _alarmRunner.id;

  @override
  bool get isDisabled => _isDisabled;

  @override
  bool get isFinished => false;

  OnceAlarmSchedule()
      : _alarmRunner = AlarmRunner(),
        super();

  @override
  Future<bool> schedule(Time time) async {
    // If the alarm has already been scheduled in the past, disable it.
    if (currentScheduleDateTime?.isBefore(DateTime.now()) ?? false) {
      _isDisabled = true;
      return false;
    }
    DateTime alarmDate = getDailyAlarmDate(time);
    return _alarmRunner.schedule(alarmDate);
  }

  @override
  void cancel() {
    _alarmRunner.cancel();
  }

  @override
  toJson() => {
        'alarmRunner': _alarmRunner.toJson(),
        'isDisabled': _isDisabled,
      };

  OnceAlarmSchedule.fromJson(Json json)
      : _alarmRunner = AlarmRunner.fromJson(json['alarmRunner']),
        _isDisabled = json['isDisabled'],
        super();

  @override
  bool hasId(int id) {
    return _alarmRunner.id == id;
  }

  @override
  List<AlarmRunner> get alarmRunners => [_alarmRunner];
}
