package com.denilnicolosi.smartinverterapp

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "smart_inverter/install")
            .setMethodCallHandler { call, result ->
                if (call.method != "openInstallPermissionSettings") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                // "Install unknown apps" toggle for this app (Android 8+).
                val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:$packageName"))
                } else {
                    Intent(Settings.ACTION_SECURITY_SETTINGS)
                }
                try {
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }
            }
    }
}
