package org.spaceprotocol.space_client

import android.app.*
import android.content.*
import android.os.Build
import android.os.IBinder
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.Executors
import java.util.concurrent.ConcurrentHashMap

class PushService : Service() {
    private val workers = Executors.newFixedThreadPool(16)
    private val running = ConcurrentHashMap.newKeySet<String>()
    @Volatile private var stopped = false
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onCreate() {
        super.onCreate()
        NotificationsBridge.channels(this)
        startForeground(1, NotificationsBridge.builder(this, "space.connection")
            .setContentTitle("Space").setContentText("Подключение к пространствам")
            .setSmallIcon(android.R.drawable.ic_dialog_info).setOngoing(true).build())
    }
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val root = try { synchronized(PushStore.lock) { PushStore(this).read() } }
        catch (_: Exception) { stopSelf(); return START_NOT_STICKY }
        val configs = root.optJSONObject("configs") ?: JSONObject()
        if (!root.optBoolean("enabled") || configs.length()==0) { stopSelf(); return START_NOT_STICKY }
        configs.keys().forEach { id -> if (running.add(id)) workers.submit { receive(id) } }
        return START_STICKY
    }
    private fun receive(id: String) {
        var failures = 0
        try {
            while (!stopped && !Thread.currentThread().isInterrupted) {
                val config = synchronized(PushStore.lock) {
                    val root = PushStore(this).read()
                    if (!root.optBoolean("enabled")) null else root.optJSONObject("configs")?.optJSONObject(id)
                } ?: return
                try {
                    if (!receiveBatch(id,config)) return
                    failures = 0
                } catch (_: Exception) {
                    failures = minOf(failures + 1, 6)
                    Thread.sleep((1000L shl failures) + java.security.SecureRandom().nextInt(1000))
                }
            }
        } catch (_: InterruptedException) { Thread.currentThread().interrupt() }
        finally { running.remove(id) }
    }
    private fun receiveBatch(id: String, config: JSONObject): Boolean {
        val ack=config.optJSONArray("ack") ?: JSONArray()
        val (code,body)=PushWire.poll(config,JSONObject().put("ack",ack).toString())
        if(code==401) return !remove(id,config.getString("token"))
        require(code==200)
        val frames=JSONArray(body);require(frames.length()<=64)
        val targets=(0 until frames.length()).map { index ->
            PushWire.decode(config.getString("key"),frames.getString(index)).also {
                require(it.getString("binding")==config.getString("binding"))
            }
        }
        val received=JSONArray()
        targets.forEach { target ->
            NotificationsBridge.deliver(this,id,config,target)
            received.put(target.getString("event"))
        }
        saveAck(id,config.getString("token"),received)
        return true
    }
    private fun saveAck(id: String, token: String, received: JSONArray) = synchronized(PushStore.lock) {
        val store=PushStore(this);val root=store.read()
        val current=root.optJSONObject("configs")?.optJSONObject(id)
        if(current?.optString("token")==token) {current.put("ack",received);store.write(root)}
    }
    private fun remove(id: String, token: String): Boolean = synchronized(PushStore.lock) {
        val store = PushStore(this); val root = store.read()
        if(root.optJSONObject("configs")?.optJSONObject(id)?.optString("token") != token) return@synchronized false
        root.optJSONObject("configs")?.remove(id); store.write(root)
        if(root.optJSONObject("configs")?.length()==0) stopSelf()
        val manager = getSystemService(NotificationManager::class.java)
        manager.activeNotifications.filter { it.tag?.startsWith(id+":") == true }.forEach { manager.cancel(it.tag,it.id) }
        true
    }
    override fun onDestroy() { stopped = true; workers.shutdownNow(); super.onDestroy() }
    companion object {
        fun start(context: Context) {
            val intent = Intent(context, PushService::class.java)
            if (Build.VERSION.SDK_INT >= 26) context.startForegroundService(intent) else context.startService(intent)
        }
    }
}

class PushBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED && intent.action != Intent.ACTION_MY_PACKAGE_REPLACED) return
        try {
            val enabled = synchronized(PushStore.lock) { PushStore(context).read().optBoolean("enabled") }
            if (enabled) PushService.start(context)
        } catch (_: Exception) { /* При повреждённом хранилище нужен вход в приложение. */ }
    }
}
