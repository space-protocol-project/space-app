package org.spaceprotocol.space_client

import android.util.Base64
import org.json.JSONObject
import java.net.URL
import java.security.MessageDigest
import java.security.cert.X509Certificate
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

object PushWire {
    fun decode(key: String, envelope: String): JSONObject {
        require(envelope.length <= 1500)
        val raw = Base64.decode(envelope, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
        val secret = Base64.decode(key, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
        val target = JSONObject(String(PushCipher.open(secret,raw),Charsets.UTF_8))
        val now = System.currentTimeMillis() / 1000
        require(target.getLong("expires") > now && target.getLong("expires") <= now + 86400)
        require(target.getLong("sequence") > 0)
        require(target.getString("channel").matches(Regex("[a-z][a-z0-9_-]{0,63}")))
        require(target.getString("event").matches(Regex("[a-f0-9]{32}")))
        return target
    }

    fun poll(config: JSONObject, body: String): Pair<Int, String> {
        val url = URL(config.getString("endpoint") + "/api/push/poll")
        require(url.protocol == "https" && url.userInfo == null)
        val expected = config.getString("fingerprint")
        require(expected.matches(Regex("[a-f0-9]{64}")))
        val trust = object : X509TrustManager {
            override fun getAcceptedIssuers(): Array<X509Certificate> = emptyArray()
            override fun checkClientTrusted(chain: Array<X509Certificate>, auth: String) { throw SecurityException() }
            override fun checkServerTrusted(chain: Array<X509Certificate>, auth: String) {
                require(chain.isNotEmpty()); chain[0].checkValidity()
                val digest = MessageDigest.getInstance("SHA-256").digest(chain[0].encoded)
                require(digest.joinToString("") { "%02x".format(it.toInt() and 255) } == expected)
            }
        }
        val ssl = SSLContext.getInstance("TLS").apply { init(null, arrayOf<TrustManager>(trust), null) }
        val connection = url.openConnection() as HttpsURLConnection
        try {
            connection.sslSocketFactory = ssl.socketFactory
            // Идентичность закреплена отпечатком сертификата, независимо от адреса.
            connection.hostnameVerifier = javax.net.ssl.HostnameVerifier { _, _ -> true }
            connection.instanceFollowRedirects = false
            connection.connectTimeout = 10000; connection.readTimeout = 30000
            connection.requestMethod = "POST"; connection.doOutput = true
            connection.setRequestProperty("Authorization", "Bearer " + config.getString("token"))
            connection.setRequestProperty("Content-Type", "application/json")
            connection.outputStream.use { it.write(body.toByteArray(Charsets.UTF_8)) }
            val code = connection.responseCode
            if (code != 200) return Pair(code, "")
            val bytes = connection.inputStream.use { input ->
                val output = java.io.ByteArrayOutputStream()
                val buffer = ByteArray(4096)
                while (true) {
                    val size = input.read(buffer)
                    if (size < 0) break
                    require(output.size() + size <= 100000)
                    output.write(buffer,0,size)
                }
                output.toByteArray()
            }
            require(bytes.size <= 100000)
            return Pair(code, String(bytes, Charsets.UTF_8))
        } finally { connection.disconnect() }
    }
}
