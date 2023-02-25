import 'dart:async';

import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:timer_builder/timer_builder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late final ClockStopwatch _stopwatch;

  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  @override
  void initState() {
    super.initState();
    _stopwatch = loadList<ClockStopwatch>('stopwatches').first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleReset() {
    List<Lap> lapsCopy = List<Lap>.from(_stopwatch.laps);
    setState(() {
      _stopwatch.pause();
      _stopwatch.reset();
    });
    _controller.notifyChangedRange(
      0,
      _stopwatch.laps.length,
      (context, index, data) => data.measuring
          ? const SizedBox(height: 64)
          : LapCard(
              key: ValueKey(lapsCopy[index]),
              lap: lapsCopy[index],
            ),
    );
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleAddLap() {
    setState(() {
      _stopwatch.addLap();
    });
    _controller.notifyInsertedRange(_stopwatch.laps.length - 1, 1);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
      // executes after build
    });
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleToggleState() {
    _stopwatch.toggleState();
    setState(() {});
    saveList('stopwatches', [_stopwatch]);
  }

  void _scrollToBottom(Lap lap) {
    if (lap.number != _stopwatch.laps.length) return;
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 250), curve: Curves.easeIn);
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
                    style: TextStyle(fontSize: 48.0)),
              );
            }),
            SizedBox(height: 16),
            Expanded(
              child: AutomaticAnimatedListView<Lap>(
                list: _stopwatch.laps,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                comparator: AnimatedListDiffListComparator<Lap>(
                  sameItem: (a, b) => a.number == b.number,
                  sameContent: (a, b) => a.number == b.number,
                ),
                itemBuilder: (BuildContext context, lap, data) {
                  return data.measuring
                      ? const SizedBox(height: 64)
                      : LapCard(
                          key: ValueKey(lap),
                          lap: lap,
                          onInit: () => _scrollToBottom(lap),
                        );
                },
                initialScrollOffsetCallback: (c) {
                  return 0;
                },
                listController: _controller,
                scrollController: _scrollController,
                footer: const SizedBox(height: 136),
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
