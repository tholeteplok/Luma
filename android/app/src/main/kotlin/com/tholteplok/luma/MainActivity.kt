package com.tholteplok.luma

import android.app.AppOpsManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCREEN_CHANNEL = "luma/screen_state"
    private val PERMISSION_CHANNEL = "luma/permissions"

    private var screenStateReceiver: BroadcastReceiver? = null
    private var screenMethodChannel: MethodChannel? = null
    private var isListening = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ── Screen state channel ──────────────────────────────────────────────
        screenMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SCREEN_CHANNEL,
        )
        screenMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startScreenListening" -> { startScreenListening(); result.success(true) }
                "stopScreenListening"  -> { stopScreenListening();  result.success(true) }
                "isScreenOn"           -> result.success(isScreenOn())
                else                   -> result.notImplemented()
            }
        }

        // ── Permission channel ────────────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PERMISSION_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsageStatsPermission" -> result.success(hasUsageStatsPermission())
                "openUsageAccessSettings" -> {
                    openUsageAccessSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    // ── Usage Stats Permission ────────────────────────────────────────────────

    /**
     * Cek apakah PACKAGE_USAGE_STATS sudah di-grant via AppOpsManager.
     * Ini lebih reliable dari UsageStats.checkUsagePermission() di Flutter.
     */
    private fun hasUsageStatsPermission(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    packageName,
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    packageName,
                )
            }
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Buka Usage Access Settings langsung ke entry Luma.
     *
     * Menggunakan ACTION_USAGE_ACCESS_SETTINGS dengan URI package spesifik
     * (Android 10+). Ini menghindari dialog "Aplikasi ditolak aksesnya" dari
     * OEM karena langsung membuka toggle untuk app ini saja.
     *
     * Fallback ke halaman umum jika URI spesifik tidak didukung.
     */
    private fun openUsageAccessSettings() {
        try {
            // Android 10+ — buka langsung ke entry app ini
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
                    data = Uri.fromParts("package", packageName, null)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                // Cek apakah intent bisa di-handle sebelum launch
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    return
                }
            }
            // Fallback — halaman umum Usage Access
            startActivity(
                Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
            )
        } catch (e: Exception) {
            // Last resort — buka App Settings biasa
            try {
                startActivity(
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                        data = Uri.fromParts("package", packageName, null)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                )
            } catch (_: Exception) {}
        }
    }

    // ── Screen State ──────────────────────────────────────────────────────────

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
        try { screenStateReceiver?.let { unregisterReceiver(it) } } catch (_: Exception) {}
        screenStateReceiver = null
        isListening = false
    }

    private fun sendScreenStateToFlutter(isOn: Boolean) {
        screenMethodChannel?.invokeMethod("onScreenStateChanged", isOn)
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
