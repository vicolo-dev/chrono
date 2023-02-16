import 'package:clock_app/alarm/logic/alarm_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    Key? key,
    required this.alarm,
    required this.onDelete,
    required this.onEnabledChange,
    required this.onTap,
    required this.onDuplicate,
  }) : super(key: key);

  final Alarm alarm;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onTap;
  final void Function(bool) onEnabledChange;

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          child: Slidable(
              groupTag: 'alarms',
              key: widget.key,
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                // extentRatio: Platform == 0.25,
                children: [
                  CustomSlidableAction(
                    onPressed: (context) => widget.onDuplicate(),
                    backgroundColor: ColorTheme.accentColor,
                    foregroundColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete),
                        Text('Duplicate',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: widget.alarm.enabled
                                        ? ColorTheme.textColorSecondary
                                        : ColorTheme.textColorTertiary,
                                  ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
