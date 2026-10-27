package org.spaceprotocol.space_client

import org.junit.Assert.*
import org.junit.Test
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.io.IOException

class ArchiveStreamsTest {
    private class Generated(private var remaining: Long, private val block: Int = 65536) : InputStream() {
        var largestRequest = 0
        override fun read(): Int = error("Чтение должно быть блочным")
        override fun read(buffer: ByteArray, offset: Int, length: Int): Int {
            largestRequest = maxOf(largestRequest, length)
            if (remaining == 0L) return -1
            val count = minOf(remaining, length.toLong(), block.toLong()).toInt()
            buffer.fill(42, offset, offset + count)
            remaining -= count
            return count
        }
    }
    @Test fun shortReadsAndDigest() {
        val source = Generated(170001, 37)
        val output = ByteArrayOutputStream()
        val digest = ArchiveStreams.copy(source, output, ArchiveCancellation())
        assertEquals(170001L, digest.bytes)
        assertEquals(digest, ArchiveStreams.copy(ByteArrayInputStream(output.toByteArray()), null, ArchiveCancellation()))
        assertTrue(source.largestRequest <= 65536)
    }
    @Test fun largerThanSignedIntWithoutWholeFileAllocation() {
        val length = Int.MAX_VALUE.toLong() + 65537
        val input = Generated(length)
        assertEquals(length, ArchiveStreams.copy(input, null, ArchiveCancellation()).bytes)
        assertEquals(65536, input.largestRequest)
    }
    @Test fun unknownSizeEnforcedBeforeWritingOverflowBlock() {
        val output = ByteArrayOutputStream()
        try {
            ArchiveStreams.copy(Generated(65, 32), output, ArchiveCancellation(), limit = 64)
            fail("Ожидался предел")
        } catch (_: IOException) { assertEquals(64, output.size()) }
    }
    @Test fun emptyAndStalledStreamsRejected() {
        for (input in listOf(ByteArrayInputStream(byteArrayOf()), Generated(1, 0))) {
            try { ArchiveStreams.copy(input, null, ArchiveCancellation()); fail("Ожидался отказ") }
            catch (_: IOException) { }
        }
    }
    @Test fun cancellationStopsBeforeAnotherWrite() {
        val cancel = ArchiveCancellation()
        val output = ByteArrayOutputStream()
        try {
            ArchiveStreams.copy(Generated(300000), output, cancel) { cancel.cancel() }
            fail("Ожидалась отмена")
        } catch (_: ArchiveCancelled) { assertEquals(65536, output.size()) }
    }
    @Test fun failurePropagatesAndCancellationCanPrecedeRead() {
        val broken = object : OutputStream() { override fun write(value: Int) { throw IOException("Нет места") } }
        try { ArchiveStreams.copy(Generated(1), broken, ArchiveCancellation()); fail("Ожидалась ошибка") }
        catch (_: IOException) { }
        val cancel = ArchiveCancellation().also { it.cancel() }
        try { ArchiveStreams.copy(Generated(1), null, cancel); fail("Ожидалась отмена") }
        catch (_: ArchiveCancelled) { }
    }
}
