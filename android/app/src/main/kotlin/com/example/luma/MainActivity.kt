package com.example.luma

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "luma/screen_state"
    private var screenStateReceiver: BroadcastReceiver? = null
    private var methodChannel: MethodChannel? = null
    private var isListening = false

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startScreenListening" -> {
                    startScreenListening()
                    result.success(true)
                }
                "stopScreenListening" -> {
                    stopScreenListening()
                    result.success(true)
                }
                "isScreenOn" -> {
                    val isOn = isScreenOn()
                    result.success(isOn)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startScreenListening() {
        if (isListening) return
        
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                addAction(Intent.ACTION_USER_PRESENT)
            }
        }

        screenStateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    Intent.ACTION_SCREEN_ON -> {
                        sendScreenStateToFlutter(true)
                    }
                    Intent.ACTION_SCREEN_OFF -> {
                        sendScreenStateToFlutter(false)
                    }
                    Intent.ACTION_USER_PRESENT -> {
                        // User unlocked the device - optional: treat as screen on
                        sendScreenStateToFlutter(true)
                    }
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(screenStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(screenStateReceiver, filter)
        }

        isListening = true
    }

    private fun stopScreenListening() {
        if (!isListening) return
        
        try {
            screenStateReceiver?.let {
                unregisterReceiver(it)
            }
        } catch (e: Exception) {
            // Receiver might not be registered
        }
        
        screenStateReceiver = null
        isListening = false
    }

    private fun sendScreenStateToFlutter(isOn: Boolean) {
        methodChannel?.invokeMethod("onScreenStateChanged", isOn)
    }

    private fun isScreenOn(): Boolean {
        val powerManager = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
        return powerManager.isInteractive
    }

    override fun onDestroy() {
        stopScreenListening()
        super.onDestroy()
    }
}
