package com.oxide.oxide_manager



import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.oxide.oxide_manager/apps"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isAppInstalled") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    val installed = isAppInstalled(packageName)
                    result.success(installed)
                } else {
                    result.error("INVALID_ARGUMENT", "Package name is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isAppInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
}
