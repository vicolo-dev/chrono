import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LapCard extends StatelessWidget {
  const LapCard({super.key, required this.lap});

  final Lap lap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('${lap.number}'),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lap.lapTime.toTimeString(showMilliseconds: true),
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                  '${AppLocalizations.of(context)!.elapsedTime}: ${lap.elapsedTime.toTimeString(showMilliseconds: true)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class ActiveLapCard extends StatefulWidget {
  const ActiveLapCard({
    super.key,
    required this.stopwatch,
  });

  final ClockStopwatch stopwatch;

  @override
  State<ActiveLapCard> createState() => _ActiveLapCardState();
}

class _ActiveLapCardState extends State<ActiveLapCard> {
  late Ticker ticker;

  void tick(Duration elapsed) {
    setState(() {});
  }

  @override
  void initState() {
    ticker = Ticker(tick);
    ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('${widget.stopwatch.laps.length}'),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.stopwatch.currentLapTime
                      .toTimeString(showMilliseconds: true),
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                  '${AppLocalizations.of(context)!.elapsedTime}: ${widget.stopwatch.elapsedTime.toTimeString(showMilliseconds: true)}'),
            ],
          ),
        ],
      ),
    );
  }
}
