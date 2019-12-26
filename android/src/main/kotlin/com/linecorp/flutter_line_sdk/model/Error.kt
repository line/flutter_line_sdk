package com.linecorp.linesdk.unitywrapper.model

import android.support.annotation.Keep


@Keep
data class Error(
    val code: Int,
    val message: String
)
