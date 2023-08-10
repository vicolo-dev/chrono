import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/common/widgets/customize_screen.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

class CustomizeAlarmScreen extends StatefulWidget {
  const CustomizeAlarmScreen({
    super.key,
    required this.alarm,
  });

  final Alarm alarm;

  @override
  State<CustomizeAlarmScreen> createState() => _CustomizeAlarmScreenState();
}

class _CustomizeAlarmScreenState extends State<CustomizeAlarmScreen> {
  int lastPlayedRingtoneIndex = -1;

  late Setting taskSettings;
  late SettingGroup scheduleSettings;

  void update(value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    scheduleSettings = widget.alarm.settings.getGroup("Schedule");
    scheduleSettings.addListener(update);
  }

  @override
  void dispose() {
    scheduleSettings.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomizeScreen(
      item: widget.alarm,
      builder: (context, alarm) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: ClockDisplay(
                          dateTime: alarm.time.toDateTime(),
                          horizontalAlignment: ElementAlignment.center,
                        ),
                        onTap: () async {
                          PickerResult<TimeOfDay>? timePickerResult =
                              await showTimePickerDialog(
                            context: context,
                            initialTime: alarm.time.toTimeOfDay(),
                            title: "Select Time",
                            cancelText: "Cancel",
                            confirmText: "Save",
                          );

                          if (timePickerResult == null) return;

                          setState(() {
                            alarm.setTimeFromTimeOfDay(timePickerResult.value);
                          });
                        },
                      ),
                      AlarmDescription(alarm: alarm),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...getSettingWidgets(
                  alarm.settings.settingItems,
                  checkDependentEnableConditions: () {
                    setState(() {});
                  },
                  isAppSettings: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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

  late Setting dateFormatSetting;

  void setDateFormat(dynamic newDateFormat) {
    setState(() {
      dateFormat = newDateFormat;
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

    dateFormatSetting.addListener(setDateFormat);
    setDateFormat(dateFormatSetting.value);
  }

  @override
  void dispose() {
    dateFormatSetting.removeListener(setDateFormat);
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
            getAlarmScheduleDescription(widget.alarm, dateFormat),
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
