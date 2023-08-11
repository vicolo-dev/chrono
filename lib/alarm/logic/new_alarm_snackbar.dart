import 'package:clock_app/alarm/types/alarm.dart';

String getNewAlarmSnackbarText(Alarm alarm) {
  Duration etaNextAlarm =
      alarm.currentScheduleDateTime!.difference(DateTime.now().toLocal());

  String etaText = '';

  if (etaNextAlarm.inDays > 0) {
    int days = etaNextAlarm.inDays;
    String dayTextSuffix = days <= 1 ? 'day' : 'days';
    etaText = '$days $dayTextSuffix';
  } else if (etaNextAlarm.inHours > 0) {
    int hours = etaNextAlarm.inHours;
    int minutes = etaNextAlarm.inMinutes % 60;
    String hourTextSuffix = hours <= 1 ? 'hour' : 'hours';
    String minuteTextSuffix = minutes <= 1 ? 'minute' : 'minutes';
    String hoursText = '$hours $hourTextSuffix';
    String minutesText = minutes == 0 ? '' : ' and $minutes $minuteTextSuffix';
    etaText = '$hoursText$minutesText';
  } else if (etaNextAlarm.inMinutes > 0) {
    int minutes = etaNextAlarm.inMinutes;
    String minuteTextSuffix = minutes <= 1 ? 'minute' : 'minutes';
    etaText = '$minutes $minuteTextSuffix';
  } else {
    etaText = 'less than 1 minute';
  }

  return 'Alarm will ring in $etaText';
}
