package com.linecorp.flutter_line_sdk

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Intent
import android.util.Log
import com.google.gson.Gson
import com.linecorp.flutter_line_sdk.model.UserProfile
import com.linecorp.flutter_line_sdk.util.runIfDebugBuild
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


class LineSdkWrapper(
    private val activity: Activity
) {
    private lateinit var lineApiClient: LineApiClient
    private lateinit var channelId: String
    private val gson = Gson()
    private var loginRequestCode: Int = 0
    private var betaConfig: BetaConfig? = null
    private val uiCoroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)

    fun setupSdk(channelId: String) {
        runIfDebugBuild {  Log.d(TAG, "setupSdk") }

        if (!this::channelId.isInitialized) {
            this.channelId = channelId
        }

        lineApiClient = createLineApiClient(channelId)
    }

    var loginResult: Result? = null

    fun login(
        loginRequestCode: Int,
        scopes: List<String> = listOf("profile"),
        onlyWebLogin: Boolean = false,
        botPromptString: String = "normal",
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
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
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
            loginResult?.error(
                resultCode.toString(),
                "login failed",
                null
            )
        }

        val result = LineLoginApi.getLoginResultFromIntent(intent)
        runIfDebugBuild { Log.d(TAG, "login result:$result") }

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
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
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
                            lineApiResponse.responseData.expiresInMillis
                        )
                    )
                )
            } else {
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
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
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
                            lineApiResponse.responseData.expiresInMillis
                        )
                    )
                )
            } else {
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
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
                            lineApiResponse.responseData.accessToken.expiresInMillis
                        )
                    )
                )
            } else {
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
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

    private fun createLineApiClient(channelId: String): LineApiClient =
        if (betaConfig == null) {
            LineApiClientBuilder(activity.applicationContext, channelId).build()
        } else {
            LineApiClientFactory.createLineApiClient(
                activity.applicationContext,
                channelId,
                betaConfig!!.apiServerBaseUrl
            )
        }
}

data class BetaConfig(
    val openDiscoveryIdDocumentUrl: String,
    val apiServerBaseUrl: String,
    val webLoginPageUrl: String
)
