package org.spaceprotocol.space_client

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/** Доступ ограничен документом, который пользователь только что создал через SAF. */
class UserExportBridge(private val activity: MainActivity, private val channel: MethodChannel) {
    private var picker: MethodChannel.Result? = null
    private var destination: Uri? = null
    private var writing = false
    private var closed = false
    private val executor = Executors.newSingleThreadExecutor()
    init { channel.setMethodCallHandler { call, result -> handle(call, result) } }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (closed) { result.error("closed", "Окно закрыто", null); return }
        when (call.method) {
            "choose" -> choose(call.argument<String>("name"), call.argument<Boolean>("binary") == true, result)
            "write" -> write(call, result)
            "discard" -> discard(call.argument<String>("uri"), result)
            else -> result.notImplemented()
        }
    }
    private fun choose(name: String?, binary: Boolean, result: MethodChannel.Result) {
        if (picker != null || writing) { result.error("busy", "Диалог сохранения уже открыт", null); return }
        if (name == null || !UserExportPolicy.validName(name, binary)) { result.error("invalid", "Некорректное имя экспорта", null); return }
        destination = null
        picker = result
        try {
            val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = if (binary) "application/octet-stream" else "application/json"
                putExtra(Intent.EXTRA_TITLE, name)
            }
            activity.startActivityForResult(intent, requestCode)
        } catch (error: Exception) {
            picker = null
            result.error("save_dialog", "Не удалось открыть сохранение документа", null)
        }
    }
    fun activityResult(code: Int, resultCode: Int, data: Intent?): Boolean {
        if (code != requestCode) return false
        val pending = picker ?: return true
        picker = null
        val uri = if (resultCode == Activity.RESULT_OK) data?.data else null
        destination = uri?.takeIf { it.scheme == "content" }
        pending.success(destination?.toString())
        return true
    }
    private fun takeDestination(value: String?): Uri? {
        val uri = destination
        if (uri == null || uri.toString() != value) return null
        destination = null
        return uri
    }
    private fun write(call: MethodCall, result: MethodChannel.Result) {
        val bytes = call.argument<ByteArray>("bytes")
        if (writing || bytes == null || !UserExportPolicy.validSize(bytes.size)) {
            result.error("invalid", "Некорректный размер экспорта", null); return
        }
        val uri = takeDestination(call.argument<String>("uri"))
        if (uri == null) { result.error("invalid", "Документ не выбран", null); return }
        writing = true
        executor.execute {
            val success = writeDocument(uri, bytes)
            activity.runOnUiThread {
                writing = false
                if (!closed) {
                    if (success) result.success(null) else result.error("write", "Не удалось сохранить экспорт", null)
                }
            }
        }
    }
    private fun writeDocument(uri: Uri, bytes: ByteArray): Boolean = try {
        val stream = activity.contentResolver.openOutputStream(uri, "wt")
            ?: throw java.io.IOException("Нет потока документа")
        stream.use { it.write(bytes); it.flush() }
        true
    } catch (error: Exception) {
        deleteDocument(uri)
        false
    }
    private fun deleteDocument(uri: Uri) {
        try { DocumentsContract.deleteDocument(activity.contentResolver, uri) } catch (_: Exception) { }
    }
    private fun discard(value: String?, result: MethodChannel.Result) {
        val uri = takeDestination(value)
        if (uri != null) executor.execute { deleteDocument(uri) }
        result.success(null)
    }
    fun close() {
        closed = true
        channel.setMethodCallHandler(null)
        picker?.error("closed", "Окно закрыто", null)
        picker = null
        val abandoned = destination
        destination = null
        if (abandoned != null) executor.execute { deleteDocument(abandoned) }
        executor.shutdown()
    }
    companion object { private const val requestCode = 0x5ACE }
}
