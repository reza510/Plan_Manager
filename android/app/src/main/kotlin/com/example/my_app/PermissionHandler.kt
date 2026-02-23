package com.example.my_app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class PermissionHandler(
    private val activity: MainActivity,
    private val engine: FlutterEngine
) {
    private val channel = MethodChannel(engine.dartExecutor.binaryMessenger, "plan_manager/permissions")
    private var pendingResult: Result? = null

    fun register() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkNotificationPermission" -> result.success(checkNotificationPermission())
                "requestNotificationPermission" -> requestNotificationPermission(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun checkNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    private fun requestNotificationPermission(result: Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }

        if (checkNotificationPermission()) {
            result.success(true)
            return
        }

        pendingResult = result
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            MainActivity.REQUEST_NOTIFICATION_PERMISSION
        )
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == MainActivity.REQUEST_NOTIFICATION_PERMISSION) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingResult?.success(granted)
            pendingResult = null
        }
    }
}
