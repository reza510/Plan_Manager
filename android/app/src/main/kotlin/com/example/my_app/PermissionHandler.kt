package com.example.my_app

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import android.os.Build

class PermissionHandler(private val engine: FlutterEngine) {
    private val channel = MethodChannel(engine.dartExecutor.binaryMessenger, "plan_manager/permissions")
    private var pendingResult: Result? = null

    fun register() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkNotificationPermission" -> {
                    result.success(checkNotificationPermission())
                }
                "requestNotificationPermission" -> {
                    requestNotificationPermission(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                engine.applicationContext,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            // در اندروید 12 و پایین‌تر، مجوز به صورت خودکار وجود دارد
            true
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                      // نیازی به درخواست نیست، بلافاصله موفق برمیگرداند
            result.success(true)
            return
        }

        val activity = (engine.activity as? MainActivity) ?: run {
            result.error("NO_ACTIVITY", "Activity not found", null)
            return
        }

        // بررسی کنید که آیا قبلاً مجوز داده شده است
        if (checkNotificationPermission()) {
            result.success(true)
            return
        }

       // درخواست مجوز
        pendingResult = result
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            MainActivity.REQUEST_NOTIFICATION_PERMISSION
        )
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == MainActivity.REQUEST_NOTIFICATION_PERMISSION) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingResult?.success(granted)
            pendingResult = null
        }
    }
}
