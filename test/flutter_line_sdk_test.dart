import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.linecorp/flutter_line_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LineSDK.platformVersion, '42');
  });
}
