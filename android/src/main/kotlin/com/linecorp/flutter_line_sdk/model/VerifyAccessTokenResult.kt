package com.linecorp.linesdk.unitywrapper.model

import com.google.gson.annotations.SerializedName

data class VerifyAccessTokenResult(
    @SerializedName("client_id")
    val channelId: String,
    val scope: String,
    @SerializedName("expire_in")
    val expireIn: Long
)
