import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_of_day_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    super.key,
    required this.onEnabledChange,
    required this.alarm,
  });

  final Alarm alarm;
  final void Function(bool) onEnabledChange;

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    TimeOfDayIcon timeOfDayIcon = getTimeOfDayIcon(widget.alarm.timeOfDay);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.alarm.label.isNotEmpty)
                Row(
                  children: [
                    Text(widget.alarm.label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: widget.alarm.enabled
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.8)
                                  : Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                            )),
                  ],
                ),
              Row(
                children: [
                  ClockDisplay(
                      dateTime: widget.alarm.timeOfDay.toDateTime(),
                      scale: 0.6,
                      color: widget.alarm.enabled
                          ? null
                          : Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6)),
                ],
              ),
              Row(
                children: [
                  Icon(
                    timeOfDayIcon.icon,
                    color: widget.alarm.enabled
                        ? timeOfDayIcon.color
                        : Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getAlarmScheduleDescription(widget.alarm),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.alarm.enabled
                              ? Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.8)
                              : Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                        ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              // const SizedBox(width: 8),
              Switch(
                value: widget.alarm.enabled,
                onChanged: widget.onEnabledChange,
              ),
            ],
          )
        ],
      ),
    );
  }
}
