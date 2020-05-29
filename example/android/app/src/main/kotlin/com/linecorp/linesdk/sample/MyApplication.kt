package com.linecorp.linesdk.sample

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication


class MyApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
