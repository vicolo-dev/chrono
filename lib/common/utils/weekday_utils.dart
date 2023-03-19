import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/common/types/weekday.dart';

bool weekdaysContains(List<Weekday> alarmWeekdays, String name) {
  Weekday weekday =
      weekdays.firstWhere((weekday) => weekday.displayName == name);
  return alarmWeekdays.contains(weekday);
}

bool weekdaysContainsAll(List<Weekday> alarmWeekdays, List<String> names) {
  return names.every((name) => weekdaysContains(alarmWeekdays, name));
}
