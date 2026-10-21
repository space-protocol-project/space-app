package org.spaceprotocol.space_client

import android.content.Intent
import android.os.*
import io.flutter.plugin.common.MethodChannel

class VoiceBridge(private val activity: MainActivity, channel: MethodChannel) {
    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> start(call.argument<Boolean>("microphone") == true, result)
                "stop" -> { close(); result.success(null) }
                else -> result.notImplemented()
            }
        }
    }

    private fun start(microphone: Boolean, result: MethodChannel.Result) {
        val reply = object : ResultReceiver(Handler(Looper.getMainLooper())) {
            override fun onReceiveResult(code: Int, data: Bundle?) {
                if (code == 0) result.success(null)
                else result.error("voice_service", "Не удалось запустить службу разговора", null)
            }
        }
        val intent = Intent(activity, VoiceService::class.java)
            .putExtra("microphone", microphone).putExtra("reply", reply)
        try {
            if (Build.VERSION.SDK_INT >= 26) activity.startForegroundService(intent)
            else activity.startService(intent)
        }
        catch (_: Exception) { result.error("voice_service", "Нельзя начать разговор в фоне", null) }
    }

    fun close() { activity.stopService(Intent(activity, VoiceService::class.java)) }
}
