package com.vicolo.chrono

import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.ArrayList
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant;



class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.vicolo.chrono/alarm"
    
    // // create static method channel
    // companion object {
    //     lateinit var channel: MethodChannel
    // }

    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     // MethodChannelHolder.init(flutterView)
    //     // MethodChannelHolder.invokeMethod("onBoot")
    // }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // GeneratedPluginRegistrant.registerWith(flutterEngine)
        // flutterEngine.plugins.add(InitiateCallsToDartInBgPlugin())
        
    }
}
