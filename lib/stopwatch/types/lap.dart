import 'package:clock_app/timer/types/time_duration.dart';

class Lap {
  final int number;
  final TimeDuration lapTime;
  final TimeDuration elapsedTime;

  Lap({required this.elapsedTime, required this.number, required this.lapTime});

  Lap.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        lapTime = TimeDuration.fromJson(json['lapTime']),
        elapsedTime = TimeDuration.fromJson(json['elapsedTime']);

  Map<String, dynamic> toJson() => {
        'number': number,
        'lapTime': lapTime.toJson(),
        'elapsedTime': elapsedTime.toJson(),
      };
}
