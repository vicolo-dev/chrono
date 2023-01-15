import 'package:awesome_select/awesome_select.dart';
import 'package:clock_app/alarm/data/schedule_types.dart';
import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/logic/alarm_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedule_type.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/alarm/widgets/weekday_select.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class CustomizeAlarmScreen extends StatefulWidget {
  const CustomizeAlarmScreen({
    super.key,
    required this.initialAlarm,
  });

  final Alarm initialAlarm;

  @override
  _CustomizeAlarmScreenState createState() => _CustomizeAlarmScreenState();
}

class _CustomizeAlarmScreenState extends State<CustomizeAlarmScreen> {
  late Alarm _alarm;

  @override
  void initState() {
    super.initState();
    _alarm = widget.initialAlarm;
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

  int selectedScheduleType = 0;

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
              child: Text("Save"))
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            GestureDetector(
              child: ClockDisplay(dateTime: _alarm.timeOfDay.toDateTime()),
              onTap: () async {
                TimePickerResult? timePickerResult = await showTimePickerDialog(
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
            Row(
              children: [
                Text(
                  getAlarmDescriptionText(_alarm),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorTheme.textColorTertiary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SmartSelect.single(
              selectedValue: selectedScheduleType,
              title: "Schedule Type",
              choiceItems: S2Choice.listFrom<int, ScheduleType>(
                source: scheduleTypes,
                value: (index, item) => index,
                title: (index, item) => item.name,
                subtitle: (index, item) => item.description,
              ),
              onChange: (value) =>
                  setState(() => selectedScheduleType = value.value),
              modalType: S2ModalType.bottomSheet,
              // choiceStyle: S2ChoiceStyle(
              //   titleStyle: Theme.of(context).textTheme.,
              // ),
              modalHeaderStyle: S2ModalHeaderStyle(
                // backgroundColor: ColorTheme.backgroundColor,
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              tileBuilder: (context, state) {
                return S2Tile.fromState(
                  state,
                  padding: const EdgeInsets.all(0),
                  isTwoLine: true,
                );
              },
            ),
            if (scheduleTypes[selectedScheduleType].name == "On Specified Days")
              WeekdaySelect(
                selectedWeekdays: _alarm.getWeekdays(),
                onSetWeekday: _handleSetWeekday,
              )
          ],
        ),
      ),
    );
  }
}
