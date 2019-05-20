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
    if (result == null) return null;
    return LoginResult._(json.decode(result));
  }

  Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  Future<StoredAccessToken> get currentAccessToken async {
    String result = await _channel.invokeMethod('currentAccessToken');
    if (result == null) return null;
    return StoredAccessToken._(json.decode(result));
  }

  Future<UserProfile> getProfile() async {
    String result = await _channel.invokeMethod('getProfile');
    if (result == null) return null;
    return UserProfile._(json.decode(result));
  }

  Future<AccessToken> refreshToken() async {
    String result = await _channel.invokeMethod('refreshToken');
    if (result == null) return null;
    return AccessToken._(json.decode(result));
  }

  Future<AccessTokenVerifyResult> verifyAccessToken() async {
    String result = await _channel.invokeMethod('verifyAccessToken');
    if (result == null) return null;
    return AccessTokenVerifyResult._(json.decode(result));
  }

  Future<BotFriendshipStatus> getBotFriendshipStatus() async {
    String result = await _channel.invokeMethod('getBotFriendshipStatus');
    if (result == null) return null;
    return BotFriendshipStatus._(json.decode(result));
  }
}
