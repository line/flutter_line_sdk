part of flutter_line_sdk;

class LineSDK {
  static const MethodChannel _channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');
  
  static final LineSDK instance = LineSDK._();

  LineSDK._();

  Future<void> setup(String channelId, {String universalLink}) async {
    await _channel.invokeMethod(
      'setup',
      <String, String>{
        'channelId': channelId, 
        'universalLink': universalLink
      }
    );
  }

  Future<LoginResult> login(
    { List<String> scopes = const ["profile"], 
      LoginOption option
    }) async 
  { 
    String result = await _channel.invokeMethod(
      'login',
      <String, dynamic>{
        'scopes': scopes,
        'onlyWebLogin': option?.onlyWebLogin,
        'botPrompt': option?.botPrompt
      }
    );
    return LoginResult._(json.decode(result));
  }

  Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  Future<StoredAccessToken> get currentAccessToken async {
    String result = await _channel.invokeMethod('currentAccessToken');
    return StoredAccessToken._(json.decode(result));
  }

  Future<UserProfile> getProfile() async {
    String result = await _channel.invokeMethod('getProfile');
    return UserProfile._(json.decode(result));
  }

  Future<AccessToken> refreshToken() async {
    String result = await _channel.invokeMethod('refreshToken');
    return AccessToken._(json.decode(result));
  }

  Future<AccessTokenVerifyResult> verifyAccessToken() async {
    String result = await _channel.invokeMethod('verifyAccessToken');
    return AccessTokenVerifyResult._(json.decode(result));
  }

  Future<BotFriendshipStatus> getBotFriendshipStatus() async {
    String result = await _channel.invokeMethod('getBotFriendshipStatus');
    return BotFriendshipStatus._(json.decode(result));
  }
}
