import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> updateStopwatch(Future<void> Function(ClockStopwatch) callback) async {
  List<ClockStopwatch> stopwatches = await loadList("stopwatches");
  // int timerIndex = timers.indexWhere((timer) => timer.id == scheduleId);
  // if(timerIndex == -1) return;
  ClockStopwatch stopwatch = stopwatches.first;
  await callback(stopwatch);
  await saveList("stopwatches", [stopwatch]);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateStopwatches");
}
