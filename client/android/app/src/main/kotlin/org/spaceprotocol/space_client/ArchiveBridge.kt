package org.spaceprotocol.space_client

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/** Канал переносит только команды и метаданные, никогда большие ByteArray. */
class ArchiveBridge(private val activity: MainActivity, private val channel: MethodChannel) {
    private val worker = Executors.newSingleThreadExecutor()
    private val documents = ArchiveDocuments(activity, ArchiveWorkspace(activity))
    private var active: ArchiveCancellation? = null
    private var picker: MethodChannel.Result? = null
    private var exporting = false
    private var closed = false
    init { channel.setMethodCallHandler(::handle) }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (closed) { result.error("closed", "Окно закрыто", null); return }
        if (call.method == "cancel") { active?.cancel(); result.success(null); return }
        if (active != null) { result.error("busy", "Перенос уже выполняется", null); return }
        when (call.method) {
            "import" -> choose(false, result)
            "save" -> choose(true, result)
            else -> execute(result) { cancel ->
                if (call.method != "acknowledgeCleanup") documents.recover()
                when (call.method) {
                    "status" -> documents.workspace.status()
                    "acknowledgeCleanup" -> { documents.acknowledgeCleanup(); null }
                    "prepare" -> { documents.workspace.begin("export"); documents.workspace.status() }
                    "ready" -> { requireMode("export"); documents.workspace.readyFile(); documents.workspace.phase("ready"); null }
                    "applying" -> { requireMode("import"); documents.workspace.readyFile(); documents.workspace.phase("applying"); null }
                    "complete" -> { requireMode("import"); documents.workspace.discard(); null }
                    "discard" -> {
                        cancel.check()
                        val state = documents.workspace.read()
                        check(state?.getString("mode") != "import" || state.getString("phase") != "applying") {
                            "Завершите начатое восстановление тем же архивом"
                        }
                        documents.workspace.discard(); null
                    }
                    else -> throw IllegalArgumentException("Неизвестная команда")
                }
            }
        }
    }
    private fun requireMode(mode: String) {
        check(documents.workspace.read()?.getString("mode") == mode) { "Другой режим переноса" }
    }
    private fun choose(save: Boolean, result: MethodChannel.Result) {
        active = ArchiveCancellation()
        picker = result
        exporting = save
        try {
            val intent = Intent(if (save) Intent.ACTION_CREATE_DOCUMENT else Intent.ACTION_OPEN_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = "application/octet-stream"
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                if (save) putExtra(Intent.EXTRA_TITLE, "Space-device.spacedevice")
                else type = "*/*"
            }
            activity.startActivityForResult(intent, requestCode)
        } catch (_: Exception) {
            picker = null; active = null
            result.error("picker", "Не удалось открыть выбор документа", null)
        }
    }
    fun activityResult(code: Int, resultCode: Int, data: Intent?): Boolean {
        if (code != requestCode) return false
        val result = picker ?: return true
        picker = null
        val uri = if (resultCode == Activity.RESULT_OK) data?.data else null
        val cancel = requireNotNull(active)
        if (uri == null || uri.scheme != "content") {
            active = null; result.success(null); return true
        }
        execute(result, cancel) { token ->
            if (exporting) {
                documents.registerCreated(uri, data?.flags ?: 0)
                try { token.check() } catch (error: ArchiveCancelled) { documents.cleanup(); throw error }
                documents.exportDocument(uri, token, ::progress)
                true
            } else {
                token.check()
                documents.recover()
                documents.importDocument(uri, token, ::progress)
                documents.workspace.status()
            }
        }
        return true
    }
    private var lastProgress = 0L
    private fun progress(bytes: Long) {
        val now = System.nanoTime()
        if (now - lastProgress < 100_000_000) return
        lastProgress = now
        activity.runOnUiThread { if (!closed) channel.invokeMethod("progress", bytes) }
    }
    private fun execute(result: MethodChannel.Result, cancel: ArchiveCancellation = ArchiveCancellation(),
                        action: (ArchiveCancellation) -> Any?) {
        active = cancel
        worker.execute {
            try {
                val value = action(cancel)
                finish { result.success(value) }
            } catch (error: Exception) {
                val code = when (error) {
                    is ArchiveCancelled -> "cancelled"
                    is ArchiveCleanupFailed -> "cleanup_failed"
                    else -> "archive_io"
                }
                finish { result.error(code, error.message ?: "Ошибка копирования", null) }
            }
        }
    }
    private fun finish(reply: () -> Unit) {
        activity.runOnUiThread { active = null; if (!closed) reply() }
    }
    fun close() {
        closed = true
        active?.cancel()
        picker?.error("closed", "Окно закрыто", null)
        picker = null
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }
    companion object { const val requestCode = 0x5ACF }
}
