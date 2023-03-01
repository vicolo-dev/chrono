class RingingManager {
  static int _ringingAlarmId = -1;
  static final List<int> _ringingTimerIds = [];

  static int get ringingAlarmId => _ringingAlarmId;
  static List<int> get ringingTimerIds => _ringingTimerIds;
  static int get activeTimerId =>
      _ringingTimerIds.isNotEmpty ? _ringingTimerIds.last : -1;

  static bool get isAlarmRinging => _ringingAlarmId != -1;
  static bool get isTimerRinging => _ringingTimerIds.isNotEmpty;

  static void ringAlarm(int alarmId) {
    _ringingAlarmId = alarmId;
  }

  static void stopAlarm() {
    _ringingAlarmId = -1;
  }

  static void ringTimer(int timerId) {
    _ringingTimerIds.add(timerId);
  }

  static void stopTimer(int timerId) {
    _ringingTimerIds.remove(timerId);
  }

  static void stopAllTimers() {
    _ringingTimerIds.clear();
  }
}
