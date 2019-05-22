package com.linecorp.linesdk.auth

import android.net.Uri

object LineAuthenticationConfigFactory {
    fun createConfig(
        channelId: String,
        openIdDocumentUrl: String,
        apiServerBaseUrl: String,
        webLoginPageUrl: String,
        isLineAppAuthDisabled: Boolean
    ): LineAuthenticationConfig {
        val configBuilder = LineAuthenticationConfig.Builder(channelId)
            .openidDiscoveryDocumentUrl(Uri.parse(openIdDocumentUrl))
            .apiBaseUrl(Uri.parse(apiServerBaseUrl))
            .webLoginPageUrl(Uri.parse(webLoginPageUrl))

        if (isLineAppAuthDisabled) {
            configBuilder.disableLineAppAuthentication()
        }

        return configBuilder.build()
    }
}
