package org.spaceprotocol.space_client

import android.Manifest
import android.app.*
import android.content.*
import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import org.json.JSONArray
import org.json.JSONObject
import java.security.SecureRandom

class NotificationsBridge(private val activity: MainActivity, private val channel: MethodChannel) {
    private var pending: String? = null
    private var ready = false
    private var permissionResult: MethodChannel.Result? = null
    init { channel.setMethodCallHandler { call, result -> handle(call, result) } }
    fun intent(intent: Intent?) {
        val token = intent?.getStringExtra("space.notification.token") ?: return
        intent.removeExtra("space.notification.token")
        if (!token.matches(Regex("[a-f0-9]{32}"))) return
        if (ready) channel.invokeMethod("activate", token) else pending = token
    }
    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "permission" && Build.VERSION.SDK_INT >= 33 &&
            activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            permissionResult?.success(false)
            permissionResult = result
            activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS),5731)
            return
        }
        try { result.success(dispatch(call)) }
        catch (_: Exception) { result.error("notification", "Не удалось обновить уведомления", null) }
    }
    fun permissionFinished(request: Int) {
        if (request != 5731) return
        permissionResult?.success(activity.getSystemService(NotificationManager::class.java).areNotificationsEnabled())
        permissionResult = null
    }
    private fun dispatch(call: MethodCall): Any? = when (call.method) {
        "initialize" -> { channels(activity); null }
        "permission" -> permission()
        "initial" -> { ready = true; val value = pending; pending = null; value }
        "take" -> take(call.arguments as String)
        "show" -> { show(call.arguments as Map<*, *>); null }
        "clear" -> { clear(); null }
        "pushIdentity" -> identity(call.arguments as String)
        "pushConfigure" -> { configure(call.arguments as Map<*, *>); null }
        "pushSync" -> { sync(call.arguments as Map<*, *>); null }
        else -> throw IllegalArgumentException()
    }
    private fun permission(): Boolean {
        if (Build.VERSION.SDK_INT >= 33 && activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 5731)
            return false
        }
        return activity.getSystemService(NotificationManager::class.java).areNotificationsEnabled()
    }
    private fun take(token: String): String? = synchronized(PushStore.lock) {
        if (!token.matches(Regex("[a-f0-9]{32}"))) return@synchronized null
        val store = PushStore(activity); val root = store.read()
        val targets = root.optJSONObject("targets") ?: return@synchronized null
        val target = targets.optJSONObject(token) ?: return@synchronized null
        targets.remove(token); store.write(root)
        if (target.getLong("expires") <= System.currentTimeMillis() / 1000) null else target.getString("payload")
    }
    private fun show(args: Map<*, *>) {
        val token = args["token"] as String
        require(token.matches(Regex("[a-f0-9]{32}")))
        post(activity, token, args["tag"] as String, args["title"] as String, args["body"] as String)
    }
    private fun clear() = synchronized(PushStore.lock) {
        val store = PushStore(activity); val root = store.read(); root.remove("targets"); store.write(root)
        val manager = activity.getSystemService(NotificationManager::class.java)
        manager.activeNotifications.filter { it.id != 1 }.forEach { manager.cancel(it.tag,it.id) }
    }
    private fun identity(id: String): Map<String,String> = synchronized(PushStore.lock) {
        require(id.length <= 2048)
        val store = PushStore(activity); val root = store.read()
        val identities = root.optJSONObject("identities") ?: JSONObject().also { root.put("identities",it) }
        val entry = identities.optJSONObject(id) ?: JSONObject().put("binding", randomHex()).put("key", randomKey()).also { identities.put(id,it) }
        require(identities.length() <= 16); store.write(root)
        mapOf("binding" to entry.getString("binding"), "key" to entry.getString("key"))
    }
    private fun configure(args: Map<*, *>) = synchronized(PushStore.lock) {
        val id = args["scope"] as String
        val store = PushStore(activity); val root = store.read()
        val configs = root.optJSONObject("configs") ?: JSONObject().also { root.put("configs",it) }
        configs.put(id,JSONObject(args)); require(configs.length() <= 16)
        store.write(root)
        if (root.optBoolean("enabled")) PushService.start(activity)
    }
    private fun sync(args: Map<*, *>) = synchronized(PushStore.lock) {
        val store = PushStore(activity); val root = store.read()
        val origins = args["origins"] as List<*>
        val configs = root.optJSONObject("configs") ?: JSONObject()
        configs.keys().asSequence().toList().filter { configs.getJSONObject(it).getString("origin") !in origins }.forEach { configs.remove(it) }
        root.put("configs",configs).put("enabled",args["enabled"] == true); store.write(root)
        if (root.optBoolean("enabled") && configs.length()>0) PushService.start(activity)
        else activity.stopService(Intent(activity,PushService::class.java))
    }
    companion object {
        @Volatile var foreground = false
        fun channels(context: Context) {
            if (Build.VERSION.SDK_INT < 26) return
            val manager = context.getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(NotificationChannel("space.messages","Сообщения",NotificationManager.IMPORTANCE_DEFAULT))
            manager.createNotificationChannel(NotificationChannel("space.connection","Фоновое подключение",NotificationManager.IMPORTANCE_LOW))
        }
        fun builder(context: Context,id: String): Notification.Builder = if(Build.VERSION.SDK_INT>=26) Notification.Builder(context,id) else Notification.Builder(context)
        private fun randomKey(): String = Base64.encodeToString(ByteArray(32).also { SecureRandom().nextBytes(it) },Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
        private fun randomHex(): String = ByteArray(16).also { SecureRandom().nextBytes(it) }.joinToString("") { "%02x".format(it.toInt() and 255) }
        fun post(context: Context, token: String, tag: String, title: String, body: String) {
            channels(context)
            val manager=context.getSystemService(NotificationManager::class.java)
            val previous=manager.activeNotifications.filter { it.id==2 && it.tag!=tag }.sortedBy { it.postTime }
            previous.take(maxOf(0,previous.size-63)).forEach { manager.cancel(it.tag,it.id) }
            val intent = Intent(context,MainActivity::class.java).setAction("space.notification.$token")
                .putExtra("space.notification.token",token).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            val click = PendingIntent.getActivity(context,0,intent,PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            manager.notify(tag,2,builder(context,"space.messages")
                .setSmallIcon(android.R.drawable.ic_dialog_email).setContentTitle(title).setContentText(body)
                .setContentIntent(click).setAutoCancel(true).setOnlyAlertOnce(true).build())
        }
        fun deliver(context: Context,id: String,config: JSONObject,target: JSONObject) = synchronized(PushStore.lock) {
            val store = PushStore(context); val root = store.read()
            if (!root.optBoolean("enabled")) return@synchronized
            if (root.optJSONObject("configs")?.optJSONObject(id)?.optString("token") != config.getString("token")) return@synchronized
            if (foreground) return@synchronized
            val targets = root.optJSONObject("targets") ?: JSONObject().also { root.put("targets",it) }
            val event = target.getString("event")
            val seen = root.optJSONObject("seen") ?: JSONObject().also { root.put("seen",it) }
            if (seen.has(event)) return@synchronized
            val payload = JSONArray().put(config.getString("origin")).put(config.getString("principal"))
                .put(target.getString("channel")).put(target.getLong("sequence"))
            if (target.optString("group").isNotEmpty()) payload.put("@push:"+target.getLong("sequence")).put(target.getString("group"))
            while (targets.length()>=64) targets.remove(targets.keys().next())
            targets.put(event,JSONObject().put("payload",payload.toString()).put("expires",target.getLong("expires")))
            store.write(root)
            post(context,event,id+":"+target.getString("channel"),"Space","Новое сообщение")
            while (seen.length()>=256) seen.remove(seen.keys().next())
            seen.put(event,target.getLong("expires")); store.write(root)
        }
    }
}
