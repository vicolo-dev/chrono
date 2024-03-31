import 'dart:async';

import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/circular_progress_bar.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';
import 'package:flutter/material.dart';

class TimerFullscreen extends StatefulWidget {
  const TimerFullscreen({
    super.key,
    required this.timer,
    required this.onToggleState,
    required this.onReset,
    required this.onAddTime,
    required this.onCustomize,
  });

  final ClockTimer timer;
  final Future<void> Function(ClockTimer) onToggleState;
  final Future<void> Function(ClockTimer) onReset;
  final Future<void> Function(ClockTimer) onAddTime;
  final Future<ClockTimer?> Function(ClockTimer) onCustomize;

  @override
  State<TimerFullscreen> createState() => _TimerFullscreenState();
}

class _TimerFullscreenState extends State<TimerFullscreen> {
  late ValueNotifier<double> valueNotifier;
  late ClockTimer timer;
  late int remainingSeconds;
  double maxValue = 0;

  Timer? periodicTimer;

  void updateTimer() {
    setState(() {
      periodicTimer?.cancel();
      if (timer.isRunning) {
        periodicTimer =
            Timer.periodic(const Duration(seconds: 1), (Timer periodicTimer) {
          valueNotifier.value = timer.remainingSeconds.toDouble();
        });
      }
      valueNotifier.value = timer.remainingSeconds.toDouble();
      maxValue = timer.currentDuration.inSeconds.toDouble();
      remainingSeconds = timer.remainingSeconds;
    });
  }

  void onTimerUpdated() {
    timer = getTimerById(timer.id);
    updateTimer();
  }

  // update value notifier every second
  @override
  void initState() {
    super.initState();
    timer = widget.timer;
    valueNotifier = ValueNotifier(timer.remainingSeconds.toDouble());
    remainingSeconds = timer.remainingSeconds;
    valueNotifier.addListener(() {
      setState(() {
        remainingSeconds = valueNotifier.value.toInt();
      });
    });
    updateTimer();
    ListenerManager.addOnChangeListener("timers", onTimerUpdated);
  }

  @override
  void dispose() {
    ListenerManager.removeOnChangeListener("timers", onTimerUpdated);
    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
            onPressed: () async {
              ClockTimer? newTimer = await widget.onCustomize(timer);
              if (newTimer != null) {
                setState(() {
                  timer = newTimer;
                  updateTimer();
                });
              }
            },
            child: const Text("Edit"))
      ]),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                timer.label,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressBar(
              size: 256,
              valueNotifier: valueNotifier,
              progressStrokeWidth: 8,
              backStrokeWidth: 8,
              maxValue: maxValue,
              mergeMode: true,
              // animationDuration: 0,
              onGetCenterWidget: (value) {
                return Text(
                  TimeDuration.fromSeconds(remainingSeconds).toTimeString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: remainingSeconds > 3600 ? 48 : 64,
                      ),
                );
              },
              progressColors: [Theme.of(context).colorScheme.primary],
              backColor: Colors.black.withOpacity(0.15),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (timer.state != TimerState.stopped)
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: CardContainer(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.replay_rounded,

                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                              // size: 64,
                            )),
                        onTap: () async {
                          await widget.onReset(timer);
                          updateTimer();
                        },
                      ),
                    ),
                  Expanded(
                  flex:999,
                    child: CardContainer(
                    alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: timer.isRunning
                            ? Icon(
                                Icons.pause_rounded,
                    
                                color: Theme.of(context).colorScheme.primary,
                                size: 96,
                                // size: 64,
                              )
                            : Icon(
                                Icons.play_arrow_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 96,
                    
                                // size: 64,
                              ),
                      ),
                      onTap: ()async {
                        await widget.onToggleState(timer);
                        updateTimer();
                      },
                    ),
                  ),
                  if (timer.state != TimerState.stopped)
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: CardContainer(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('+${timer.addLength.floor()}:00',
                                style:
                                    Theme.of(context).textTheme.displaySmall)),
                        onTap: () async {
                          await widget.onAddTime(timer);
                          updateTimer();
                        },
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
