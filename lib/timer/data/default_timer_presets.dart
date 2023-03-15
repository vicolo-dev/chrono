import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/timer_duration_picker.dart';

List<TimerPreset> defaultTimerPresets = [
  TimerPreset("1 min", const TimeDuration(minutes: 1)),
  TimerPreset("5 min", const TimeDuration(minutes: 5)),
  TimerPreset("Workout", const TimeDuration(minutes: 10)),
  TimerPreset("Meditation", const TimeDuration(minutes: 15)),
  TimerPreset("10 min", const TimeDuration(minutes: 10)),
  TimerPreset("Sleep", const TimeDuration(hours: 5)),
];
