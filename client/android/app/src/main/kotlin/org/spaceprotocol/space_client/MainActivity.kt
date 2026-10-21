package org.spaceprotocol.space_client

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterActivity() {
    override fun onResume() { super.onResume(); NotificationsBridge.foreground = true }
    override fun onPause() { NotificationsBridge.foreground = false; super.onPause() }
    private var notifications: NotificationsBridge? = null
    private var voice: VoiceBridge? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SecureStorageSync.register(this, flutterEngine.dartExecutor.binaryMessenger)
        voice = VoiceBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "space/voice-session"))
        notifications = NotificationsBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"space/notification-activation"))
        notifications?.intent(intent)
    }
    override fun onNewIntent(intent: Intent) { super.onNewIntent(intent); notifications?.intent(intent) }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        voice?.close()
        voice = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode,permissions,grantResults)
        notifications?.permissionFinished(requestCode)
    }
}
