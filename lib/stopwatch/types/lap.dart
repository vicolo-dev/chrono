import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/timer/types/time_duration.dart';

class Lap extends ListItem {
  late int number;
  late TimeDuration lapTime;
  late TimeDuration elapsedTime;

  @override
  int get id => number;
  @override
  bool get isDeletable => false;

  Lap({required this.elapsedTime, required this.number, required this.lapTime});

  Lap.fromJson(Json? json) {
    if (json == null) {
      number = 0;
      lapTime = TimeDuration.zero;
      elapsedTime = TimeDuration.zero;
      return;
    }
    number = json['number'] ?? 0;
    lapTime = TimeDuration.fromJson(json['lapTime']);
    elapsedTime = TimeDuration.fromJson(json['elapsedTime']);
  }

  @override
  Json toJson() => {
        'number': number,
        'lapTime': lapTime.toJson(),
        'elapsedTime': elapsedTime.toJson(),
      };

  @override
  copy() {
    return Lap(elapsedTime: elapsedTime, number: number, lapTime: lapTime);
  }

  @override
  void copyFrom(other) {
    number = other.number;
    lapTime = TimeDuration.from(other.lapTime);
    elapsedTime = TimeDuration.from(other.elapsedTime);
  }
}
