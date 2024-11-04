import 'package:background_fetch/background_fetch.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/system/logic/initialize_isolate.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:flutter/material.dart';

Future<void> initBackgroundService({int interval = 60}) async {
  assert(
      interval >= 15, "Interval must be greater than or equal to 15 minutes.");
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: interval,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE), (String taskId) async {
    // <-- Event handler
    // This is the fetch-event callback.
    logger.t("[initBackgroundService] Event received $taskId");

    // await initializeIsolate();

    await updateAlarms(
        "[initBackgroundService] Update alarms in background service");
    await updateTimers(
        "[initBackgroundService] Update timers in background service");
    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    logger.t("[initBackgroundService] Task timed-out taskId: $taskId");
    BackgroundFetch.finish(taskId);
  });
}

Future<void> stopBackgroundService() async {
  await BackgroundFetch.stop();
}

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
@pragma('vm:entry-point')
void handleBackgroundServiceTask(HeadlessTask task) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.f(
        "Error in handleBackgroundServiceTask isolate: ${details.exception.toString()}");
  };
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    logger.t("[handleBackgroundServiceTask] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  await initializeIsolate();
  logger.t('[handleBackgroundServiceTask] Headless event received.');
  await updateAlarms(
      "[handleBackgroundServiceTask] Update alarms in background service");
  await updateTimers(
      "[handleBackgroundServiceTask] Update timers in background service");

  BackgroundFetch.finish(taskId);
}

void registerHeadlessBackgroundService() {
  if (appSettings
          .getGroup('General')
          .getGroup('Reliability')
          .getSetting('useBackgroundService')
          .value ==
      false) {
    return;
  }

  BackgroundFetch.registerHeadlessTask(handleBackgroundServiceTask);
}
