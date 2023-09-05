import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Models', () {
    test('access_token should be parsed correctly', () {});
  });

  const MethodChannel channel = MethodChannel('com.linecorp/flutter_line_sdk');

  const dummyAccessToken = """
    {
      "access_token":"123",
      "refresh_token":"abc",
      "token_type":"Bearer",
      "scope":"profile abcd",
      "id_token": "id_token",
      "expires_in":2592000
    }
  """;
  const dummyProfile = """
    {
      "userId":"abcd",
      "displayName":"Brown",
      "pictureUrl":"https://example.com/abc",
      "statusMessage":"Hello, LINE!"
    }
  """;

  const dummyVerifyToken = """
    {
      "scope":"profile",
      "client_id":"1440057261",
      "expires_in":2591659
    }
  """;

  const dummyGetBotFriendshipStatus = """
    {
      "friendFlag": true
    }
  """;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'setup':
          return null;
        case 'login':
          return '{"accessToken": $dummyAccessToken, "userProfile": $dummyProfile}';
        case 'getProfile':
          return dummyProfile;
        case 'refreshToken':
          return dummyAccessToken;
        case 'verifyAccessToken':
          return dummyVerifyToken;
        case 'getBotFriendshipStatus':
          return dummyGetBotFriendshipStatus;
        default:
          return null;
      }
    });
  });

  test('setup', () async {
    await LineSDK.instance.setup('123');
  });

  test('login', () async {
    final v = await LineSDK.instance.login();
    expect(v.accessToken.value, '123');

    expect(v.accessToken.scopes.length, 2);
    expect(v.accessToken.scopes.contains('profile'), true);
    expect(v.accessToken.scopes.contains('abcd'), true);

    expect(v.userProfile?.userId, 'abcd');
  });

  test('user profile', () async {
    final v = await LineSDK.instance.getProfile();
    expect(v.userId, 'abcd');
  });

  test('refresh token', () async {
    final v = await LineSDK.instance.refreshToken();
    expect(v.value, '123');
  });

  test('verify access token', () async {
    final v = await LineSDK.instance.verifyAccessToken();
    expect(v.channelId, '1440057261');
  });

  test('get LINE Official Account friendship status', () async {
    final v = await LineSDK.instance.getBotFriendshipStatus();
    expect(v.isFriend, true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
