package org.spaceprotocol.space_client

import android.content.Intent
import android.provider.DocumentsContract
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File
import java.io.FileOutputStream

@RunWith(AndroidJUnit4::class)
class ArchiveDocumentsTest {
    private val context get() = InstrumentationRegistry.getInstrumentation().targetContext
    private fun uri(id: String) = DocumentsContract.buildDocumentUri(context.packageName + ".archive-test", id)
    private fun providerFile(id: String) = File(context.cacheDir, "archive-provider-$id")
    private fun workspace() = ArchiveWorkspace(context)
    private fun documents() = ArchiveDocuments(context, workspace())
    @Before fun resetOwnedFixtures() {
        val workspace = workspace()
        workspace.read()?.let { workspace.write(it.apply { remove("cleanup") }) }
        workspace.discard()
        for (id in listOf("input", "output", "deny-delete")) providerFile(id).delete()
    }
    private fun largeInput() {
        FileOutputStream(providerFile("input")).use { output ->
            val block = ByteArray(65536) { (it % 251).toByte() }
            repeat(1025) { output.write(block) }
        }
    }
    @Test fun importUnknownSizeAndExportReadBackThroughContentResolver() {
        largeInput()
        val io = documents()
        io.importDocument(uri("input"), ArchiveCancellation()) { }
        assertEquals(67174400L, io.workspace.readyFile().length())
        assertEquals("ready", workspace().read()!!.getString("phase"))
        val expected = java.security.MessageDigest.getInstance("SHA-256")
        providerFile("input").inputStream().use { input ->
            val buffer = ByteArray(65536)
            while (true) { val n = input.read(buffer); if (n < 0) break; expected.update(buffer, 0, n) }
        }
        io.workspace.write(io.workspace.read()!!.put("mode", "export"))
        io.registerCreated(uri("output"), Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        io.exportDocument(uri("output"), ArchiveCancellation()) { }
        val actual = providerFile("output").inputStream().use { ArchiveStreams.copy(it, null, ArchiveCancellation()) }
        assertEquals(expected.digest().joinToString("") { "%02x".format(it) }, actual.sha256)
        assertTrue(workspace().archive.exists())
        assertFalse(workspace().read()!!.has("cleanup"))
    }
    @Test fun cancelledImportDoesNotDeleteOriginalAndCleansPartial() {
        largeInput()
        val cancel = ArchiveCancellation()
        try {
            documents().importDocument(uri("input"), cancel) { cancel.cancel() }
            fail("Ожидалась отмена")
        } catch (_: ArchiveCancelled) { }
        assertTrue(providerFile("input").exists())
        assertFalse(workspace().partial.exists())
        assertFalse(workspace().archive.exists())
        assertNull(workspace().read())
    }
    @Test fun cancelledExportDeletesCreatedDocumentButKeepsSoleArchive() {
        val io = documents()
        io.workspace.begin("export")
        io.workspace.archive.writeBytes(ByteArray(150000))
        io.workspace.phase("ready")
        io.registerCreated(uri("output"), 0)
        val cancel = ArchiveCancellation()
        try { io.exportDocument(uri("output"), cancel) { cancel.cancel() }; fail("Ожидалась отмена") }
        catch (_: ArchiveCancelled) { }
        assertFalse(providerFile("output").exists())
        assertEquals(150000L, workspace().readyFile().length())
    }
    @Test fun restartCleansAbandonedDocumentAndPartialButRetainsExportAndPending() {
        val io = documents()
        io.workspace.begin("export")
        io.workspace.archive.writeBytes(byteArrayOf(1, 2, 3))
        io.workspace.pending.writeBytes(byteArrayOf(4))
        io.workspace.partial.writeBytes(byteArrayOf(5))
        providerFile("output").writeBytes(byteArrayOf(6))
        io.registerCreated(uri("output"), 0)
        documents().recover()
        assertFalse(providerFile("output").exists())
        assertFalse(workspace().partial.exists())
        assertEquals(3L, workspace().readyFile().length())
        assertTrue(workspace().pending.exists())
    }
    @Test fun deletionFailureRetainsCleanupJournalAndArchive() {
        val io = documents()
        io.workspace.begin("export")
        io.workspace.archive.writeBytes(byteArrayOf(1))
        providerFile("deny-delete").writeBytes(byteArrayOf(2))
        io.registerCreated(uri("deny-delete"), 0)
        try { documents().recover(); fail("Ожидался отказ очистки") }
        catch (_: ArchiveCleanupFailed) { }
        assertTrue(workspace().read()!!.has("cleanup"))
        assertTrue(workspace().archive.exists())
    }
    @Test fun interruptedImportCopyCleanedButApplyingArchiveRetained() {
        val io = documents()
        io.workspace.begin("import")
        io.workspace.partial.writeBytes(byteArrayOf(1))
        documents().recover()
        assertNull(workspace().read())
        io.workspace.begin("import")
        io.workspace.archive.writeBytes(byteArrayOf(1, 2))
        io.workspace.phase("applying")
        documents().recover()
        assertEquals("applying", workspace().read()!!.getString("phase"))
        assertEquals(2L, workspace().readyFile().length())
    }
    @Test fun orphanedWorkingFilesCleanedWithoutFollowingLinksOrTouchingOtherCache() {
        val temporary = File(context.cacheDir, "space-migration-ci").apply { mkdirs() }
        File(temporary, "plain.zip").writeBytes(byteArrayOf(1, 2))
        val unrelated = File(context.cacheDir, "archive-unrelated-ci").apply { mkdirs() }
        val retained = File(unrelated, "keep").apply { writeBytes(byteArrayOf(3)) }
        android.system.Os.symlink(unrelated.path, File(temporary, "link").path)
        workspace().removeMigrationTemporaries()
        assertFalse(temporary.exists())
        assertTrue(retained.exists())
        retained.delete(); unrelated.delete()
    }
}
