package com.linecorp.linesdk.unitywrapper.model

import androidx.annotation.Keep


@Keep
data class Error(
    val code: Int,
    val message: String
)
