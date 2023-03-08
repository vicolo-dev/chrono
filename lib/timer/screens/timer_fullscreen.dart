import 'dart:async';

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/circular_progress_bar.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/material.dart';

class TimerFullscreen extends StatefulWidget {
  const TimerFullscreen(
      {super.key, required this.timer, required this.onToggleState});

  final ClockTimer timer;
  final VoidCallback onToggleState;

  @override
  State<TimerFullscreen> createState() => _TimerFullscreenState();
}

class _TimerFullscreenState extends State<TimerFullscreen> {
  late ValueNotifier<double> valueNotifier;

  late int remainingSeconds;

  Timer? timer;

  void updateTimer() {
    setState(() {
      timer?.cancel();
      if (widget.timer.isRunning) {
        timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          valueNotifier.value = widget.timer.remainingSeconds.toDouble();
        });
      }
    });
  }

  // update value notifier every second
  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(widget.timer.remainingSeconds.toDouble());
    remainingSeconds = widget.timer.remainingSeconds;
    valueNotifier.addListener(() {
      setState(() {
        remainingSeconds = valueNotifier.value.toInt();
      });
    });
    updateTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.timer.duration.toString()} timer',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 16),
            CircularProgressBar(
              size: 256,
              valueNotifier: valueNotifier,
              progressStrokeWidth: 8,
              backStrokeWidth: 8,
              maxValue: widget.timer.duration.inSeconds.toDouble(),
              mergeMode: true,
              animationDuration: 0,
              onGetCenterWidget: (value) {
                return Text(
                  TimeDuration.fromSeconds(remainingSeconds).toTimeString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 64,
                      ),
                );
              },
              progressColors: [Theme.of(context).colorScheme.primary],
              backColor: Colors.black.withOpacity(0.15),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.timer.isRunning
                        ? Icon(
                            Icons.pause_rounded,

                            color: Theme.of(context).colorScheme.primary,
                            size: 64,
                            // size: 64,
                          )
                        : Icon(
                            Icons.play_arrow_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 64,

                            // size: 64,
                          ),
                  ),
                  onTap: () {
                    widget.onToggleState();
                    updateTimer();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
