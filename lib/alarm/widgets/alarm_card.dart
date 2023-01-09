import 'package:clock_app/alarm/types/alarm.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({Key? key, required this.alarm}) : super(key: key);

  final Alarm alarm;

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  final _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.alarm.time.format(context),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
