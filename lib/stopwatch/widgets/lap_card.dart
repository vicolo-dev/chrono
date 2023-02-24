import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:flutter/material.dart';

class LapCard extends StatelessWidget {
  const LapCard({super.key, required this.lap});

  final Lap lap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('${lap.lapNumber}'),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lap.lapTime.toTimeString(showMilliseconds: true),
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                  'Elapsed Time: ${lap.elapsedTime.toTimeString(showMilliseconds: true)}'),
            ],
          ),
        ],
      ),
    ));
  }
}
