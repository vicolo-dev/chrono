import 'package:background_fetch/background_fetch.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/timer/logic/update_timers.dart';

Future<void> initBackgroundService() async {
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 30,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE), (String taskId) async {
    // <-- Event handler
    // This is the fetch-event callback.
    logger.i("[BackgroundFetch] Event received $taskId");

    // await initializeIsolate();

  await updateAlarms("initBackgroundService(): Update alarms in background service");
  await updateTimers("initBackgroundService(): Update timers in background service");
    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    logger.i("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    BackgroundFetch.finish(taskId);
  });
}

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
@pragma('vm:entry-point')
void handleBackgroundServiceTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.  
    // You must stop what you're doing and immediately .finish(taskId)
    logger.i("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }  
  logger.i('[BackgroundFetch] Headless event received.');
   await updateAlarms("handleBackgroundServiceTask(): Update alarms in background service");
  await updateTimers("handleBackgroundServiceTask(): Update timers in background service");

  BackgroundFetch.finish(taskId);
}

void registerHeadlessBackgroundService() {
  BackgroundFetch.registerHeadlessTask(handleBackgroundServiceTask);
}
