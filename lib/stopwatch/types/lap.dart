import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/timer/types/time_duration.dart';

class Lap extends ListItem {
  late int _number;
  late TimeDuration _lapTime;
  late TimeDuration _elapsedTime;
  late bool _isActive;

  int get number => _number;
  bool get isActive => _isActive;
  set isActive(bool value) => _isActive = value;
  set lapTime(TimeDuration value) => _lapTime = value;
  set elapsedTime(TimeDuration value) => _elapsedTime = value;
  TimeDuration get lapTime => _lapTime;
  TimeDuration get elapsedTime => _elapsedTime;
  @override
  int get id => number;
  @override
  bool get isDeletable => false;

  Lap(
      {required int number,
      TimeDuration elapsedTime = const TimeDuration(),
      TimeDuration lapTime = const TimeDuration(),
      bool isActive = false})
      : _lapTime = lapTime,
        _number = number,
        _elapsedTime = elapsedTime,
        _isActive = isActive;

  Lap.fromJson(Json? json) {
    if (json == null) {
      _number = 0;
      _lapTime = TimeDuration.zero;
      _elapsedTime = TimeDuration.zero;
      _isActive = false;
      return;
    }
    _number = json['number'] ?? 0;
    _lapTime = TimeDuration.fromJson(json['lapTime']);
    _elapsedTime = TimeDuration.fromJson(json['elapsedTime']);
    _isActive = json['isActive'] ?? false;
  }

  @override
  Json toJson() => {
        'number': number,
        'lapTime': lapTime.toJson(),
        'elapsedTime': elapsedTime.toJson(),
        'isActive': _isActive,
      };

  @override
  copy() {
    return Lap(
        elapsedTime: elapsedTime,
        number: number,
        lapTime: lapTime,
        isActive: _isActive);
  }

  @override
  void copyFrom(other) {
    _number = other.number;
    _lapTime = TimeDuration.from(other.lapTime);
    _elapsedTime = TimeDuration.from(other.elapsedTime);
    _isActive = other._isActive;
  }
}
