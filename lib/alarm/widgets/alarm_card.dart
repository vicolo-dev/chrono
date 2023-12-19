import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    super.key,
    required this.onEnabledChange,
    required this.alarm,
    required this.onPressDelete,
    required this.onPressDuplicate,
  });

  final Alarm alarm;
  final void Function(bool) onEnabledChange;
  final VoidCallback onPressDelete;
  final VoidCallback onPressDuplicate;

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  late String dateFormat;
  late TimeFormat timeFormat;

  late Setting dateFormatSetting;
  late Setting timeFormatSetting;

  void setDateFormat(dynamic newDateFormat) {
    setState(() {
      dateFormat = newDateFormat;
    });
  }

  void setTimeFormat(dynamic newTimeFormat) {
    setState(() {
      timeFormat = newTimeFormat;
    });
  }

  void update(value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dateFormatSetting = appSettings
        .getGroup("General")
        .getGroup("Display")
        .getSetting("Date Format");

    timeFormatSetting = appSettings
        .getGroup("General")
        .getGroup("Display")
        .getSetting("Time Format");

    dateFormatSetting.addListener(setDateFormat);
    timeFormatSetting.addListener(setTimeFormat);
    setDateFormat(dateFormatSetting.value);
    setTimeFormat(timeFormatSetting.value);
  }

  @override
  void dispose() {
    dateFormatSetting.removeListener(setDateFormat);
    timeFormatSetting.removeListener(setTimeFormat);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimeIcon timeOfDayIcon = getTimeIcon(widget.alarm.time);

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    // return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.alarm.label.isNotEmpty)
                    Text(
                      widget.alarm.label,
                      style: textTheme.bodyLarge?.copyWith(
                        color: widget.alarm.isEnabled
                            ? colorScheme.onBackground.withOpacity(0.8)
                            : colorScheme.onBackground.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  Row(
                    children: [
                      ClockDisplay(
                          dateTime: widget.alarm.time.toDateTime(),
                          scale: 0.6,
                          color: widget.alarm.isEnabled
                              ? null
                              : colorScheme.onBackground.withOpacity(0.6)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        timeOfDayIcon.icon,
                        color: widget.alarm.isEnabled
                            ? timeOfDayIcon.color
                            : colorScheme.onBackground.withOpacity(0.6),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          getAlarmScheduleDescription(
                              context, widget.alarm, dateFormat, timeFormat),
                          maxLines: 2,
                          style: textTheme.bodyMedium?.copyWith(
                            color: widget.alarm.isEnabled
                                ? colorScheme.onBackground.withOpacity(0.8)
                                : colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(width: 8),
                widget.alarm.isFinished
                    ? IconButton(
                        onPressed: widget.onPressDelete,
                        icon: Icon(
                          Icons.delete_rounded,
                          color: colorScheme.error,
                          size: 32,
                        ),
                      )
                    : Switch(
                        value: widget.alarm.isEnabled,
                        onChanged: widget.onEnabledChange,
                      ),
                CardEditMenu(
                  onPressDelete:
                      widget.alarm.isDeletable ? widget.onPressDelete : null,
                  onPressDuplicate: widget.onPressDuplicate,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
