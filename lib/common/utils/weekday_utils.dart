import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/common/types/weekday.dart';

bool weekdaysContains(List<Weekday> alarmWeekdays, int id) {
  Weekday weekday =
      weekdays.firstWhere((weekday) => weekday.id == id);
  return alarmWeekdays.contains(weekday);
}

bool weekdaysContainsAll(List<Weekday> alarmWeekdays, List<int> ids) {
  return ids.every((id) => weekdaysContains(alarmWeekdays, id));
}
