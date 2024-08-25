import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/common/utils/id.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/logger.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/timer/types/time_duration.dart';

// All time units are in milliseconds
class ClockStopwatch extends JsonSerializable {
  int _elapsedMillisecondsOnPause = 0;
  DateTime _startTime = DateTime(0);
  TimerState _state = TimerState.stopped;
  late final int _id;
  List<Lap> _laps = [];
  Lap? _fastestLap;
  Lap? _slowestLap;

  int get id => _id;
  List<Lap> get laps => _laps;
  List<Lap> get finishedLaps => _laps.where((lap) => !lap.isActive).toList();
  int get elapsedMilliseconds => _state == TimerState.running
      ? DateTime.now().difference(_startTime).toTimeDuration().inMilliseconds
      : _elapsedMillisecondsOnPause;
  TimeDuration get elapsedTime =>
      TimeDuration.fromMilliseconds(elapsedMilliseconds);
  bool get isRunning => _state == TimerState.running;
  bool get isStopped => _state == TimerState.stopped;
  bool get isStarted =>
      _state == TimerState.running || _state == TimerState.paused;
  TimerState get state => _state;
  TimeDuration get currentLapTime =>
      TimeDuration.fromMilliseconds(elapsedMilliseconds - lastLapElapsedTime);
  int get lastLapElapsedTime {
    if (finishedLaps.isEmpty) return 0;
    return finishedLaps.first.elapsedTime.inMilliseconds;
  }

  Lap? get previousLap => finishedLaps.isNotEmpty ? finishedLaps.first : null;
  Lap? get fastestLap => _fastestLap;
  Lap? get slowestLap => _slowestLap;
  Lap? get averageLap {
    if (finishedLaps.isEmpty) return null;
    var totalMilliseconds = finishedLaps.fold(
        0, (previousValue, lap) => previousValue + lap.lapTime.inMilliseconds);
    return Lap(
      elapsedTime: TimeDuration.fromMilliseconds(
          totalMilliseconds ~/ finishedLaps.length),
      number: _laps.length + 1,
      lapTime: TimeDuration.fromMilliseconds(
          totalMilliseconds ~/ finishedLaps.length),
    );
  }

  ClockStopwatch()
      : _id = getId(),
        _elapsedMillisecondsOnPause = 0,
        _startTime = DateTime(0),
        _state = TimerState.stopped;

  ClockStopwatch.fromStopwatch()
      : _elapsedMillisecondsOnPause = 0,
        _startTime = DateTime(0),
        _state = TimerState.stopped,
        _id = getId();

  copyFrom(ClockStopwatch stopwatch) {
    _elapsedMillisecondsOnPause = stopwatch._elapsedMillisecondsOnPause;
    _startTime = stopwatch._startTime;
    _state = stopwatch._state;
    _laps = stopwatch._laps;
    _fastestLap = stopwatch._fastestLap;
    _slowestLap = stopwatch._slowestLap;
  }

  void start() {
    if (_state == TimerState.stopped) {
      _startTime = DateTime.now();
    } else if (_state == TimerState.paused) {
      _startTime = DateTime.now()
          .subtract(Duration(milliseconds: _elapsedMillisecondsOnPause));
    }
    _state = TimerState.running;
  }

  void pause() {
    _elapsedMillisecondsOnPause =
        DateTime.now().difference(_startTime).toTimeDuration().inMilliseconds;
    _state = TimerState.paused;
  }

  void reset() {
    _state = TimerState.stopped;
    _elapsedMillisecondsOnPause = 0;
    _laps = [];
    _fastestLap = null;
    _slowestLap = null;
  }

  void toggleState() {
    if (state == TimerState.running) {
      pause();
    } else {
      start();
    }
  }

  void updateFastestAndSlowestLap() {
    if (finishedLaps.isEmpty) return;
    _fastestLap = finishedLaps.reduce((value, element) =>
        value.lapTime.inMilliseconds < element.lapTime.inMilliseconds
            ? value
            : element);
    _slowestLap = finishedLaps.reduce((value, element) =>
        value.lapTime.inMilliseconds > element.lapTime.inMilliseconds
            ? value
            : element);
  }

  void addLap() {
    logInfo("${laps}");
    if (_laps.isNotEmpty) {
      if (currentLapTime.inMilliseconds == 0) return;
      finishLap(_laps.first);
      updateFastestAndSlowestLap();
    }
    _laps.insert(0, getLap());
  }

  void finishLap(Lap lap) {
    // This needs to be set before elapsedTime and isActive
    lap.lapTime = currentLapTime;
    lap.elapsedTime = TimeDuration.fromMilliseconds(elapsedMilliseconds);
    lap.isActive = false;
  }

  //
  Lap getLap() {
    return Lap(number: finishedLaps.length + 1, isActive: true);
  }

  @override
  Json toJson() {
    return {
      'id': _id,
      'elapsedMillisecondsOnPause': _elapsedMillisecondsOnPause,
      'startTime': _startTime.toIso8601String(),
      'state': _state.toString(),
      'laps': listToString(_laps),
    };
  }

  ClockStopwatch.fromJson(Json json) {
    if (json == null) {
      _id = getId();
      return;
    }
    _elapsedMillisecondsOnPause = json['elapsedMillisecondsOnPause'] ?? 0;
    _startTime = json['startTime'] != null
        ? DateTime.parse(json['startTime'])
        : DateTime.now();
    _state = TimerState.values.firstWhere(
        (e) => e.toString() == (json['state'] ?? ''),
        orElse: () => TimerState.stopped);
    _id = json['id'] ?? getId();
    // _finishedLaps = [];
    _laps = listFromString(json['laps'] ?? '[]');
    updateFastestAndSlowestLap();
  }
}
