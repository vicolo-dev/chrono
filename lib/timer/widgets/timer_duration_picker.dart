import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
import 'package:flutter/material.dart';

class TimerDurationPicker extends StatefulWidget {
  const TimerDurationPicker({Key? key, required this.timer}) : super(key: key);

  final ClockTimer timer;

  @override
  State<TimerDurationPicker> createState() => _TimerDurationPickerState();
}

class _TimerDurationPickerState extends State<TimerDurationPicker> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () async {
        TimeDuration? newTimeDuration = await showDurationPicker(
          context,
          initialTimeDuration: widget.timer.duration,
        );
        if (newTimeDuration == null) return;
        setState(() {
          widget.timer.setDuration(newTimeDuration);
        });
      },
      child: Text(widget.timer.duration.toString(),
          style: textTheme.displayLarge?.copyWith(
              fontSize: widget.timer.remainingSeconds > 3600 ? 48 : 56)),
    );
  }
}
