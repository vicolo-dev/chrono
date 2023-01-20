package com.flux.clock

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.WindowManager;

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/alarm"

    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    //     getWindow().addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);
    //     getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
    //     getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
    // }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        //   call, result ->
        // if (call.method == "turnKeyguardOff") {
        //     turnScreenOnAndKeyguardOff()
        // }
        // if (call.method == "turnKeyguardOn") {
        //     turnScreenOffAndKeyguardOn()
        // }
        // }
    }
}

// fun Activity.turnScreenOnAndKeyguardOff() {
//     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
//         setShowWhenLocked(true)
//         setTurnScreenOn(true)
//     } else {
//         window.addFlags(
//             WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//                     or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
//         )
//     }

//     with(getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager) {
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//             requestDismissKeyguard(this@turnScreenOnAndKeyguardOff, null)
//         }
//     }
// }

// fun Activity.turnScreenOffAndKeyguardOn() {
//     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
//         setShowWhenLocked(false)
//         setTurnScreenOn(false)
//     } else {
//         window.clearFlags(
//             WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//                     or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
//         )
//     }
// }

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
