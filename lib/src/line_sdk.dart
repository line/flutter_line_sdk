part of flutter_line_sdk;

class LineSDK {
  static const MethodChannel _channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');
  
  static final LineSDK instance = LineSDK._();

  LineSDK._() {
    _channel.setMethodCallHandler(_callHandler);
  }

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

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> _callHandler(MethodCall call) async {
    switch (call.method) {

    }
  }
}
