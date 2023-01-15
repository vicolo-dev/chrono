import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/theme/border.dart';
import 'package:flutter/material.dart';

class WeekdaySelect extends StatelessWidget {
  const WeekdaySelect(
      {Key? key, required this.selectedWeekdays, required this.onSetWeekday})
      : super(key: key);

  final List<Weekday> selectedWeekdays;
  final void Function(Weekday) onSetWeekday;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: defaultBorderRadius,
      constraints: BoxConstraints(
        minHeight: (MediaQuery.of(context).size.width - 40) / 7,
        minWidth: (MediaQuery.of(context).size.width - 40) / 7,
      ),
      isSelected: [
        for (final weekday in weekdays) selectedWeekdays.contains(weekday),
      ],
      onPressed: (index) => onSetWeekday(weekdays[index]),
      children: [
        for (final weekday in weekdays) Text(weekday.abbreviation),
      ],
    );
  }
}
