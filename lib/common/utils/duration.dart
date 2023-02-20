import 'package:clock_app/timer/types/time_duration.dart';

extension DurationUtils on Duration {
  TimeDuration toTimeDuration() => TimeDuration(
        hours: inHours,
        minutes: inMinutes % 60,
        seconds: inSeconds % 60,
      );
}
