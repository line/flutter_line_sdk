//
//  login_result.dart
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

/// The result of a successful login, containing basic user information and an access token.
class LoginResult {
  LoginResult._(this._data) {
    _accessToken = AccessToken._(_data['accessToken']);
    final userData = _data['userProfile'];
    if (userData == null) {
      _userProfile = null;
    } else {
      _userProfile = UserProfile._(userData);
    }
  }

  final Map<String, dynamic> _data;

  /// Raw data of the response in a `Map` representation.
  Map<String, dynamic> get data => _data;

  late AccessToken _accessToken;
  late UserProfile? _userProfile;

  /// The [AccessToken] object obtained during login.
  AccessToken get accessToken => _accessToken;
  List<String> get scopes => (_data['scope'] ?? "").split(' ');

  /// The [UserProfile] object obtained during login.
  ///
  /// It contains the user ID, display name, and more.
  ///
  /// This object exists only if the `"profile"` scope was included in [LineSDK.login].
  UserProfile? get userProfile => _userProfile;

  /// Indicates that the friendship status between the user and the LINE Official Account changed during login.
  ///
  /// This value is `null` if `BotPrompt` was not specified in [LoginOption]. For more
  /// information, see
  /// [Linking a LINE official account with your LINE Login channel](https://developers.line.me/en/docs/line-login/web/link-a-bot/).
  bool? get isFriendshipStatusChanged => _data['friendshipStatusChanged'];

  /// The `nonce` value when requesting ID Token during login process. Use this value as a parameter when you
  /// verify the ID Token against the LINE server. This value is `null` if `openid` permission is not requested.
  String? get idTokenNonce => _data['IDTokenNonce'];
}
