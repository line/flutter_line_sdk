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
import com.linecorp.linesdk.auth.LineAuthenticationParams
import com.linecorp.linesdk.auth.LineLoginApi
import com.linecorp.linesdk.unitywrapper.model.AccessToken
import com.linecorp.linesdk.unitywrapper.model.BotFriendshipStatus
import com.linecorp.linesdk.unitywrapper.model.LoginResultForFlutter
import com.linecorp.linesdk.unitywrapper.model.VerifyAccessTokenResult
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class LineSdkWrapper(
    private val activity: Activity
) {
    private lateinit var lineApiClient: LineApiClient
    private lateinit var channelId: String
    private val gson = Gson()
    private var loginRequestCode: Int = 0

    fun setupSdk(channelId: String) {
        runIfDebugBuild {  Log.d(TAG, "setupSdk") }

        this.channelId = channelId
        lineApiClient = LineApiClientBuilder(activity.applicationContext, channelId).build()

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
                botPromptString?.let {
                    botPrompt(LineAuthenticationParams.BotPrompt.valueOf(botPromptString))
                }
            }
            .build()

        val loginIntent = if (onlyWebLogin) {
            LineLoginApi.getLoginIntentWithoutLineAppAuth(
                activity, channelId, lineAuthenticationParams)
        } else {
            LineLoginApi.getLoginIntent(activity, channelId, lineAuthenticationParams)
        }

        activity.startActivityForResult(loginIntent, loginRequestCode)
        loginResult = result
    }

    fun getProfile(result: Result) {
        GlobalScope.launch {
            val lineApiResponse = lineApiClient.profile
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

                if (BuildConfig.DEBUG) {
                    Log.d(TAG, "getProfile: $jsonString")
                }
            }
        }
    }

    fun handleActivityResult(channel: MethodChannel, requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
        if (requestCode != loginRequestCode) return false

        if (resultCode != Activity.RESULT_OK || intent == null) {
            loginResult?.error(
                resultCode.toString(),
                "login failed",
                null
            )
        }

        val result = LineLoginApi.getLoginResultFromIntent(intent)
        Log.d(TAG, "login result:$result")

        when(result.responseCode) {
            LineApiResponseCode.SUCCESS -> {
                Log.d(TAG, "login success")
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
        GlobalScope.launch {
            val lineApiResponse = lineApiClient.logout()
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
        GlobalScope.launch {
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
                result.error(
                    lineApiResponse.responseCode.name,
                    lineApiResponse.errorData.message,
                    null
                )
            }
        }
    }

    fun getBotFriendshipStatus(result: Result) {
        GlobalScope.launch {
            val lineApiResponse = lineApiClient.friendshipStatus
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
        GlobalScope.launch {
            val lineApiResponse = lineApiClient.refreshAccessToken()
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
        GlobalScope.launch {
            val lineApiResponse = lineApiClient.verifyToken()
            if (lineApiResponse.isSuccess) {
                result.success(
                    gson.toJson(
                        VerifyAccessTokenResult(
                            channelId,
                            lineApiResponse.responseData.scopes.toString(),
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
}
