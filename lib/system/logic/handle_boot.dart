import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/system/logic/initialize_isolate.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
void handleBoot() async {
  // String appDataDirectory = await getAppDataDirectoryPath();
  //
  // String message = '[${DateTime.now().toString()}] Test2\n';
  //
  // File('$appDataDirectory/log-dart.txt')
  //     .writeAsStringSync(message, mode: FileMode.append);
  //
      FlutterError.onError = (FlutterErrorDetails details) {
    logger.f("Error in handleBoot isolate: ${details.exception.toString()}");
  };

  await initializeIsolate();

  await updateAlarms("handleBoot(): Update alarms on system boot");
  await updateTimers("handleBoot(): Update timers on system boot");
}
