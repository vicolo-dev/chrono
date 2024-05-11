 import 'dart:convert';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:receive_intent/receive_intent.dart';


// void navigateToTab(BuildContext context, int tab) {
//   Navigator.of(context)
//                       .pushNamedAndRemoveUntil(Routes.rootRoute, (Route<dynamic> route) => false, arguments: {'tabIndex': tab});}

void handleIntent(Intent? receivedIntent, BuildContext context, Function(Alarm) onSetAlarm, Function(int) setTab) async {
    if (receivedIntent != null) {
      print(
          "Intent received ${receivedIntent.action} ${receivedIntent.data} ${receivedIntent.extra}");
      switch (receivedIntent.action) {
        case "android.intent.action.MAIN":
          final params = receivedIntent.extra?["params"];
          if(params != null){
              ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.byName(jsonDecode(params)['type']);
            if(notificationType == ScheduledNotificationType.alarm){
               setTab(0);
              }
          }
          break;
        case "android.intent.action.SET_ALARM":
          int? hour = receivedIntent.extra?["android.intent.extra.alarm.HOUR"];
          int? minute =
              receivedIntent.extra?["android.intent.extra.alarm.MINUTES"];
          bool skipUi =
              receivedIntent.extra?["android.intent.extra.alarm.SKIP_UI"] ??
                  false;
          bool? vibration =
              receivedIntent.extra?["android.intent.extra.alarm.VIBRATE"];
          String? message =
              receivedIntent.extra?["android.intent.extra.alarm.MESSAGE"];
          // string ringtone = receivedIntent.extra?["android.intent.extra.alarm.RINGTONE"];
          List<int>? days =
              receivedIntent.extra?["android.intent.extra.alarm.DAYS"];
          if (hour == null || minute == null || !skipUi) {
            // print("Navigate to alarm screen");
           setTab(0);
            // navigate to alarm screen and open ui
          } else {
            Alarm alarm =
                Alarm.fromTimeOfDay(TimeOfDay(hour: hour, minute: minute));
            if (vibration != null) {
              alarm.setSetting(context, "Vibrate", vibration);
            }
            if (days != null) {
              // In our system, Monday is 1, Sunday is 7
              // In Android, Sunday is 1, Saturday is 7
              // Rotate the days to match our system
              for (int i = 0; i < days.length; i++) {
                days[i] = (days[i] + 1) % 7;
                if (days[i] == 0) days[i] = 7;
              }

              // The setting accepts a list of bools where Monday is index 0
              List<bool> settingDays = List.filled(7, false);
              for (int day in days) {
                settingDays[day - 1] = true;
              }
              alarm.setSetting(context, "Type", WeeklyAlarmSchedule);
              alarm.setSetting(context, "Week Days", settingDays);
            }
            if (message != null) {
              alarm.setSetting(context, "Label", message);
            }

            alarm.update("handleIntent(): Alarm set by external app");
            List<Alarm> alarms = await loadList<Alarm>("alarms");
            alarms.add(alarm);
            await saveList("alarms", alarms);
            onSetAlarm(alarm);

            // Update the frontend UI if app is open
            ListenerManager.notifyListeners("alarms");
            // setState(() {});
          }
          break;
        case "android.intent.action.SET_TIMER":
          break;
        case "android.intent.action.SET_STOPWATCH":
          break;
        case "android.intent.action.VIEW_ALARMS":
          break;
        case "android.intent.action.VIEW_TIMERS":
          break;
        case "SELECT_NOTIFICATION":
          AlarmNotificationManager.appVisibilityWhenCreated = AppVisibility.state;
          // print("************************************** ${AppVisibility.state}");
          break;
        default:
          break;
      }
    }
  }

