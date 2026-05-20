package com.tholteplok.luma

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "luma/screen_state"
    private var screenStateReceiver: BroadcastReceiver? = null
    private var methodChannel: MethodChannel? = null
    private var isListening = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
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
                    result.success(isScreenOn())
                }
                else -> result.notImplemented()
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
                    Intent.ACTION_SCREEN_ON,
                    Intent.ACTION_USER_PRESENT -> sendScreenStateToFlutter(true)
                    Intent.ACTION_SCREEN_OFF   -> sendScreenStateToFlutter(false)
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(screenStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(screenStateReceiver, filter)
        }

        isListening = true
    }

    private fun stopScreenListening() {
        if (!isListening) return
        try {
            screenStateReceiver?.let { unregisterReceiver(it) }
        } catch (_: Exception) {}
        screenStateReceiver = null
        isListening = false
    }

    private fun sendScreenStateToFlutter(isOn: Boolean) {
        methodChannel?.invokeMethod("onScreenStateChanged", isOn)
    }

    private fun isScreenOn(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
        return pm.isInteractive
    }

    override fun onDestroy() {
        stopScreenListening()
        super.onDestroy()
    }
}
