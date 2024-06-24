import 'package:clock_app/alarm/types/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getRemainingAlarmTimeText(BuildContext context, Alarm alarm) {
  Duration etaNextAlarm =
      alarm.currentScheduleDateTime!.difference(DateTime.now().toLocal());

  String etaText = '';

  AppLocalizations localizations = AppLocalizations.of(context)!;

  if (etaNextAlarm.inDays > 0) {
    etaText = localizations.daysString(etaNextAlarm.inDays);
  } else if (etaNextAlarm.inHours > 0) {
    int hours = etaNextAlarm.inHours;
    int minutes = etaNextAlarm.inMinutes % 60;
    if (minutes > 0) {
      etaText = localizations.combinedTime(localizations.hoursString(hours),
          localizations.minutesString(minutes));
    } else {
      etaText = localizations.hoursString(hours);
    }
  } else if (etaNextAlarm.inMinutes > 0) {
    int minutes = etaNextAlarm.inMinutes;
    etaText = localizations.minutesString(minutes);
  } else {
    etaText = localizations.lessThanOneMinute;
  }

  return etaText;
}

String getShortRemainingAlarmTimeText(BuildContext context, Alarm alarm) {
  Duration etaNextAlarm =
      alarm.currentScheduleDateTime!.difference(DateTime.now().toLocal());

  String etaText = '';

  AppLocalizations localizations = AppLocalizations.of(context)!;

  if (etaNextAlarm.inDays > 0) {
    etaText = localizations.daysString(etaNextAlarm.inDays);
  } else if (etaNextAlarm.inHours > 0) {
    int hours = etaNextAlarm.inHours;
    int minutes = etaNextAlarm.inMinutes % 60;
    if (minutes > 0) {
      etaText = '${localizations.shortHoursString(hours)} ${localizations.shortMinutesString(minutes)}';
    } else {
      etaText = localizations.shortHoursString(hours);
    }
  } else if (etaNextAlarm.inMinutes > 0) {
    int minutes = etaNextAlarm.inMinutes;
    etaText = localizations.shortMinutesString(minutes);
  } else {
    etaText = localizations.shortMinutesString(1);
  }

  return etaText;
}

String getNewAlarmText(BuildContext context, Alarm alarm) {
  AppLocalizations localizations = AppLocalizations.of(context)!;

  final etaText = getRemainingAlarmTimeText(context, alarm);

  return localizations.alarmRingInMessage(etaText);
}

String getNextAlarmText(BuildContext context, Alarm alarm) {
  AppLocalizations localizations = AppLocalizations.of(context)!;

  final etaText = getShortRemainingAlarmTimeText(context, alarm);

  return localizations.nextAlarmIn(etaText);
}
