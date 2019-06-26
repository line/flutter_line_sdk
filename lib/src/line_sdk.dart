//
//  line_sdk.dart
//
//  Copyright (c) 2019-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
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

/// {@template error_handling}
/// This method just redirects the work to the native LINE SDK. If any error happens during the native process,
/// a [PlatformException] will be thrown. You can check [PlatformException.code] and [PlatformException.message]
/// for detail information of an error. However, since the implementation in native side is different on iOS and 
/// Android, the error code and message could be different too. See [LineSDKError](https://developers.line.biz/en/reference/ios-sdk-swift/Enums/LineSDKError.html)
/// on iOS and [LineApiError](https://developers.line.biz/en/reference/android-sdk/reference/com/linecorp/linesdk/LineApiError.html) on Android
/// to get more information about error handling.
/// {@endtemplate}

part of flutter_line_sdk;

/// A general manager class for LINE SDK Login features.
/// 
/// Don't create your own instance of this. Instead, call [LineSDK.instance] to get 
/// a shared singleton and call other methods on it.
class LineSDK {

  /// The method channel connected to native side of the LINE SDK.
  /// 
  /// Normally you should not use this channel directly. Instead, call the public methods on 
  /// this `LineSDK` class.
  static const MethodChannel channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');
  
  /// The shared singleton object of `LineSDK`.
  /// 
  /// Always use this instance to interact with the login process of the LINE SDK.
  static final LineSDK instance = LineSDK._();

  LineSDK._();

  /// Sets up the SDK with [channelId] and an optional [universalLink].
  /// 
  /// This method should be called once and only once, before any other methods in LineSDK.
  /// You can find your [channelId] in the [LINE Developers Site](https://developers.line.biz/). 
  /// 
  /// If you need to navigate from LINE back to your app by universal link, you also need to 
  /// set it in the LINE Developers Site, prepare your server and domain to handle the URL, then
  /// pass the URL in [universalLink]. For more about it, check the 
  /// [Universal Links support](https://developers.line.biz/en/docs/ios-sdk/swift/setting-up-project/)
  /// section in documentation. If you do not pass a [universalLink] value in this method, LINE SDK 
  /// will use the traditional URL scheme to open your app when using the LINE app to login.
  Future<void> setup(String channelId, {String universalLink}) async {
    await channel.invokeMethod(
      'setup',
      <String, String>{
        'channelId': channelId, 
        'universalLink': universalLink
      }
    );
  }

  /// Logs in to the LINE Platform with the specified [scopes] and [option], by either opening the LINE app
  /// for existing logged in user there or a web view if LINE app is not installed on user's device.
  /// 
  /// By default, the login process will use only `"profile"` as its required scope.  If you need other scopes 
  /// send all of them (including the default `"profile"`) as a list to [scopes]. 
  /// 
  /// If the value of [scopes] contains `"profile"`, the user profile will be retrieved during the login process 
  /// and contained in the [LoginResult.userProfile] property in the result value. Otherwise, it will be null. 
  /// 
  /// An access token will be issued if the user authorizes your app. This token and a refresh token will be automatically 
  /// stored in a secured place in your app for later use. You do not need to refresh the access token manually because 
  /// any following API calls will attempt to refresh the access token if necessary. However, if you would like to refresh 
  /// the access token manually, use [refreshToken()].
  /// 
  /// You can control some other login behaviors, like whether only trying to login with web page or what the approch 
  /// being used for bot prompting. To do that, create a proper [LoginOption] object and pass it to the [option] parameter.
  /// 
  /// {@macro error_handling}
  Future<LoginResult> login(
    { List<String> scopes = const ["profile"], 
      LoginOption option
    }) async 
  { 
    String result = await channel.invokeMethod(
      'login',
      <String, dynamic>{
        'scopes': scopes,
        'onlyWebLogin': option?.onlyWebLogin,
        'botPrompt': option?.botPrompt
      }
    );
    if (result == null) return null;
    return LoginResult._(json.decode(result));
  }

  /// Logs out the current user by revoking the related tokens.
  /// 
  /// {@macro error_handling}
  Future<void> logout() async {
    await channel.invokeMethod('logout');
  }

  /// Gets the current access token in use.
  /// 
  /// This returns a `Future<StoredAccessToken>` and the access token value in use is contained
  /// in the result [StoredAccessToken.value].
  /// 
  /// If the user is not logged in, it returns a `null` value as the [Future] result.
  /// However, a valid [StoredAccessToken] object does not mean the access token itself is valid since it could be
  /// expired or revoked by user from other devices or LINE app.
  /// 
  /// {@macro error_handling}
  Future<StoredAccessToken> get currentAccessToken async {
    String result = await channel.invokeMethod('currentAccessToken');
    if (result == null) return null;
    return StoredAccessToken._(json.decode(result));
  }

  /// Gets the user’s profile.
  /// 
  /// To use this method, the `"profile"` scope is required.
  /// 
  /// {@macro error_handling}
  Future<UserProfile> getProfile() async {
    String result = await channel.invokeMethod('getProfile');
    if (result == null) return null;
    return UserProfile._(json.decode(result));
  }

  ///  Refreshes the access token.
  /// 
  /// If the token refresh process finishes successfully, the refreshed access token will be
  /// automatically stored in user's device. You can wait for the result of this method or 
  /// use [currentAccessToken] to get it. 
  /// 
  /// Normally, you do not need to refresh the access token manually because any API call will 
  /// attempt to refresh the access token if necessary.
  /// 
  /// {@macro error_handling}
  Future<AccessToken> refreshToken() async {
    String result = await channel.invokeMethod('refreshToken');
    if (result == null) return null;
    return AccessToken._(json.decode(result));
  }

  /// Checks whether the stored access token is valid against to LINE auth server.
  /// 
  /// {@macro error_handling}
  Future<AccessTokenVerifyResult> verifyAccessToken() async {
    String result = await channel.invokeMethod('verifyAccessToken');
    if (result == null) return null;
    return AccessTokenVerifyResult._(json.decode(result));
  }

  /// Gets the friendship status of the user and the bot linked to your LINE Login channel.
  /// 
  /// To use this method, the `"profile"` scope is required.
  /// 
  /// {@macro error_handling}
  Future<BotFriendshipStatus> getBotFriendshipStatus() async {
    String result = await channel.invokeMethod('getBotFriendshipStatus');
    if (result == null) return null;
    return BotFriendshipStatus._(json.decode(result));
  }
}
