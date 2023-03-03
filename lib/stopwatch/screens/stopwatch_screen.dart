import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:timer_builder/timer_builder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final _listController = ListController<Lap>();

  late final ClockStopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = loadListSync<ClockStopwatch>('stopwatches').first;
  }

  void _handleReset() {
    setState(() {
      _stopwatch.pause();
      _stopwatch.reset();
    });
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleAddLap() {
    if (_stopwatch.currentLapTime.inMilliseconds == 0) return;
    _listController.addItem(_stopwatch.getLap());
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleToggleState() {
    setState(() {
      _stopwatch.toggleState();
    });
    saveList('stopwatches', [_stopwatch]);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimerBuilder.periodic(const Duration(milliseconds: 30),
                builder: (context) {
              // print(_stopwatch.fastestLap?.lapTime.toTimeString());
              // print(_stopwatch.slowestLap?.lapTime.toTimeString());
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TimeDuration.fromMilliseconds(
                                _stopwatch.elapsedMilliseconds)
                            .toTimeString(showMilliseconds: true),
                        style: const TextStyle(fontSize: 48.0),
                      ),
                      LinearProgressIndicator(
                        minHeight: 4,
                        value: _stopwatch.currentLapTime.inMilliseconds /
                            (_stopwatch.previousLap?.lapTime.inMilliseconds ??
                                double.infinity),
                        backgroundColor: Colors.black.withOpacity(0.15),
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        minHeight: 4,
                        value: _stopwatch.currentLapTime.inMilliseconds /
                            (_stopwatch.slowestLap?.lapTime.inMilliseconds ??
                                double.infinity),
                        color: Colors.orange,
                        backgroundColor: Colors.black.withOpacity(0.15),
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        minHeight: 4,
                        value: _stopwatch.currentLapTime.inMilliseconds /
                            (_stopwatch.fastestLap?.lapTime.inMilliseconds ??
                                double.infinity),
                        color: Colors.red,
                        backgroundColor: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Expanded(
              child: CustomListView<Lap>(
                items: _stopwatch.laps,
                listController: _listController,
                itemBuilder: (lap) => LapCard(
                  key: ValueKey(lap),
                  lap: lap,
                ),
                placeholderText: "No laps yet",
                isDeleteEnabled: false,
                isDuplicateEnabled: false,
                isReorderable: false,
                onAddItem: (lap) => _stopwatch.updateFastestAndSlowestLap(),
              ),
            ),
          ],
        ),
        FAB(
          onPressed: _handleToggleState,
          icon: _stopwatch.isRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
        if (_stopwatch.isStarted)
          FAB(
            index: 1,
            onPressed: _handleAddLap,
            icon: Icons.flag_rounded,
          ),
        if (_stopwatch.isStarted)
          FAB(
            index: 2,
            onPressed: _handleReset,
            icon: Icons.refresh_rounded,
          ),
      ],
    );
  }
}
