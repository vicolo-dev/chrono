import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/logic/alarm_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock_display.dart';
import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({
    super.key,
    required this.initialTimeOfDay,
  });

  final TimeOfDay initialTimeOfDay;

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late TimeOfDay _timeOfDay;
  late Alarm _alarm;

  @override
  void initState() {
    super.initState();
    _timeOfDay = widget.initialTimeOfDay;
    _alarm = Alarm(_timeOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add Alarm', style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          ClockDisplay(dateTime: _timeOfDay.toDateTime()),
          Text(
            getAlarmDescriptionText(_alarm),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _alarm.enabled ? null : ColorTheme.textColorTertiary,
                ),
          ),
          ToggleButtons(
            borderRadius: defaultBorderRadius,
            constraints: BoxConstraints(
              minHeight: (MediaQuery.of(context).size.width - 64) / 7,
              minWidth: (MediaQuery.of(context).size.width - 64) / 7,
            ),
            isSelected: [
              for (final weekday in weekdays)
                _alarm.getWeekdays().contains(weekday),
            ],
            onPressed: (index) {
              final weekday = weekdays[index];
              setState(() {
                if (_alarm.getWeekdays().contains(weekday)) {
                  _alarm.removeWeekday(weekday.id);
                } else {
                  _alarm.addWeekday(weekday.id);
                }
              });
            },
            children: [
              for (final weekday in weekdays) Text(weekday.abbreviation),
            ],
          )
        ]),
      ),
    );
  }
}
