package com.linecorp.flutter_line_sdk.util

import com.linecorp.flutter_line_sdk.BuildConfig

inline fun runIfDebugBuild(action: () -> Unit) {
    if (BuildConfig.DEBUG) action()
}
