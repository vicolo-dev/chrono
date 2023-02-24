import 'package:clock_app/timer/types/time_duration.dart';

class Lap {
  final int number;
  final TimeDuration lapTime;
  final TimeDuration elapsedTime;

  Lap({required this.elapsedTime, required this.number, required this.lapTime});
}
