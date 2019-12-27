package com.linecorp.flutter_line_sdk.model

import com.linecorp.linesdk.LineProfile

data class UserProfile(
    val userId: String,
    val displayName: String,
    val pictureUrl: String,
    val statusMessage: String
) {
    companion object {
        fun convertLineProfile(profile: LineProfile): UserProfile =
            UserProfile(
                profile.userId,
                profile.displayName,
                profile.pictureUrl?.toString() ?: "",
                profile.statusMessage ?: ""
            )
    }
}

