import 'package:clock_app/timer/types/time_duration.dart';

class Lap {
  final int lapNumber;
  final TimeDuration lapTime;
  final TimeDuration elapsedTime;

  Lap(
      {required this.elapsedTime,
      required this.lapNumber,
      required this.lapTime});
}
