package com.linecorp.flutter_line_sdk

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

class FlutterLineSdkPlugin : MethodCallHandler, PluginRegistry.ActivityResultListener, FlutterPlugin, ActivityAware {

    private var methodChannel: MethodChannel? = null
    private val lineSdkWrapper = LineSdkWrapper()

    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
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
                val activity = activity
                if  (activity == null) {
                    result.error(
                        "no_activity_found",
                        "There is no valid Activity found to present LINE SDK Login screen.",
                        null
                    )
                    return
                }
                lineSdkWrapper.setupSdk(activity, channelId)
                result.success(null)
            }
            "login" -> {
                val activity = this.activity
                if (activity == null) {
                    result.error(
                        "no_activity_found",
                        "There is no valid Activity found to present LINE SDK Login screen.",
                        null
                    )
                    return
                }

                val scopes = call.argument("scopes") ?: emptyList<String>()
                val isWebLogin = call.argument("onlyWebLogin") ?: false
                val botPrompt  = call.argument("botPrompt") ?: "normal"
                val idTokenNonce: String? = call.argument("idTokenNonce")
                val loginRequestCode = call.argument<Int?>("loginRequestCode") ?: DEFAULT_ACTIVITY_RESULT_REQUEST_CODE
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
            "getProfile" -> lineSdkWrapper.getProfile(result)
            "currentAccessToken" -> lineSdkWrapper.getCurrentAccessToken(result)
            "refreshToken" -> lineSdkWrapper.refreshToken(result)
            "verifyAccessToken" -> lineSdkWrapper.verifyAccessToken(result)
            "getBotFriendshipStatus" -> lineSdkWrapper.getBotFriendshipStatus(result)
            "logout" -> lineSdkWrapper.logout(result)
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = null;
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean =
        lineSdkWrapper.handleActivityResult(requestCode, resultCode, intent)

    private fun bindActivityBinding(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        this.activityBinding = binding
        addActivityResultListener(binding)
    }

    private fun unbindActivityBinding() {
        activityBinding?.removeActivityResultListener(this)
        this.activity = null;
        this.activityBinding = null
    }

    private fun onAttachedToEngine(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler(this)
    }

    private fun addActivityResultListener(activityBinding: ActivityPluginBinding) {
        activityBinding.addActivityResultListener(this)
    }

    private fun addActivityResultListener(registrar: PluginRegistry.Registrar) {
        registrar.addActivityResultListener(this)
    }

    companion object {
        private const val CHANNEL_NAME = "com.linecorp/flutter_line_sdk"
        private const val DEFAULT_ACTIVITY_RESULT_REQUEST_CODE = 8192

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            FlutterLineSdkPlugin().apply {
                onAttachedToEngine(registrar.messenger())
                activity = registrar.activity()
                addActivityResultListener(registrar)
            }
        }
    }
}
