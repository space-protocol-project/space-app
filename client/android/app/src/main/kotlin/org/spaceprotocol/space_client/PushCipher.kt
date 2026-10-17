package org.spaceprotocol.space_client

import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

object PushCipher {
    fun open(secret: ByteArray, raw: ByteArray): ByteArray {
        require(secret.size == 32 && raw.size == 1052)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, SecretKeySpec(secret,"AES"),GCMParameterSpec(128,raw.copyOfRange(0,12)))
        cipher.updateAAD("space.push.v1".toByteArray(Charsets.UTF_8))
        val plain = cipher.doFinal(raw.copyOfRange(12,raw.size))
        val size = ((plain[0].toInt() and 255) shl 8) or (plain[1].toInt() and 255)
        require(size in 1..1022)
        return plain.copyOfRange(2,2+size)
    }
}
