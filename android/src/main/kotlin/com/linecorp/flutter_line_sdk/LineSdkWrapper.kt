package com.linecorp.flutter_line_sdk

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.gson.Gson
import com.linecorp.flutter_line_sdk.model.UserProfile
import com.linecorp.flutter_line_sdk.util.runIfDebugBuild
import com.linecorp.linesdk.LineApiResponse
import com.linecorp.linesdk.LineApiResponseCode
import com.linecorp.linesdk.Scope
import com.linecorp.linesdk.api.LineApiClient
import com.linecorp.linesdk.api.LineApiClientBuilder
import com.linecorp.linesdk.api.LineApiClientFactory
import com.linecorp.linesdk.auth.LineAuthenticationConfig
import com.linecorp.linesdk.auth.LineAuthenticationConfigFactory
import com.linecorp.linesdk.auth.LineAuthenticationParams
import com.linecorp.linesdk.auth.LineLoginApi
import com.linecorp.linesdk.unitywrapper.model.AccessToken
import com.linecorp.linesdk.unitywrapper.model.BotFriendshipStatus
import com.linecorp.linesdk.unitywrapper.model.LoginResultForFlutter
import com.linecorp.linesdk.unitywrapper.model.VerifyAccessTokenResult
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class LineSdkWrapper {
    private lateinit var lineApiClient: LineApiClient
    private lateinit var channelId: String
    private val gson = Gson()
    private var loginRequestCode: Int = 0
    private var betaConfig: BetaConfig? = null
    private val uiCoroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)

    fun setupSdk(activity: Activity, channelId: String) {
        runIfDebugBuild {  Log.d(TAG, "setupSdk") }

        if (!this::channelId.isInitialized) {
            this.channelId = channelId
        }

        lineApiClient = createLineApiClient(activity, channelId)
    }

    var loginResult: Result? = null

    fun login(
        loginRequestCode: Int,
        activity: Activity,
        scopes: List<String> = listOf("profile"),
        onlyWebLogin: Boolean = false,
        botPromptString: String = "normal",
        idTokenNonce: String? = null,
        result: Result
    ) {
        runIfDebugBuild {
            Log.d(TAG, "login")
            Log.d(TAG, "channelId:$channelId")
            Log.d(TAG, "scopes: $scopes")
        }

        this.loginRequestCode = loginRequestCode

        val lineAuthenticationParams = LineAuthenticationParams.Builder()
            .scopes(Scope.convertToScopeList(scopes))
            .apply {
                botPrompt(LineAuthenticationParams.BotPrompt.valueOf(botPromptString))
                idTokenNonce?.let { nonce(it) }
            }
            .build()

        val lineAuthenticationConfig: LineAuthenticationConfig? =
            createLineAuthenticationConfig(channelId, onlyWebLogin)

        val loginIntent =
            when {
                lineAuthenticationConfig != null -> LineLoginApi.getLoginIntent(
                    activity,
                    lineAuthenticationConfig,
                    lineAuthenticationParams
                )
                onlyWebLogin -> LineLoginApi.getLoginIntentWithoutLineAppAuth(
                    activity, channelId, lineAuthenticationParams)
                else -> LineLoginApi.getLoginIntent(activity, channelId, lineAuthenticationParams)
            }

        activity.startActivityForResult(loginIntent, loginRequestCode)
        loginResult = result
    }

    fun getProfile(result: Result) {
        runIfDebugBuild {  Log.d(TAG, "getProfile") }

        uiCoroutineScope.launch {
            val lineApiResponse = withContext(Dispatchers.IO) { lineApiClient.profile }
            if (!lineApiResponse.isSuccess) {
                result.returnError(lineApiResponse)
            } else {
                val profileData = lineApiResponse.responseData
                val userProfile = UserProfile.convertLineProfile(profileData)
                val jsonString = gson.toJson(userProfile)
                result.success(jsonString)

                runIfDebugBuild { Log.d(TAG, "getProfile: $jsonString") }
            }
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
        if (requestCode != loginRequestCode) return false

        if (resultCode != Activity.RESULT_OK || intent == null) {
            loginResult?.error(resultCode.toString(), "login failed", null)
            loginResult = null
            return true
        }

        val result = LineLoginApi.getLoginResultFromIntent(intent)
        //runIfDebugBuild { Log.d(TAG, "login result:$result") }

        when(result.responseCode) {
            LineApiResponseCode.SUCCESS -> {
                runIfDebugBuild { Log.d(TAG, "login success") }
                loginResult?.success(gson.toJson(LoginResultForFlutter.convertLineResult(result)))
                loginResult = null
            }
            LineApiResponseCode.CANCEL -> {
                loginResult?.error(
                    result.responseCode.name,
                    result.errorData.message,
                    null
                )
            }
            else -> {
                loginResult?.error(
                    result.responseCode.name,
                    result.errorData.message,
                    null
                )
            }
        }

        loginResult = null
        return true
    }

    fun logout(result: Result) {
        runIfDebugBuild {  Log.d(TAG, "logout") }

        uiCoroutineScope.launch {
            val lineApiResponse = withContext(Dispatchers.IO) { lineApiClient.logout() }
            if(!lineApiResponse.isSuccess) {
                result.returnError(lineApiResponse)
            } else {
                result.success(null)
            }
        }
    }

    fun getCurrentAccessToken(result: Result) {
        uiCoroutineScope.launch {
            val lineApiResponse = lineApiClient.currentAccessToken
            if (lineApiResponse.isSuccess) {
                result.success(
                    gson.toJson(
                        AccessToken(
                            lineApiResponse.responseData.tokenString,
                            lineApiResponse.responseData.expiresInMillis / 1000
                        )
                    )
                )
            } else {
                // align with iOS implementation. Don't change it back to result.error()
                result.success(null)
            }
        }
    }

    fun getBotFriendshipStatus(result: Result) {
        runIfDebugBuild {  Log.d(TAG, "getBotFriendshipStatus") }

        uiCoroutineScope.launch {
            val lineApiResponse = withContext(Dispatchers.IO) { lineApiClient.friendshipStatus }
            if (lineApiResponse.isSuccess) {
                result.success(
                    gson.toJson(BotFriendshipStatus(lineApiResponse.responseData.isFriend))
                )
            } else {
                result.returnError(lineApiResponse)
            }
        }
    }

    fun refreshToken(result: Result) {
        runIfDebugBuild {  Log.d(TAG, "refreshToken") }

        uiCoroutineScope.launch {
            val lineApiResponse = withContext(Dispatchers.IO) { lineApiClient.refreshAccessToken() }
            if (lineApiResponse.isSuccess) {
                result.success(
                    gson.toJson(
                        AccessToken(
                            lineApiResponse.responseData.tokenString,
                            lineApiResponse.responseData.expiresInMillis / 1000
                        )
                    )
                )
            } else {
                result.returnError(lineApiResponse)
            }
        }
    }

    fun verifyAccessToken(result: Result) {
        runIfDebugBuild {  Log.d(TAG, "verifyAccessToken") }

        uiCoroutineScope.launch {
            val lineApiResponse = withContext(Dispatchers.IO) { lineApiClient.verifyToken() }
            if (lineApiResponse.isSuccess) {
                result.success(
                    gson.toJson(
                        VerifyAccessTokenResult(
                            channelId,
                            Scope.join(lineApiResponse.responseData.scopes),
                            lineApiResponse.responseData.accessToken.expiresInMillis / 1000
                        )
                    )
                )
            } else {
                result.returnError(lineApiResponse)
            }
        }
    }

    fun setupBetaConfig(
        channelId: String,
        openDiscoveryIdDocumentUrl: String,
        apiServerBaseUrl: String,
        webLoginPageUrl: String
    ) {
        this.channelId = channelId
        betaConfig = BetaConfig(openDiscoveryIdDocumentUrl, apiServerBaseUrl, webLoginPageUrl)
    }

    private fun createLineAuthenticationConfig(
        channelId: String,
        onlyWebLogin: Boolean
    ): LineAuthenticationConfig? {
        val betaConfig = this.betaConfig ?: return null
        return LineAuthenticationConfigFactory.createConfig(
            channelId,
            betaConfig.openDiscoveryIdDocumentUrl,
            betaConfig.apiServerBaseUrl,
            betaConfig.webLoginPageUrl,
            onlyWebLogin
        )
    }

    private fun createLineApiClient(activity: Activity, channelId: String): LineApiClient =
        if (betaConfig == null) {
            LineApiClientBuilder(activity, channelId).build()
        } else {
            LineApiClientFactory.createLineApiClient(
                activity,
                channelId,
                betaConfig!!.apiServerBaseUrl
            )
        }

    private fun <T> Result.returnError(lineApiResponse: LineApiResponse<T>) =
        this.error(lineApiResponse.responseCode.name, lineApiResponse.errorData.message, null)
}

data class BetaConfig(
    val openDiscoveryIdDocumentUrl: String,
    val apiServerBaseUrl: String,
    val webLoginPageUrl: String
)
