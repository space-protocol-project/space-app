package org.spaceprotocol.space_client

import android.app.*
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.*

/** Служба существует только во время явно начатого разговора. */
class VoiceService : Service() {
    companion object { const val NOTIFICATION_ID = 42 }
    private var wakeLock: PowerManager.WakeLock? = null
    private var foreground = false
    override fun onBind(intent: Intent?) = null

    override fun onCreate() {
        super.onCreate()
        wakeLock = getSystemService(PowerManager::class.java)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Space:voice").also { it.acquire() }
    }

    override fun onDestroy() {
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        @Suppress("DEPRECATION")
        val reply = intent?.getParcelableExtra<ResultReceiver>("reply")
        try {
            val manager = getSystemService(NotificationManager::class.java)
            if (Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel(
                "space.voice", getString(R.string.voice_channel), NotificationManager.IMPORTANCE_LOW
            ))
            val open = PendingIntent.getActivity(this, 0, Intent(this, MainActivity::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            @Suppress("DEPRECATION")
            val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, "space.voice")
                else Notification.Builder(this)
            val notification = builder
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setContentTitle(getString(R.string.voice_channel))
                .setContentText(getString(R.string.voice_ongoing))
                .setContentIntent(open).setOngoing(true).setCategory(Notification.CATEGORY_CALL).build()
            if (Build.VERSION.SDK_INT >= 29) {
                var types = ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                if (intent?.getBooleanExtra("microphone", false) == true && Build.VERSION.SDK_INT >= 30) {
                    types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
                }
                startForeground(NOTIFICATION_ID, notification, types)
            } else startForeground(NOTIFICATION_ID, notification)
            foreground = true
            reply?.send(0, null)
        } catch (_: Exception) {
            reply?.send(1, null)
            if (!foreground) stopSelf()
        }
        return START_NOT_STICKY
    }
}
