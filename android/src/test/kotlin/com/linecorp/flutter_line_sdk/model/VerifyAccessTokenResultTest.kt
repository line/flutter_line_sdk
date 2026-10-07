package com.linecorp.linesdk.unitywrapper.model

import com.google.gson.Gson
import com.google.gson.JsonParser
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class VerifyAccessTokenResultTest {
    @Test
    fun serializesExpiresInWithDartExpectedKey() {
        val json = Gson().toJson(
            VerifyAccessTokenResult(
                channelId = "1440057261",
                scope = "profile",
                expireIn = 2591659
            )
        )

        val data = JsonParser().parse(json).asJsonObject

        assertTrue(data.has("client_id"))
        assertTrue(data.has("scope"))
        assertTrue(data.has("expires_in"))
        assertFalse(data.has("expire_in"))
        assertEquals("1440057261", data.get("client_id").asString)
        assertEquals("profile", data.get("scope").asString)
        assertEquals(2591659, data.get("expires_in").asLong)
    }
}
