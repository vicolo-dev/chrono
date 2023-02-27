import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/widgets/custom_list_view.dart';
import 'package:clock_app/common/widgets/persistent_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:great_list_view/great_list_view.dart';
import 'package:timer_builder/timer_builder.dart';

import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list_item_measurer.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';

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
    _stopwatch = loadList<ClockStopwatch>('stopwatches').first;
  }

  void _handleReset() {
    setState(() {
      _stopwatch.pause();
      _stopwatch.reset();
    });
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleAddLap() {
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    TimeDuration.fromMilliseconds(
                            _stopwatch.elapsedMilliseconds)
                        .toTimeString(showMilliseconds: true),
                    style: const TextStyle(fontSize: 48.0)),
              );
            }),
            const SizedBox(height: 16),
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
