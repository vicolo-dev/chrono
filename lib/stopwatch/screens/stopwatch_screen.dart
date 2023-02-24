import 'dart:async';

import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
  List<Lap> _laps = [];

  void toggleStart() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(children: [
          TimerBuilder.periodic(const Duration(milliseconds: 30),
              builder: (context) {
            return Text(
                TimeDuration.fromMilliseconds(_stopwatch.elapsedMilliseconds)
                    .toTimeString(showMilliseconds: true),
                style: TextStyle(fontSize: 48.0));
          }),
          SizedBox(height: 32),
          List.from(_laps.reversed).isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: _laps.length,
                      itemBuilder: (context, index) {
                        return LapCard(lap: _laps[_laps.length - index - 1]);
                      }),
                )
              : Container(),
        ]),
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
            onPressed: () {
              int elapsedMilliseconds = _stopwatch.elapsedMilliseconds;
              _laps.add(Lap(
                  elapsedTime:
                      TimeDuration.fromMilliseconds(elapsedMilliseconds),
                  lapNumber: _laps.length + 1,
                  lapTime: TimeDuration.fromMilliseconds(elapsedMilliseconds -
                      (_laps.isNotEmpty
                          ? _laps.last.elapsedTime.inMilliseconds
                          : 0))));
              setState(() {});
            },
            icon: Icons.flag_rounded,
          ),
        if (_stopwatch.elapsedMilliseconds > 0)
          FAB(
            index: 2,
            onPressed: () {
              _stopwatch.stop();
              _stopwatch.reset();
              setState(() {});
              _laps.clear();
            },
            icon: Icons.refresh_rounded,
          ),
      ],
    );
  }
}
