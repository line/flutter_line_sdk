//
//  line_sdk.dart
//
//  Copyright (c) 2019-present, LY Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LY Corporation.
//
//  As with any software that integrates with the LY Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

part of flutter_line_sdk;

/// A general manager class for LINE SDK login features.
///
/// Don't create your own instance of this class. Instead, call [LineSDK.instance] to get a shared
/// singleton on which you can call other methods.
class LineSDK {
  /// The method channel connected to the native side of the LINE SDK.
  ///
  /// Don't use this channel directly. Instead, call the public methods on the [LineSDK] class.
  static const MethodChannel channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');

  /// The shared singleton object of `LineSDK`.
  ///
  /// Always use this instance (rather than a self-created instance) to interact with the login
  /// process of the LINE SDK.
  static final LineSDK instance = LineSDK._();

  LineSDK._();

  /// Sets up the SDK with a [channelId] and optional [universalLink].
  ///
  /// This method should be called once and only once, before any other methods in [LineSDK].
  /// Find your [channelId] in the [LINE Developers Console](https://developers.line.biz/console).
  ///
  /// If you need to navigate from LINE back to your app via a universal link, you must also:
  /// 1. Specify the link URL in the LINE Developers Console
  /// 2. Prepare your server and domain to handle the URL
  /// 3. Pass the URL in [universalLink].
  ///
  /// For more about this, see the section "Universal Links support" in
  /// [Setting up your project](https://developers.line.biz/en/docs/ios-sdk/swift/setting-up-project/).
  /// If you don't pass a [universalLink] in this method, LINE SDK will use the traditional URL
  /// scheme to open your app when logging in through LINE.
  Future<void> setup(String channelId, {String? universalLink}) async {
    await channel.invokeMethod('setup', <String, String?>{
      'channelId': channelId,
      'universalLink': universalLink
    });
  }

  /// Logs the user into LINE with the specified [scopes] and [option], by either opening the
  /// LINE client for an existing logged in user, or a web view if the LINE client isn't installed
  /// on the user's device.
  ///
  /// By default, the login process uses only `"profile"` as its required scope. If you need
  /// more scopes, put the ones you want (in addition to the default `"profile"`) in [scopes] as a
  /// list.
  ///
  /// If [scopes] contains `"profile"`, the user profile is returned in the result as
  /// [LoginResult.userProfile]. If `"profile"` is not included, the value of [LoginResult.userProfile]
  /// will be null.
  ///
  /// An access token is issued if the user authorizes your app. This token, along with a refresh
  /// token, is automatically stored in a secure place in your app for later use. You don't need to
  /// refresh the access token manually. Any following API calls will try to refresh the access
  /// token when necessary. However, you can refresh the access token manually with [refreshToken()].
  ///
  /// You can control some other login behaviors, like whether to use a web page for login, or how
  /// to ask the user to add your LINE Official Account as a friend. To do so, create a [LoginOption]
  /// object and pass it to the [option] parameter.
  ///
  /// {@template error_handling}
  /// This method redirects calls to the LINE SDK for the relevant native platform (iOS or Android).
  /// If an error happens in the native platform, a [PlatformException] is thrown. See
  /// [PlatformException.code] and [PlatformException.message] for error details.
  ///
  /// The LINE SDK implementation differs between iOS and Android, which means error codes and messages
  /// can also be different. For platform-specific error information, see
  /// [LineSDKError](https://developers.line.biz/en/reference/ios-sdk-swift/Enums/LineSDKError.html)
  /// (iOS) and
  /// [LineApiError](https://developers.line.biz/en/reference/android-sdk/reference/com/linecorp/linesdk/LineApiError.html)
  /// (Android).
  /// {@endtemplate}
  Future<LoginResult> login(
      {List<String> scopes = const ['profile'], LoginOption? option}) async {
    return await channel.invokeMethod('login', <String, dynamic>{
      'loginRequestCode': option?.requestCode,
      'scopes': scopes,
      'onlyWebLogin': option?.onlyWebLogin,
      'botPrompt': option?.botPrompt,
      'idTokenNonce': option?.idTokenNonce,
    }).then((value) => LoginResult._(_decodeJson(value)));
  }

  /// Logs out the current user by revoking the related tokens.
  ///
  /// {@macro error_handling}
  Future<void> logout() async {
    await channel.invokeMethod('logout');
  }

  /// Gets the current access token in use.
  ///
  /// This returns a `Future<StoredAccessToken>`, with the access token value contained in the
  /// result [StoredAccessToken.value]. If the user isn't logged in, it returns a `null` value as
  /// the [Future] result.
  ///
  /// A valid [StoredAccessToken] object doesn't necessarily mean the access token itself is valid.
  /// It may have expired or been revoked by the user from another device or LINE client.
  ///
  /// {@macro error_handling}
  Future<StoredAccessToken?> get currentAccessToken async {
    String? result = await channel.invokeMethod('currentAccessToken');
    if (result == null) return null;
    return StoredAccessToken._(_decodeJson(result));
  }

  /// Gets the user’s profile.
  ///
  /// Using this method requires the `"profile"` scope.
  ///
  /// {@macro error_handling}
  Future<UserProfile> getProfile() async {
    return await channel
        .invokeMethod('getProfile')
        .then((value) => UserProfile._(_decodeJson(value)));
  }

  /// Refreshes the access token.
  ///
  /// If the token refresh process finishes successfully, the refreshed access token will be
  /// automatically stored in the user's device. You can wait for the result of this method or get
  /// the refreshed token with [currentAccessToken].
  ///
  /// You don't need to refresh the access token manually. Any API call will attempt to refresh the
  /// access token when necessary.
  ///
  /// {@macro error_handling}
  Future<AccessToken> refreshToken() async {
    return await channel
        .invokeMethod('refreshToken')
        .then((value) => AccessToken._(_decodeJson(value)));
  }

  /// Checks whether the stored access token is valid against the LINE authentication server.
  ///
  /// {@macro error_handling}
  Future<AccessTokenVerifyResult> verifyAccessToken() async {
    return await channel
        .invokeMethod('verifyAccessToken')
        .then((value) => AccessTokenVerifyResult._(_decodeJson(value)));
  }

  /// Gets the friendship status between the user and the official account linked to your LINE Login
  /// channel.
  ///
  /// Using this method requires the `"profile"` scope.
  ///
  /// {@macro error_handling}
  Future<BotFriendshipStatus> getBotFriendshipStatus() async {
    return await channel
        .invokeMethod('getBotFriendshipStatus')
        .then((value) => BotFriendshipStatus._(_decodeJson(value)));
  }

  dynamic _decodeJson(String? source) {
    if (source != null) {
      return json.decode(source);
    } else {
      return {};
    }
  }
}
