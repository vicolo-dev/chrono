import 'package:clock_app/common/widgets/linear_progress_bar.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:flutter/material.dart';

class LapComparer extends StatelessWidget {
  const LapComparer({
    super.key,
    required ClockStopwatch stopwatch,
    required this.comparisonLap,
    required this.label,
    this.showLapNumber = true,
    this.color = Colors.green,
  }) : _stopwatch = stopwatch;

  final Lap? comparisonLap;
  final ClockStopwatch _stopwatch;
  final String label;
  final Color color;
  final bool showLapNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinearProgressBar(
          minHeight: 16,
          value: _stopwatch.currentLapTime.inMilliseconds /
              (comparisonLap?.lapTime.inMilliseconds ?? double.infinity),
          backgroundColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0),
          child: Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
              const Spacer(),
              Text(
                  comparisonLap != null
                      ? '${showLapNumber ? "Lap ${comparisonLap?.number}: " : ""}${comparisonLap?.lapTime.toTimeString(showMilliseconds: true)}'
                      : '',
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
