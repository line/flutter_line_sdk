package com.linecorp.linesdk.api

import android.content.Context
import android.net.Uri

object LineApiClientFactory {
    fun createLineApiClient(
        context: Context,
        channelId: String,
        apiServerBaseUrl: String
    ): LineApiClient {
        return LineApiClientBuilder(context, channelId)
            .apiBaseUri(Uri.parse(apiServerBaseUrl))
            .build()
    }
}
