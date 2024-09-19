import 'dart:async';

import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';
import 'package:clock_app/timer/widgets/timer_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late ClockTimer timer;

  void updateTimer() {
    // ticker.stop();
    setState(() {});
  }

  void onTimerUpdated() {
    timer = getTimerById(timer.id) ?? ClockTimer(const TimeDuration());
    updateTimer();
  }

  // update value notifier every second
  @override
  void initState() {
    super.initState();
    timer = widget.timer;
    ListenerManager.addOnChangeListener("timers", onTimerUpdated);
  }

  @override
  void dispose() {
    ListenerManager.removeOnChangeListener("timers", onTimerUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    // Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppTopBar(
          titleWidget: Text(timer.label,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.6),
              )),
          actions: [
            TextButton(
                onPressed: () async {
                  ClockTimer? newTimer = await widget.onCustomize(timer);
                  if (newTimer != null) {
                    setState(() {
                      timer.copyFrom(newTimer);
                      updateTimer();
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.editButton))
          ]),
      body: OrientationBuilder(builder: (context, orientation) {
        double buttonSize = orientation == Orientation.portrait ? 32 : 32;
        double largeButtonSize = orientation == Orientation.portrait ? 96 : 72;
        double width = MediaQuery.of(context).size.width - 64;
        double height = MediaQuery.of(context).size.height - 136;

        return SizedBox(
          width: orientation == Orientation.portrait ? double.infinity : null,
          height: orientation == Orientation.landscape ? double.infinity : null,
          child: Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32, width: 32),
              TimerProgressBar(
                  timer: timer,
                  textScale: orientation == Orientation.portrait ? 1 : 0.75,
                  size: orientation == Orientation.portrait ? width : height),
              const SizedBox(height: 32, width: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Flex(
                    direction: orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      if (timer.state != TimerState.stopped)
                        Expanded(
                          flex: 1,
                          child: Flex(
                            direction: orientation == Orientation.portrait
                                ? Axis.horizontal
                                : Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 2,
                                child: CardContainer(
                                  onTap: () async {
                                    await widget.onReset(timer);
                                    updateTimer();
                                  },
                                  alignment: Alignment.center,
                                  child: SizedBox.expand(
                                    child: Flex(
                                      direction:
                                          orientation == Orientation.portrait
                                              ? Axis.vertical
                                              : Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Icon(
                                                Icons.replay_rounded,
                                                color: colorScheme.primary,
                                                size: buttonSize,
                                                // size: 64,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CardContainer(
                                  onTap: () async {
                                    await widget.onAddTime(timer);
                                    updateTimer();
                                  },
                                  alignment: Alignment.center,
                                  child: SizedBox.expand(
                                    child: Flex(
                                      direction:
                                          orientation == Orientation.portrait
                                              ? Axis.vertical
                                              : Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                  '+${timer.addLength.floor()}:00',
                                                  style: orientation ==
                                                          Orientation.portrait
                                                      ? textTheme.displaySmall
                                                      : textTheme.titleSmall),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// CardContainer(
                              //   alignment: Alignment.center,
                              //   onTap: () async {
                              //     await widget.onAddTime(timer);
                              //     updateTimer();
                              //   },
                              //   child: Column(
                              //     children: [
                              //       Expanded(
                              //         child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              // child: ),
                              // ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: CardContainer(
                          alignment: Alignment.center,
                          child: SizedBox.expand(
                            child: Flex(
                              direction: orientation == Orientation.portrait
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: timer.isRunning
                                        ? Icon(
                                            Icons.pause_rounded,
                                            color: colorScheme.primary,
                                            size: largeButtonSize,
                                            // size: 64,
                                          )
                                        : Icon(
                                            Icons.play_arrow_rounded,
                                            color: colorScheme.primary,
                                            size: largeButtonSize,
                                            // size: 64,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            await widget.onToggleState(timer);
                            updateTimer();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
