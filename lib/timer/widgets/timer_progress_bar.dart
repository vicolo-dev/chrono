import 'package:clock_app/common/widgets/circular_progress_bar.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TimerProgressBar extends StatefulWidget {
  const TimerProgressBar({super.key, required this.timer, required this.size, this.centerWidget, this.textScale = 1.0});

  final ClockTimer timer;
  final double size;
  final double textScale;
  final Widget? centerWidget;

  @override
  State<TimerProgressBar> createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> {

    late Ticker ticker;
  late ValueNotifier<double> valueNotifier;
    late int remainingSeconds;
      double maxValue = 0;



  @override
  void initState() {
    super.initState();
    ticker = Ticker((elapsed) {
      valueNotifier.value = widget.timer.remainingMilliseconds.toDouble();
      maxValue = widget.timer.currentDuration.inMilliseconds.toDouble();
    });
    ticker.start();
    valueNotifier = ValueNotifier(widget.timer.remainingMilliseconds.toDouble());
    maxValue = widget.timer.currentDuration.inMilliseconds.toDouble();
    remainingSeconds = widget.timer.remainingSeconds;
    valueNotifier.addListener(() {
      setState(() {
        remainingSeconds = (valueNotifier.value / 1000).round();
      });
    });
  }

    @override
  void dispose() {
    ticker.stop();
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  CircularProgressBar(
              size: widget.size,
              valueNotifier: valueNotifier,
              progressStrokeWidth: 8,
              backStrokeWidth: 8,
              maxValue: maxValue,
              mergeMode: true,
              // animationDuration: 0,
              onGetCenterWidget: (value) {
                if(widget.centerWidget != null) return widget.centerWidget!;
                return Text(
                  TimeDuration.fromSeconds(remainingSeconds).toTimeString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: (remainingSeconds > 3600 ? 48 : 64) * widget.textScale,
                      ),
                );
              },
              progressColors: [Theme.of(context).colorScheme.primary],
              backColor: Colors.black.withOpacity(0.15),
            );
  }
}
