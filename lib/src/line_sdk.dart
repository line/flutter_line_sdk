part of flutter_line_sdk;

class LineSDK {
  static const MethodChannel _channel =
      const MethodChannel('com.linecorp/flutter_line_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
