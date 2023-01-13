import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/logic/alarm_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:clock_app/theme/color.dart';
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
              child: Column(
                children: [
                  Row(
                    children: [
                      ClockDisplay(
                          dateTime: widget.alarm.timeOfDay.toDateTime(),
                          scale: 0.6,
                          color: widget.alarm.enabled
                              ? null
                              : ColorTheme.textColorTertiary),
                      const Spacer(),
                      Switch(
                        value: widget.alarm.enabled,
                        onChanged: widget.onEnabledChange,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        getAlarmDescriptionText(widget.alarm),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.alarm.enabled
                                  ? null
                                  : ColorTheme.textColorTertiary,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
