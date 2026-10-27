package org.spaceprotocol.space_client

import android.content.Context
import android.util.AtomicFile
import org.json.JSONObject
import java.io.File
import java.io.IOException

/** Только фиксированные принадлежащие приложению файлы; URI — лишь журнал очистки. */
class ArchiveWorkspace(context: Context) {
    private val cache = context.cacheDir
    val root = File(context.noBackupFilesDir, "archive-transfer").apply { mkdirs() }
    private val journal = AtomicFile(File(root, "state.json"))
    val archive = File(root, "device.spacedevice")
    val partial = File(root, "input.part")
    val pending = File(root, "device.spacedevice.pending")

    fun read(): JSONObject? {
        if (!journal.baseFile.exists() && !File(root, "state.json.bak").exists()) return null
        val data = journal.openRead().use {
            val bytes = ByteArray(8193)
            var size = 0
            while (size < bytes.size) {
                val count = it.read(bytes, size, bytes.size - size)
                if (count < 0) break
                if (count == 0) throw IOException("Повреждён журнал архива")
                size += count
            }
            if (size > 8192) throw IOException("Повреждён журнал архива")
            JSONObject(String(bytes, 0, size, Charsets.UTF_8))
        }
        require(data.getInt("v") == 1 && data.getString("mode") in listOf("export", "import"))
        require(data.getString("phase") in listOf("preparing", "ready", "applying"))
        return data
    }

    fun write(data: JSONObject) {
        val output = journal.startWrite()
        try {
            output.write(data.toString().toByteArray(Charsets.UTF_8))
            journal.finishWrite(output)
        } catch (error: Exception) {
            journal.failWrite(output)
            throw error
        }
    }

    fun begin(mode: String): JSONObject {
        check(read() == null) { "Сначала завершите прежний перенос" }
        check(!archive.exists() && !pending.exists()) { "Найдена сохранённая копия переноса" }
        return JSONObject().put("v", 1).put("mode", mode).put("phase", "preparing").also(::write)
    }

    fun phase(value: String) { write(requireNotNull(read()).put("phase", value)) }
    fun ownedFile(file: File): File {
        require(file.canonicalFile == file.absoluteFile && file.parentFile == root)
        return file
    }
    fun readyFile(): File {
        val file = ownedFile(archive)
        check(file.isFile && file.length() in 1..ArchiveStreams.maxBytes) { "Архив не подготовлен" }
        return file
    }
    fun removePartial() { delete(ownedFile(partial)) }
    fun removeMigrationTemporaries() {
        val entries = cache.listFiles() ?: throw IOException("Недоступен временный каталог")
        for (entry in entries) {
            if (entry.name.startsWith("space-migration-") && entry.isDirectory &&
                entry.canonicalFile == entry.absoluteFile) removeTree(entry)
        }
    }
    private fun removeTree(file: File) {
        if (file.canonicalFile == file.absoluteFile && file.isDirectory) {
            for (child in file.listFiles() ?: throw IOException("Недоступен временный каталог")) removeTree(child)
        }
        delete(file)
    }
    fun discard() {
        val state = read() ?: return
        check(!state.has("cleanup")) { "Не завершена очистка документа" }
        for (file in listOf(archive, pending, partial)) delete(ownedFile(file))
        journal.delete()
    }
    private fun delete(file: File) {
        if (!file.delete() && file.exists()) throw IOException("Не удалось удалить временный файл")
    }
    fun status(): Map<String, Any>? = read()?.let {
        mapOf("mode" to it.getString("mode"), "phase" to it.getString("phase"),
              "path" to archive.path, "complete" to archive.isFile)
    }
}
