import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';

class DailyAlarmSchedule extends AlarmSchedule {
  late final AlarmRunner _alarmRunner;

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
  Future<bool> schedule(Time time) async {
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
      };

  DailyAlarmSchedule.fromJson(Json json) {
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
