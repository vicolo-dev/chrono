import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/utils/alarm_utils.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Weekday {
  final int id;
  final String abbreviation;
  final String displayName;

  const Weekday(this.id, this.abbreviation, this.displayName);
}

const List<Weekday> weekdays = [
  Weekday(1, 'M', 'Mon'),
  Weekday(2, 'T', 'Tue'),
  Weekday(3, 'W', 'Wed'),
  Weekday(4, 'T', 'Thu'),
  Weekday(5, 'F', 'Fri'),
  Weekday(6, 'S', 'Sat'),
  Weekday(7, 'S', 'Sun'),
];

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
  String getDescriptionText(List<Weekday> alarmWeekdays) {
    if (widget.alarm.enabled == false) {
      return 'Disabled';
    }
    if (alarmWeekdays.isEmpty) {
      return 'Just ${timeOfDayToHours(widget.alarm.timeOfDay) > timeOfDayToHours(TimeOfDay.now()) ? 'today' : 'tomorrow'}';
    } else {
      return 'Every ${alarmWeekdays.map((weekday) => weekday.displayName).join(', ')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Weekday> alarmWeekdays = widget.alarm
        .getWeekdays()
        .map((id) => weekdays.firstWhere((weekday) => weekday.id == id))
        .toList();

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
                          dateTime: timeOfDayToDateTime(widget.alarm.timeOfDay),
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
                        getDescriptionText(alarmWeekdays),
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
