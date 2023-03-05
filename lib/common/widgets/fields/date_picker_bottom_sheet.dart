import 'package:clock_app/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({
    super.key,
    required this.title,
    required this.onChange,
    required this.initialDates,
  });

  final String title;
  final List<DateTime> initialDates;
  final void Function(List<DateTime>) onChange;

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  List<DateTime> _selectedDates = [];
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDates = List.from(widget.initialDates);
    _focusedDate = widget.initialDates.first;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    ThemeStyle? themeStyle = theme.extension<ThemeStyle>();
    TextStyle? dateTextStyle = theme.textTheme.labelSmall;

    Widget Function(BuildContext, DateTime, DateTime) _dateLabelBuilder(
            Color color) =>
        (context, date, focusedDay) => Center(
              child: Text(
                date.day.toString(),
                style: dateTextStyle?.copyWith(
                  color: color,
                ),
              ),
            );

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius:
              (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius,
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                const SizedBox(height: 12.0),
                SizedBox(
                  height: 4.0,
                  width: 48,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(64),
                        color: colorScheme.onBackground.withOpacity(0.6)),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 4.0),
                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDate,
                        selectedDayPredicate: (date) {
                          return _selectedDates.any(
                              (selectedDate) => isSameDay(selectedDate, date));
                        },
                        onDaySelected: (newSelectedDate, focusedDate) {
                          setState(() {
                            _focusedDate = newSelectedDate;

                            int dateIndex = _selectedDates.indexWhere(
                                (date) => isSameDay(date, newSelectedDate));
                            if (dateIndex != -1) {
                              // If the selected day already exists, remove it from the list
                              _selectedDates.removeAt(dateIndex);
                            } else {
                              // Add the selected day at the right position based on chronological order
                              int index = 0;
                              for (DateTime date in _selectedDates) {
                                if (newSelectedDate.isAfter(date)) {
                                  index++;
                                } else {
                                  break;
                                }
                              }
                              _selectedDates.insert(index, newSelectedDate);
                            }
                          });
                          if (_selectedDates.isNotEmpty) {
                            widget.onChange(_selectedDates);
                          }
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        rowHeight: 48,
                        headerStyle: HeaderStyle(
                          // headerMargin: EdgeInsets.symmetric(vertical: 8.0),
                          titleCentered: true,
                          titleTextStyle: theme.textTheme.labelLarge?.copyWith(
                                color:
                                    colorScheme.onBackground.withOpacity(0.8),
                              ) ??
                              const TextStyle(),
                          rightChevronIcon: Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onBackground.withOpacity(0.6),
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left_rounded,
                            color: colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                        daysOfWeekHeight: 48,
                        calendarBuilders: CalendarBuilders(
                          disabledBuilder: _dateLabelBuilder(
                              colorScheme.onBackground.withOpacity(0.25)),
                          holidayBuilder: _dateLabelBuilder(
                              colorScheme.onBackground.withOpacity(0.5)),
                          defaultBuilder:
                              _dateLabelBuilder(colorScheme.onBackground),
                          outsideBuilder: _dateLabelBuilder(
                              colorScheme.onBackground.withOpacity(0.5)),
                          selectedBuilder: (context, date, focusedDay) =>
                              Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                  themeStyle?.borderRadius ?? 8),
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          todayBuilder: (context, day, focusedDay) => Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                              // color: colorScheme.onBackground
                              //     .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  themeStyle?.borderRadius ?? 8),
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color:
                                      colorScheme.onBackground.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                          dowBuilder: (context, day) {
                            final text = DateFormat.E().format(day);

                            return Center(
                              child: Text(
                                text,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: day.weekday == DateTime.sunday
                                      ? colorScheme.primary
                                      : colorScheme.onBackground
                                          .withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),
                        // calendarBuilders: ,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDates.clear();
                            });
                          },
                          child: Text(
                            'Clear',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            if (_selectedDates.isNotEmpty) {
                              Navigator.pop(context, _selectedDates);
                            }
                          },
                          child: Text(
                            'Save',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _selectedDates.isNotEmpty
                                  ? colorScheme.primary
                                  : colorScheme.onBackground.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
