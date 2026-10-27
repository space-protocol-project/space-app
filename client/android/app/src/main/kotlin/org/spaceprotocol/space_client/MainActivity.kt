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
    private var userExport: UserExportBridge? = null
    private var archives: ArchiveBridge? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SecureStorageSync.register(this, flutterEngine.dartExecutor.binaryMessenger)
        archives = ArchiveBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "space/archive-documents"))
        userExport = UserExportBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "space/user-export"))
        voice = VoiceBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "space/voice-session"))
        notifications = NotificationsBridge(this, MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"space/notification-activation"))
        notifications?.intent(intent)
    }
    override fun onNewIntent(intent: Intent) { super.onNewIntent(intent); notifications?.intent(intent) }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        archives?.close()
        archives = null
        userExport?.close()
        userExport = null
        voice?.close()
        voice = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode,permissions,grantResults)
        notifications?.permissionFinished(requestCode)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (archives?.activityResult(requestCode, resultCode, data) == true) return
        if (userExport?.activityResult(requestCode, resultCode, data) == true) return
        super.onActivityResult(requestCode, resultCode, data)
    }
}
