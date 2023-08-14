import 'dart:async';

import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:clock_app/common/widgets/circular_progress_bar.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/material.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({
    Key? key,
    required this.timer,
    required this.onToggleState,
    required this.onPressDelete,
    required this.onPressDuplicate,
  }) : super(key: key);

  final ClockTimer timer;
  final VoidCallback onToggleState;
  final VoidCallback onPressDelete;
  final VoidCallback onPressDuplicate;

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late ValueNotifier<double> valueNotifier;
  late ClockTimer _previousTimer;

  late int remainingSeconds;

  Timer? periodicTimer;

  void updateTimer() {
    setState(() {
      periodicTimer?.cancel();
      if (widget.timer.isRunning) {
        periodicTimer =
            Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          valueNotifier.value = widget.timer.remainingSeconds.toDouble();
        });
      }
      valueNotifier.value = widget.timer.remainingSeconds.toDouble();
      // remainingSeconds = widget.timer.remainingSeconds;
    });
  }

  // update value notifier every second
  @override
  void initState() {
    super.initState();
    // if (GetStorage().read('first_timer_created') == false) {
    //   GetStorage().write('first_timer_created', true);
    //   showEditTip(context, () => mounted);
    // }
    valueNotifier = ValueNotifier(widget.timer.remainingSeconds.toDouble());
    remainingSeconds = widget.timer.remainingSeconds;
    valueNotifier.addListener(() {
      setState(() {
        remainingSeconds = valueNotifier.value.toInt();
      });
    });
    updateTimer();
    _previousTimer = ClockTimer.from(widget.timer);
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_previousTimer.equals(widget.timer)) {
      updateTimer();
      _previousTimer = ClockTimer.from(widget.timer);
    }

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressBar(
              size: 64,
              valueNotifier: valueNotifier,
              progressStrokeWidth: 8,
              backStrokeWidth: 8,
              maxValue: widget.timer.currentDuration.inSeconds.toDouble(),
              mergeMode: true,
              animationDuration: 0,
              onGetCenterWidget: (value) {
                return GestureDetector(
                  onTap: () {
                    widget.onToggleState();
                    updateTimer();
                  },
                  child: widget.timer.isRunning
                      ? Icon(
                          Icons.pause_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        )
                      : Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                          size: 32,
                        ),
                );
              },
              progressColors: [Theme.of(context).colorScheme.primary],
              backColor: Colors.black.withOpacity(0.15),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.timer.label,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                      ),
                ),
                Text(
                  TimeDuration.fromSeconds(remainingSeconds).toTimeString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: remainingSeconds > 3600 ? 40 : 48,
                      ),
                ),
              ],
            ),
            const Spacer(),
            CardEditMenu(
              onPressDelete: widget.onPressDelete,
              onPressDuplicate: widget.onPressDuplicate,
            ),
          ],
        ));
  }
}
