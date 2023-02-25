import 'dart:async';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/common/widgets/circular_progress_bar.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({
    Key? key,
    required this.timer,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTap,
    required this.onToggleState,
  }) : super(key: key);

  final ClockTimer timer;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onTap;
  final VoidCallback onToggleState;

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
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
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          child: Slidable(
              groupTag: 'timers',
              key: widget.key,
              startActionPane:
                  getDuplicateActionPane(widget.onDuplicate, context),
              endActionPane: getDeleteActionPane(widget.onDelete, context),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.timer.duration.toString()} timer',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: ColorTheme.textColorTertiary,
                                ),
                          ),
                          Text(
                            TimeDuration.fromSeconds(remainingSeconds)
                                .toTimeString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 48,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircularProgressBar(
                        size: 64,
                        valueNotifier: valueNotifier,
                        progressStrokeWidth: 8,
                        backStrokeWidth: 8,
                        maxValue: widget.timer.duration.inSeconds.toDouble(),
                        mergeMode: true,
                        animationDuration: 0,
                        onGetCenterWidget: (value) {
                          return GestureDetector(
                            onTap: () {
                              widget.onToggleState();
                              updateTimer();
                            },
                            child: widget.timer.isRunning
                                ? const Icon(
                                    Icons.pause_rounded,
                                    color: ColorTheme.accentColor,
                                    size: 32,
                                  )
                                : const Icon(
                                    Icons.play_arrow_rounded,
                                    color: ColorTheme.textColorSecondary,
                                    size: 32,
                                  ),
                          );
                        },
                        progressColors: const [Colors.cyan],
                        backColor: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
