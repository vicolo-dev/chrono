class AlarmNotificationArguments {
  final List<int> scheduleIds;
  final bool tasksOnly;
  final AlarmDismissType dismissType;

  AlarmNotificationArguments(
      {required this.scheduleIds,
      required this.tasksOnly,
      required this.dismissType});
}

enum AlarmDismissType {
  dismiss,
  skip,
  snooze,
  unsnooze,
}
