package com.example.luma_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val SCREEN_STATE_CHANNEL = "com.luma.app/screen_state"
    private var eventSink: EventChannel.EventSink? = null
    private var screenStateReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Setup EventChannel untuk screen state
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SCREEN_STATE_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    registerScreenStateReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    unregisterScreenStateReceiver()
                    eventSink = null
                }
            })
    }

    private fun registerScreenStateReceiver() {
        screenStateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == Intent.ACTION_SCREEN_ON) {
                    eventSink?.success("screen_on")
                } else if (intent?.action == Intent.ACTION_SCREEN_OFF) {
                    eventSink?.success("screen_off")
                }
            }
        }

        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }

        registerReceiver(screenStateReceiver, filter)
    }

    private fun unregisterScreenStateReceiver() {
        screenStateReceiver?.let {
            unregisterReceiver(it)
            screenStateReceiver = null
        }
    }

    override fun onDestroy() {
        unregisterScreenStateReceiver()
        super.onDestroy()
    }
}
