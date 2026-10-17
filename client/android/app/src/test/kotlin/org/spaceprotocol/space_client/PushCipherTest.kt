package org.spaceprotocol.space_client

import org.junit.Assert.*
import org.junit.Test
import java.util.Base64
import java.util.Properties

class PushCipherTest {
    private fun vector(): Properties = Properties().apply {
        PushCipherTest::class.java.getResourceAsStream("/private-push-vector.properties")!!.use { load(it) }
    }
    @Test fun decodesRuntimeVector() {
        val fixture=vector()
        val key=Base64.getUrlDecoder().decode(fixture.getProperty("key"))
        val raw=Base64.getUrlDecoder().decode(fixture.getProperty("envelope"))
        assertEquals(fixture.getProperty("plain"),String(PushCipher.open(key,raw),Charsets.UTF_8))
    }
    @Test fun rejectsTamperingAndOtherDevice() {
        val fixture=vector()
        val key=Base64.getUrlDecoder().decode(fixture.getProperty("key"))
        val raw=Base64.getUrlDecoder().decode(fixture.getProperty("envelope"))
        val changed=raw.copyOf().apply { this[lastIndex]=(this[lastIndex].toInt() xor 1).toByte() }
        for (pair in listOf(key to changed,ByteArray(32) to raw,key to raw.copyOf(64))) {
            try { PushCipher.open(pair.first,pair.second); fail("Подмена принята") } catch (_: Exception) { }
        }
    }
}
