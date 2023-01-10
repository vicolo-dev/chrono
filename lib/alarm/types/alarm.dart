import 'dart:convert';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:just_audio/just_audio.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

double timeOfDayToHours(TimeOfDay timeOfDay) =>
    timeOfDay.hour + timeOfDay.minute / 60.0;

double dateTimeToHours(DateTime dateTime) =>
    dateTime.hour + dateTime.minute / 60.0;

@pragma('vm:entry-point')
void ringAlarm() async {
  var alarms = await FlutterSystemRingtones.getAlarmSounds();
  final DateTime now = DateTime.now();
  final player = AudioPlayer();
  await player.setAudioSource(AudioSource.uri(Uri.parse(alarms[0].uri)));
  player.play();
  print("[$now] Alarm ringing");
}

class Alarm {
  TimeOfDay time;
  List<WeekDay> weekDays;

  static int id = 0;

  Alarm(this.time, {this.weekDays = const []}) {
    scheduleOneTime();
  }

  void scheduleOneTime() {
    DateTime currentDateTime = DateTime.now();

    DateTime alarmTime;

    if (timeOfDayToHours(time) > dateTimeToHours(currentDateTime)) {
      alarmTime = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, time.hour, time.minute);
    } else {
      DateTime nextDateTime = currentDateTime.add(const Duration(days: 1));
      alarmTime = DateTime(nextDateTime.year, nextDateTime.month,
          nextDateTime.day, time.hour, time.minute);
    }

    scheduleAtTime(alarmTime);
  }

  void scheduleAtTime(DateTime alarmTime) {
    AndroidAlarmManager.oneShotAt(alarmTime, id++, ringAlarm,
        allowWhileIdle: true,
        alarmClock: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true);
  }

  void cancel() {
    AndroidAlarmManager.cancel(id);
  }

  // fromJson
  Alarm.fromJson(Map<String, dynamic> json)
      : time = TimeOfDay(
            hour: json['time']['hour'], minute: json['time']['minute']),
        weekDays =
            json['weekDays'].map<WeekDay>((e) => WeekDay.values[e]).toList();

  Map<String, dynamic> toJson() => {
        'time': {'hour': time.hour, 'minute': time.minute},
        'weekDays': weekDays.map((e) => e.index).toList(),
      };

  static String encode(List<Alarm> alarms) => json.encode(
        alarms.map<Map<String, dynamic>>((alarm) => alarm.toJson()).toList(),
      );

  static List<Alarm> decode(String alarms) =>
      (json.decode(alarms) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}
