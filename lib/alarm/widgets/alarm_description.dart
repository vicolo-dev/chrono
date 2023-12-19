import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class AlarmDescription extends StatefulWidget {
  const AlarmDescription({
    super.key,
    required this.alarm,
  });

  final Alarm alarm;

  @override
  State<AlarmDescription> createState() => _AlarmDescriptionState();
}

class _AlarmDescriptionState extends State<AlarmDescription> {
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    TimeIcon timeOfDayIcon = getTimeIcon(widget.alarm.time);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          timeOfDayIcon.icon,
          color: timeOfDayIcon.color,
          size: 28,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            getAlarmScheduleDescription(
                context, widget.alarm, dateFormat, timeFormat),
            maxLines: 2,
            style: textTheme.displaySmall?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}
