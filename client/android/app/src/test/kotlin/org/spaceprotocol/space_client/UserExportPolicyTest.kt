package org.spaceprotocol.space_client

import org.junit.Assert.*
import org.junit.Test

class UserExportPolicyTest {
    @Test fun binaryBackupNamesAreSeparate() {
        assertTrue(UserExportPolicy.validName("space-1793044400000.spacebackup", true))
        assertFalse(UserExportPolicy.validName("space-user-content-1.json", true))
        assertFalse(UserExportPolicy.validName("../../space-1.spacebackup", true))
        assertFalse(UserExportPolicy.validName("space-1.spacebackup"))
    }

    @Test fun namesStayInTheExportFormat() {
        assertTrue(UserExportPolicy.validName("space-user-content-1793044400000.json"))
        for (name in listOf("../keys.json", "other.json", "space-user-content-1.json.exe", "space-user-content-1\n.json")) {
            assertFalse(UserExportPolicy.validName(name))
        }
    }
    @Test fun payloadIsBounded() {
        assertTrue(UserExportPolicy.validSize(1))
        assertTrue(UserExportPolicy.validSize(16 * 1024 * 1024))
        assertFalse(UserExportPolicy.validSize(0))
        assertFalse(UserExportPolicy.validSize(16 * 1024 * 1024 + 1))
    }
}
