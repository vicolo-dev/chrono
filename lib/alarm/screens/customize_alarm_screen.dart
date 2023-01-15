import 'package:awesome_select/awesome_select.dart';
import 'package:clock_app/alarm/data/schedule_types.dart';
import 'package:clock_app/alarm/logic/alarm_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/schedule_type.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/alarm/widgets/weekday_select.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/select.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:just_audio/just_audio.dart';

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

  @override
  void initState() {
    super.initState();
    _alarm = Alarm.fromAlarm(widget.initialAlarm);
  }

  void _handleSetWeekday(Weekday weekday) {
    setState(() {
      if (_alarm.getWeekdays().contains(weekday)) {
        _alarm.removeWeekday(weekday.id);
      } else {
        _alarm.addWeekday(weekday.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title:
        //     Text('Add Alarm', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, _alarm);
              },
              child: const Text("Save"))
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      TimePickerResult? timePickerResult =
                          await showTimePickerDialog(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        helpText: "Select Time",
                        cancelText: "Cancel",
                        confirmText: "Save",
                      );

                      if (timePickerResult != null) {
                        setState(() {
                          _alarm.setTimeOfDay(timePickerResult.timeOfDay);
                        });
                      }
                    },
                  ),
                  Text(
                    getAlarmDescriptionText(_alarm),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: ColorTheme.textColorTertiary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Select(
                initialSelectedIndex: _alarm.scheduleType,
                title: "Schedule Type",
                choices: scheduleTypes
                    .map((scheduleType) => SelectChoice(
                          title: scheduleType.name,
                          description: scheduleType.description,
                        ))
                    .toList(),
                onChange: (value) {
                  setState(() => _alarm.setScheduleType(value));
                },
              ),
            ),
            if (scheduleTypes[_alarm.scheduleType].name == "On Specified Days")
              Card(
                child: WeekdaySelect(
                  selectedWeekdays: _alarm.getWeekdays(),
                  onSetWeekday: _handleSetWeekday,
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Sound and Vibration",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: ColorTheme.textColorSecondary,
                                ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: ColorTheme.textColorTertiary,
                          )
                        ],
                      ),
                    ),
                    Select(
                      initialSelectedIndex: _alarm.scheduleType,
                      title: "Melody",
                      choices: AlarmAudioPlayer.ringtones
                          .map((ringtone) => SelectChoice(
                                title: ringtone.title,
                                // description: ringtone.description,
                              ))
                          .toList(),
                      onSelect: (index) =>
                          AlarmAudioPlayer.play(index, loopMode: LoopMode.off),
                      onChange: (value) {
                        AlarmAudioPlayer.stop();
                        setState(() => _alarm.setRingtone(value));
                      },
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text("Vibration",
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        Switch(
                          value: _alarm.vibrate,
                          onChanged: (value) =>
                              setState(() => _alarm.setVibrate(value)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
