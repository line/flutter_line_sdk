package com.linecorp.flutter_line_sdk

import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class FlutterLineSdkPlugin(
    private val channel: MethodChannel,
    private val lineSdkWrapper: LineSdkWrapper
) : MethodCallHandler, PluginRegistry.ActivityResultListener {
    private var loginRequestCode: Int = 0

    override fun onMethodCall(call: MethodCall, result: Result) = when (call.method) {
        "toBeta" -> run {
            val channelId: String = call.argument("channelId") ?: ""
            val openDiscoveryIdDocumentUrl: String = call.argument("openDiscoveryIdDocumentUrl") ?: ""
            val apiServerBaseUrl: String = call.argument("apiServerBaseUrl") ?: ""
            val webLoginPageUrl: String = call.argument("webLoginPageUrl") ?: ""
            lineSdkWrapper.setupBetaConfig(
                channelId,
                openDiscoveryIdDocumentUrl,
                apiServerBaseUrl,
                webLoginPageUrl
            )
            result.success(null)
        }
        "setup" -> {
            val channelId: String = call.argument<String?>("channelId").orEmpty()
            loginRequestCode = (call.argument("loginRequestCode") ?: "0").toInt()
            lineSdkWrapper.setupSdk(channelId)
            result.success(null)
        }
        "login" -> {
            val scopes = call.argument("scopes") ?: emptyList<String>()
            val isWebLogin = call.argument("onlyWebLogin") ?: false
            val botPrompt  = call.argument("botPrompt") ?: "normal"

            lineSdkWrapper.login(
                loginRequestCode,
                scopes = scopes,
                onlyWebLogin = isWebLogin,
                botPromptString = botPrompt,
                result = result
            )
        }
        "getProfile" -> lineSdkWrapper.getProfile(result)
        "currentAccessToken" -> lineSdkWrapper.getCurrentAccessToken(result)
        "refreshToken" -> lineSdkWrapper.refreshToken(result)
        "verifyAccessToken" -> lineSdkWrapper.verifyAccessToken(result)
        "getBotFriendshipStatus" -> lineSdkWrapper.getBotFriendshipStatus(result)
        "logout" -> lineSdkWrapper.logout(result)
        else -> result.notImplemented()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean =
        lineSdkWrapper.handleActivityResult(requestCode, resultCode, intent)

    companion object {
        private const val CHANNEL_NAME = "com.linecorp/flutter_line_sdk"

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val methodChannel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            val lineSdkPlugin =
                FlutterLineSdkPlugin(methodChannel, LineSdkWrapper(registrar.activity()))
            methodChannel.setMethodCallHandler(lineSdkPlugin)
            registrar.addActivityResultListener(lineSdkPlugin)
        }
    }
}
