package org.spaceprotocol.space_client

import java.io.Closeable
import java.io.InputStream
import java.io.OutputStream
import java.io.IOException
import java.security.MessageDigest
import java.util.concurrent.atomic.AtomicBoolean

class ArchiveCancelled : IOException("Копирование отменено")

class ArchiveCancellation {
    private val cancelled = AtomicBoolean(false)
    private val resources = mutableListOf<Closeable>()
    fun check() { if (cancelled.get()) throw ArchiveCancelled() }
    @Synchronized fun track(resource: Closeable) {
        if (cancelled.get()) { resource.close(); throw ArchiveCancelled() }
        resources.add(resource)
    }
    fun cancel() {
        cancelled.set(true)
        val opened = synchronized(this) { resources.toList() }
        Thread {
            for (resource in opened) try { resource.close() } catch (_: Exception) { }
        }.apply { isDaemon = true; start() }
    }
}

data class ArchiveDigest(val bytes: Long, val sha256: String)

object ArchiveStreams {
    const val maxBytes = 2199912448L
    const val bufferBytes = 65536

    fun copy(input: InputStream, output: OutputStream?, cancel: ArchiveCancellation,
             limit: Long = maxBytes, progress: (Long) -> Unit = {}): ArchiveDigest {
        val buffer = ByteArray(bufferBytes)
        val hash = MessageDigest.getInstance("SHA-256")
        var count = 0L
        while (true) {
            cancel.check()
            val read = try { input.read(buffer) } catch (error: IOException) { cancel.check(); throw error }
            cancel.check()
            if (read < 0) break
            if (read == 0) throw IOException("Провайдер вернул пустой блок")
            if (read.toLong() > limit - count) throw IOException("Превышен размер архива")
            output?.write(buffer, 0, read)
            hash.update(buffer, 0, read)
            count += read
            progress(count)
        }
        cancel.check()
        if (count == 0L) throw IOException("Пустой архив")
        output?.flush()
        return ArchiveDigest(count, hash.digest().joinToString("") { "%02x".format(it) })
    }
}
