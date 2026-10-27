package org.spaceprotocol.space_client

internal object UserExportPolicy {
    const val maxBytes = 16 * 1024 * 1024
    fun validName(name: String, binary: Boolean = false): Boolean =
        if (binary) name.matches(Regex("space-[0-9]{1,16}\\.spacebackup")) else
        name.matches(Regex("space-user-content-[0-9]{1,16}\\.json"))
    fun validSize(size: Int): Boolean = size in 1..maxBytes
}
