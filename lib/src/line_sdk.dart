part of flutter_line_sdk;

class LineSDK {
  static const MethodChannel _channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');
  
  static final LineSDK instance = LineSDK._();

  LineSDK._() {
    _channel.setMethodCallHandler(_callHandler);
  }

  Future<void> setup(String channelID, String universalLink) async {
    _channel.invokeMethod(
      'setup',
      <String, String>{
        'channelID': channelID, 
        'universalLink': universalLink
      }
    );
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
