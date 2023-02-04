// package com.flux.clock

// import android.app.Service
// import android.content.Intent
// import androidx.annotation.Nullable
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.view.FlutterCallbackInformation
// import io.flutter.view.FlutterMain
// import io.flutter.view.FlutterNativeView
// import io.flutter.view.FlutterRunArguments
// import android.os.IBinder



// class MyService : Service() {
//     override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//         val callbackDispatcherHandle = intent?.getLongExtra(InitiateCallsToDartInBgPlugin.CALLBACK_DISPATCHER_HANDLE_KEY, 0) ?: 0

//         val flutterCallbackInformation = FlutterCallbackInformation.lookupCallbackInformation(callbackDispatcherHandle)

//         val flutterRunArguments = FlutterRunArguments()
//         flutterRunArguments.bundlePath = FlutterMain.findAppBundlePath()
//         flutterRunArguments.entrypoint = flutterCallbackInformation.callbackName
//         flutterRunArguments.libraryPath = flutterCallbackInformation.callbackLibraryPath

//         val backgroundFlutterView = FlutterNativeView(this, true)
//         backgroundFlutterView.runFromBundle(flutterRunArguments)

//         val mBackgroundChannel = MethodChannel(backgroundFlutterView, "background_channel")

//         val callbackHandle = intent?.getLongExtra(InitiateCallsToDartInBgPlugin.CALLBACK_HANDLE_KEY, 0) ?: 0

//         val args = arrayListOf<Any>()
//         args.add(callbackHandle)

//         mBackgroundChannel.invokeMethod("", args)

//         return START_STICKY
//     }

//     override fun onBind(intent: Intent?): IBinder? {
//         return null
//     }
// }