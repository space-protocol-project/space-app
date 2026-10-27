package org.spaceprotocol.space_client

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.provider.DocumentsContract
import java.io.Closeable
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException

class ArchiveCleanupFailed : IOException("Не удалось удалить незавершённый документ. Повторите очистку или удалите его у провайдера.")

class ArchiveDocuments(private val context: Context, val workspace: ArchiveWorkspace) {
    private val resolver get() = context.contentResolver
    fun recover() {
        cleanup()
        workspace.removePartial()
        val state = workspace.read()
        if (state?.getString("mode") == "import" && state.getString("phase") == "preparing") {
            workspace.discard()
        }
    }

    fun cleanup() {
        val state = workspace.read() ?: return
        if (!state.has("cleanup")) return
        val uri = Uri.parse(state.getString("cleanup"))
        try {
            if (!DocumentsContract.deleteDocument(resolver, uri)) throw ArchiveCleanupFailed()
        } catch (_: java.io.FileNotFoundException) {
            // Документ уже отсутствует.
        } catch (_: Exception) { throw ArchiveCleanupFailed() }
        workspace.write(state.apply { remove("cleanup") })
        release(uri)
    }
    fun acknowledgeCleanup() {
        val state = workspace.read() ?: return
        if (!state.has("cleanup")) return
        val uri = Uri.parse(state.getString("cleanup"))
        workspace.write(state.apply { remove("cleanup") })
        release(uri)
    }

    private fun signal(cancel: ArchiveCancellation): CancellationSignal {
        val signal = CancellationSignal()
        cancel.track(Closeable { signal.cancel() })
        return signal
    }
    private fun input(uri: Uri, cancel: ArchiveCancellation): java.io.InputStream {
        val asset = resolver.openAssetFileDescriptor(uri, "r", signal(cancel))
            ?: throw IOException("Нет потока документа")
        cancel.track(asset)
        return asset.createInputStream().also(cancel::track)
    }
    fun importDocument(uri: Uri, cancel: ArchiveCancellation, progress: (Long) -> Unit) {
        workspace.begin("import")
        try {
            input(uri, cancel).use { source ->
                FileOutputStream(workspace.ownedFile(workspace.partial)).use { target ->
                    cancel.track(target)
                    ArchiveStreams.copy(source, target, cancel, progress = progress)
                    target.fd.sync()
                }
            }
            cancel.check()
            check(workspace.partial.renameTo(workspace.archive)) { "Не удалось завершить копирование" }
            workspace.phase("ready")
        } catch (error: Exception) {
            workspace.discard()
            cancel.check()
            throw error
        } finally { release(uri) }
    }

    fun registerCreated(uri: Uri, flags: Int) {
        val state = requireNotNull(workspace.read())
        check(state.getString("mode") == "export")
        try {
            workspace.write(state.put("cleanup", uri.toString()))
        } catch (error: Exception) {
            try { DocumentsContract.deleteDocument(resolver, uri) }
            catch (_: Exception) { throw ArchiveCleanupFailed() }
            throw error
        }
        try {
            resolver.takePersistableUriPermission(uri, flags and
                (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION))
        } catch (_: SecurityException) { /* Не все провайдеры сохраняют разрешение. */ }
    }
    fun exportDocument(uri: Uri, cancel: ArchiveCancellation, progress: (Long) -> Unit) {
        try {
            val file = workspace.readyFile()
            val expected = FileInputStream(file).use { source ->
                cancel.track(source)
                val descriptor = resolver.openFileDescriptor(uri, "wt", signal(cancel))
                    ?: throw IOException("Нет потока документа")
                cancel.track(descriptor)
                ParcelFileDescriptor.AutoCloseOutputStream(descriptor).use { target ->
                    cancel.track(target)
                    ArchiveStreams.copy(source, target, cancel, progress = progress)
                }
            }
            val actual = input(uri, cancel).use { ArchiveStreams.copy(it, null, cancel) }
            check(actual == expected) { "Не подтверждено сохранение документа" }
            cancel.check()
            val state = requireNotNull(workspace.read()).apply { remove("cleanup") }
            workspace.write(state)
            release(uri)
        } catch (error: Exception) {
            cleanup()
            cancel.check()
            throw error
        }
    }
    private fun release(uri: Uri) {
        try {
            resolver.releasePersistableUriPermission(uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        } catch (_: SecurityException) { }
    }
}
