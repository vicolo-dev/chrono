import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/logic/time_of_day_icon.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/time_of_day_icon.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class CustomizeAlarmScreen extends StatefulWidget {
  const CustomizeAlarmScreen({
    super.key,
    required this.initialAlarm,
  });

  final Alarm initialAlarm;

  @override
  State<CustomizeAlarmScreen> createState() => _CustomizeAlarmScreenState();
}

class _CustomizeAlarmScreenState extends State<CustomizeAlarmScreen> {
  late Alarm _alarm;
  int lastPlayedRingtoneIndex = -1;
  late String dateFormat;

  late Setting dateFormatSetting;
  late Setting weekDaysSetting;
  late Setting datesSetting;
  late Setting dateRangeSetting;
  late Setting intervalSetting;

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
    _alarm = Alarm.fromAlarm(widget.initialAlarm);

    dateFormatSetting = appSettings
        .getGroup("General")
        .getGroup("Display")
        .getSetting("Date Format");

    appSettings.addSettingListener(dateFormatSetting, setDateFormat);
    setDateFormat(dateFormatSetting.value);

    SettingGroup scheduleSettings = _alarm.settings.getGroup("Schedule");

    weekDaysSetting = scheduleSettings.getSetting("Week Days");
    datesSetting = scheduleSettings.getSetting("Dates");
    dateRangeSetting = scheduleSettings.getSetting("Date Range");
    intervalSetting = scheduleSettings.getSetting("Interval");

    _alarm.settings.addSettingListener(weekDaysSetting, update);
    _alarm.settings.addSettingListener(datesSetting, update);
    _alarm.settings.addSettingListener(dateRangeSetting, update);
    _alarm.settings.addSettingListener(intervalSetting, update);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener(dateFormatSetting, setDateFormat);
    _alarm.settings.removeSettingListener(weekDaysSetting, update);
    _alarm.settings.removeSettingListener(datesSetting, update);
    _alarm.settings.removeSettingListener(dateRangeSetting, update);
    _alarm.settings.removeSettingListener(intervalSetting, update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDayIcon timeOfDayIcon = getTimeOfDayIcon(_alarm.timeOfDay);

    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, _alarm);
            },
            child: const Text("Save"))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    GestureDetector(
                      child: ClockDisplay(
                        dateTime: _alarm.timeOfDay.toDateTime(),
                        horizontalAlignment: ElementAlignment.center,
                      ),
                      onTap: () async {
                        PickerResult<TimeOfDay>? timePickerResult =
                            await showTimePickerDialog(
                          context: context,
                          initialTime: _alarm.timeOfDay,
                          title: "Select Time",
                          cancelText: "Cancel",
                          confirmText: "Save",
                        );

                        if (timePickerResult != null) {
                          setState(() {
                            _alarm.setTimeOfDay(timePickerResult.value);
                          });
                        }
                      },
                    ),
                    Row(
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
                            getAlarmScheduleDescription(_alarm, dateFormat),
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...getSettingWidgets(
                _alarm.settings,
                checkDependentEnableConditions: () {
                  setState(() {});
                },
                isAppSettings: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
