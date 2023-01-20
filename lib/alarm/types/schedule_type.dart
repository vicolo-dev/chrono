import 'package:clock_app/alarm/types/alarm_schedule.dart';

class ScheduleType {
  final String name;
  final String description;

  const ScheduleType(this.name, this.description);
}

List<Type> scheduleTypes = [
  OnceAlarmSchedule,
  DailyAlarmSchedule,
  WeeklyAlarmSchedule,
  DatesAlarmSchedule,
  RangeAlarmSchedule,
];
