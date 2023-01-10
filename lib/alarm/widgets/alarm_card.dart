import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({Key? key, required this.alarm, required this.onDelete})
      : super(key: key);

  final Alarm alarm;
  final VoidCallback onDelete;

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  final _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        child: Slidable(
            groupTag: 'alarms',
            key: widget.key,
            startActionPane: getDeleteActionPane(widget.onDelete, context),
            endActionPane: getDeleteActionPane(widget.onDelete, context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    widget.alarm.time.format(context),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isOn,
                    onChanged: (value) => setState(() {
                      _isOn = value;
                    }),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
