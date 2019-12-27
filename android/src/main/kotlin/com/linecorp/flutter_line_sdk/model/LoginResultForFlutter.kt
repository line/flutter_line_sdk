package com.linecorp.linesdk.unitywrapper.model

import com.linecorp.flutter_line_sdk.model.UserProfile
import com.linecorp.linesdk.Scope
import com.linecorp.linesdk.auth.LineLoginResult

data class LoginResultForFlutter(
    val accessToken: AccessToken,
    val scope: String,
    val userProfile: UserProfile?,
    val friendshipStatusChanged: Boolean,
    val IDTokenNonce: String?
) {
    companion object {
        fun convertLineResult(lineLoginResult: LineLoginResult): LoginResultForFlutter? {
            val accessToken = AccessToken.convertFromLineLoginResult(lineLoginResult) ?: return null
            val lineProfile = lineLoginResult.lineProfile?.let {
                UserProfile.convertLineProfile(it)
            } ?: null
            val scope = lineLoginResult.lineCredential?.scopes?.let {
                Scope.join(it)
            } ?: ""
            return LoginResultForFlutter(
                accessToken,
                scope,
                lineProfile,
                lineLoginResult.friendshipStatusChanged ?: false,
                lineLoginResult.nonce
            )
        }


    }
}
