package com.flux.clock

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

// import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/alarm"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        //   call, result ->
        //   // This method is invoked on the main thread.
        //   // TODO
        // }
    }
}

// fun Context.scheduleNotification(isLockScreen: Boolean) {
//     val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
//     val timeInMillis = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(SCHEDULE_TIME)

//     with(alarmManager) {
//         setExact(AlarmManager.RTC_WAKEUP, timeInMillis, getReceiver(isLockScreen))
//     }
// }

// private fun Context.getReceiver(isLockScreen: Boolean): PendingIntent {
//     // for demo purposes no request code and no flags
//     return PendingIntent.getBroadcast(
//         this,
//         0,
//         NotificationReceiver.build(this, isLockScreen),
//         0
//     )
// }

// class NotificationReceiver : BroadcastReceiver() {
//     override fun onReceive(context: Context, intent: Intent) {
//         if(intent.getBooleanExtra(LOCK_SCREEN_KEY, true)) {
//             context.showNotificationWithFullScreenIntent(true)
//         } else {
//             context.showNotificationWithFullScreenIntent()
//         }
//     }

//     companion object {
//         fun build(context: Context, isLockScreen: Boolean): Intent {
//             return Intent(context, NotificationReceiver::class.java).also {
//                 it.putExtra(LOCK_SCREEN_KEY, isLockScreen)
//             }
//         }
//     }
// }

// private const val LOCK_SCREEN_KEY = "lockScreenKey"
