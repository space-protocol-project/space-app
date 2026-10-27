package org.spaceprotocol.space_client

import android.database.Cursor
import android.database.MatrixCursor
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.provider.DocumentsProvider
import android.provider.DocumentsContract.Document
import android.provider.DocumentsContract.Root
import java.io.File
import java.io.IOException

/** Только debug APK: провайдер CI с реальными файловыми дескрипторами. */
class ArchiveTestProvider : DocumentsProvider() {
    private fun file(id: String): File {
        require(Regex("[a-z-]+").matches(id))
        return File(requireNotNull(context).cacheDir, "archive-provider-$id")
    }
    override fun onCreate() = true
    override fun queryRoots(projection: Array<out String>?): Cursor = MatrixCursor(arrayOf(
        Root.COLUMN_ROOT_ID, Root.COLUMN_DOCUMENT_ID, Root.COLUMN_TITLE, Root.COLUMN_FLAGS, Root.COLUMN_MIME_TYPES
    )).apply { addRow(arrayOf("archives", "root", "Space CI archives", Root.FLAG_SUPPORTS_CREATE, "*/*")) }
    override fun queryDocument(id: String, projection: Array<out String>?): Cursor = MatrixCursor(arrayOf(
        Document.COLUMN_DOCUMENT_ID, Document.COLUMN_DISPLAY_NAME, Document.COLUMN_MIME_TYPE,
        Document.COLUMN_FLAGS, Document.COLUMN_SIZE
    )).apply { addRow(arrayOf(id, "$id.spacedevice", "application/octet-stream",
        Document.FLAG_SUPPORTS_WRITE or Document.FLAG_SUPPORTS_DELETE, null)) }
    override fun queryChildDocuments(id: String, projection: Array<out String>?, sortOrder: String?): Cursor =
        MatrixCursor(arrayOf(Document.COLUMN_DOCUMENT_ID))
    override fun createDocument(parent: String, mimeType: String, displayName: String): String = "output"
    override fun deleteDocument(id: String) {
        if (id == "deny-delete") throw IOException("Провайдер отказал в удалении")
        val file = file(id)
        if (file.exists() && !file.delete()) throw IOException("Нет удаления")
    }
    override fun openDocument(id: String, mode: String, signal: CancellationSignal?): ParcelFileDescriptor {
        signal?.throwIfCanceled()
        return ParcelFileDescriptor.open(file(id), ParcelFileDescriptor.parseMode(mode))
    }
}
