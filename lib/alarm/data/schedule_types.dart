import 'package:clock_app/alarm/types/schedule_type.dart';

const List<ScheduleType> scheduleTypes = [
  ScheduleType("Once", "Will ring at the next occurrence of the time."),
  ScheduleType("Daily", "Will ring every day"),
  ScheduleType("On Specified Days", "Will repeat on the specified week days"),
  ScheduleType("Advanced", "Set your owns rules for the schedule"),
];
