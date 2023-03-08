import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_of_day_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    super.key,
    required this.onEnabledChange,
    required this.alarm,
    required this.onPressDelete,
  });

  final Alarm alarm;
  final void Function(bool) onEnabledChange;
  final VoidCallback onPressDelete;

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  late String dateFormat;

  void setDateFormat(dynamic newDateFormat) {
    setState(() {
      dateFormat = newDateFormat;
    });
  }

  @override
  void initState() {
    super.initState();
    appSettings.addSettingListener("Date Format", setDateFormat);
    setDateFormat(appSettings.getSetting("Date Format").value);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener("Date Format", setDateFormat);
    super.dispose();
  }

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
                              color: widget.alarm.isEnabled
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
                      color: widget.alarm.isEnabled
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
                    color: widget.alarm.isEnabled
                        ? timeOfDayIcon.color
                        : Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getAlarmScheduleDescription(widget.alarm, dateFormat),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.alarm.isEnabled
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
              widget.alarm.isFinished
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: widget.onPressDelete,
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 32,
                        ),
                      ),
                    )
                  : Switch(
                      value: widget.alarm.isEnabled,
                      onChanged: widget.onEnabledChange,
                    ),
            ],
          )
        ],
      ),
    );
  }
}
