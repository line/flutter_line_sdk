package com.linecorp.linesdk.unitywrapper.model

import androidx.annotation.Keep
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import com.linecorp.linesdk.auth.LineLoginResult


@Keep
data class AccessToken(
    @SerializedName("access_token")
    val accessToken: String,
    @SerializedName("expires_in")
    val expiresIn: Long,
    @SerializedName("id_token")
    val idToken: String = ""
) {
    companion object {
        fun convertFromLineLoginResult(loginResult: LineLoginResult): AccessToken? {
            val lineIdTokenString = loginResult.lineIdToken?.let {
                Gson().toJson(it)
            } ?: ""
            val accessToken = loginResult.lineCredential?.accessToken ?: return null
            return AccessToken(
                accessToken.tokenString,
                accessToken.expiresInMillis,
                lineIdTokenString
            )
        }
    }
}
