package com.linecorp.flutter_line_sdk

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

class FlutterLineSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {

    private var methodChannel: MethodChannel? = null
    private val lineSdkWrapper = LineSdkWrapper()

    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "toBeta" -> run {
                val channelId = call.argument<String>("channelId").orEmpty()
                val openDiscoveryIdDocumentUrl = call.argument<String>("openDiscoveryIdDocumentUrl").orEmpty()
                val apiServerBaseUrl = call.argument<String>("apiServerBaseUrl").orEmpty()
                val webLoginPageUrl = call.argument<String>("webLoginPageUrl").orEmpty()
                lineSdkWrapper.setupBetaConfig(
                    channelId,
                    openDiscoveryIdDocumentUrl,
                    apiServerBaseUrl,
                    webLoginPageUrl
                )
                result.success(null)
            }
            "setup" -> {
                withActivity(result) { activity ->
                    val channelId = call.argument<String>("channelId").orEmpty()
                    lineSdkWrapper.setupSdk(activity, channelId)
                    result.success(null)
                }
            }
            "login" -> {
                withActivity(result) { activity ->
                    val scopes = call.argument<List<String>>("scopes").orEmpty()
                    val isWebLogin = call.argument<Boolean>("onlyWebLogin") ?: false
                    val botPrompt = call.argument<String>("botPrompt") ?: "normal"
                    val idTokenNonce = call.argument<String>("idTokenNonce")
                    val loginRequestCode = call.argument<Int>("loginRequestCode") 
                        ?: DEFAULT_ACTIVITY_RESULT_REQUEST_CODE
                    lineSdkWrapper.login(
                        loginRequestCode,
                        activity,
                        scopes = scopes,
                        onlyWebLogin = isWebLogin,
                        botPromptString = botPrompt,
                        idTokenNonce = idTokenNonce,
                        result = result
                    )
                }
            }
            "getProfile" -> lineSdkWrapper.getProfile(result)
            "currentAccessToken" -> lineSdkWrapper.getCurrentAccessToken(result)
            "refreshToken" -> lineSdkWrapper.refreshToken(result)
            "verifyAccessToken" -> lineSdkWrapper.verifyAccessToken(result)
            "getBotFriendshipStatus" -> lineSdkWrapper.getBotFriendshipStatus(result)
            "logout" -> lineSdkWrapper.logout(result)
            else -> result.notImplemented()
        }
    }

    private fun withActivity(result: Result, block: (Activity) -> Unit) {
        val activity = this.activity
        if (activity == null) {
            result.error(
                "no_activity_found",
                "There is no valid Activity found to present LINE SDK Login screen.",
                null
            )
            return
        }
        block(activity)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        bindActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        unbindActivityBinding()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        bindActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        unbindActivityBinding()
    }

    private fun bindActivityBinding(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        this.activityBinding = binding
        binding.addActivityResultListener(lineSdkWrapper::handleActivityResult)
    }

    private fun unbindActivityBinding() {
        activityBinding?.removeActivityResultListener(lineSdkWrapper::handleActivityResult)
        this.activity = null
        this.activityBinding = null
    }

    private fun onAttachedToEngine(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler(this)
    }

    companion object {
        private const val CHANNEL_NAME = "com.linecorp/flutter_line_sdk"
        private const val DEFAULT_ACTIVITY_RESULT_REQUEST_CODE = 8192
    }
}
