import 'package:clock_app/alarm/types/alarm_schedule.dart';

Type stringToScheduleType(String name) {
  switch (name) {
    case 'OnceAlarmSchedule':
      return OnceAlarmSchedule;
    case 'DailyAlarmSchedule':
      return DailyAlarmSchedule;
    case 'WeeklyAlarmSchedule':
      return WeeklyAlarmSchedule;
    case 'DatesAlarmSchedule':
      return DatesAlarmSchedule;
    case 'RangeAlarmSchedule':
      return RangeAlarmSchedule;
    default:
      return OnceAlarmSchedule;
  }
}
