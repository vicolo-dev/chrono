import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/utils/alarm_utils.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard(
      {Key? key,
      required this.alarm,
      required this.onDelete,
      required this.onEnabledChange})
      : super(key: key);

  final Alarm alarm;
  final VoidCallback onDelete;
  final void Function(bool) onEnabledChange;

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
        child: Slidable(
            groupTag: 'alarms',
            key: widget.key,
            startActionPane: getDeleteActionPane(widget.onDelete, context),
            endActionPane: getDeleteActionPane(widget.onDelete, context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClockDisplay(
                      dateTime: timeOfDayToDateTime(widget.alarm.timeOfDay),
                      scale: 0.6),
                  const Spacer(),
                  Switch(
                    value: widget.alarm.enabled,
                    onChanged: widget.onEnabledChange,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
