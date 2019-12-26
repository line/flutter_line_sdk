package com.linecorp.linesdk.unitywrapper.model

import android.support.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class VerifyAccessTokenResult(
    @SerializedName("client_id")
    val channelId: String,
    val scope: String,
    @SerializedName("expire_in")
    val expireIn: Long
)
