import 'dart:async';

import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
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
  Stopwatch _stopwatch = Stopwatch();
  List<Lap> _laps = [];

  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  void toggleStart() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }

  void _handleReset() {
    List<Lap> lapsCopy = List<Lap>.from(_laps);
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _laps = [];
    });
    _controller.notifyChangedRange(
      0,
      _laps.length,
      (context, index, data) => data.measuring
          ? const SizedBox(height: 64)
          : LapCard(
              key: ValueKey(lapsCopy[index]),
              lap: lapsCopy[index],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleAddLap() {
    int elapsedMilliseconds = _stopwatch.elapsedMilliseconds;

    setState(() {
      _laps.add(Lap(
          elapsedTime: TimeDuration.fromMilliseconds(elapsedMilliseconds),
          number: _laps.length + 1,
          lapTime: TimeDuration.fromMilliseconds(elapsedMilliseconds -
              (_laps.isNotEmpty ? _laps.last.elapsedTime.inMilliseconds : 0))));
    });
    _controller.notifyInsertedRange(_laps.length - 1, 1);
  }

  void _scrollToBottom(Lap lap) {
    if (lap.number != _laps.length) return;
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
                list: _laps,
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
                footer: const SizedBox(height: 64),
              ),
            ),
          ],
        ),
        FAB(
          onPressed: () {
            toggleStart();
            setState(() {});
          },
          icon: _stopwatch.isRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
        if (_stopwatch.elapsedMilliseconds > 0)
          FAB(
            index: 1,
            onPressed: _handleAddLap,
            icon: Icons.flag_rounded,
          ),
        if (_stopwatch.elapsedMilliseconds > 0)
          FAB(
            index: 2,
            onPressed: _handleReset,
            icon: Icons.refresh_rounded,
          ),
      ],
    );
  }
}
