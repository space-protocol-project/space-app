package org.spaceprotocol.space_client

import android.content.Context
import com.it_nomads.fluttersecurestorage.FlutterSecureStorageConfig
import com.it_nomads.fluttersecurestorage.NamespacedConfigSource
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.io.IOException

// Плагин шифрует данные; здесь только ожидаем сохранения его SharedPreferences.
object SecureStorageSync {
    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, "space/secure-storage", StandardMethodCodec.INSTANCE,
            messenger.makeBackgroundTaskQueue()).setMethodCallHandler { call, result ->
            if (call.method != "flush") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                val options = call.arguments<Map<String, Any>>()
                    ?: throw IllegalArgumentException("Нет параметров хранилища")
                flush(context, FlutterSecureStorageConfig(options))
                result.success(null)
            } catch (error: Exception) {
                result.error("secure_storage_sync", "Не удалось подтвердить сохранение ключей", null)
            }
        }
    }

    private fun flush(context: Context, config: FlutterSecureStorageConfig) {
        val keys = context.getSharedPreferences(config.effectiveKeyStoragePrefsName, Context.MODE_PRIVATE)
            .edit().commit()
        val settings = NamespacedConfigSource(context, config.effectiveDataPrefsName).edit().commit()
        val data = context.getSharedPreferences(config.effectiveDataPrefsName, Context.MODE_PRIVATE)
            .edit().commit()
        if (!keys || !settings || !data) throw IOException("Ошибка сохранения защищённых записей")
    }
}
