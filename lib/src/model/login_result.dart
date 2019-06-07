//
//  login_result.dart
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

part of flutter_line_sdk;

/// The result of a successful login which contains basic user information and access token.
class LoginResult {
  LoginResult._(this._data) {
    _accessToken = AccessToken._(_data['accessToken']);
    _userProfile = UserProfile._(_data['userProfile']);
  }

  final Map<String, dynamic> _data;

  /// Raw data of the response in a `Map` representation.
  Map<String, dynamic> get data => _data;
  
  AccessToken _accessToken;
  UserProfile _userProfile;

  /// The [AccessToken] object obtained by the login process.
  AccessToken get accessToken => _accessToken;
  List<String> get scopes => _data['scope'].split(" ");

  /// The [UserProfile] object obtained during the login process. 
  /// 
  /// It contains the user ID, display name, and so on.
  /// 
  /// This value exists only when the "profile" scope is set in [LineSDK.login].
  UserProfile get userProfile => _userProfile;

  /// Indicates that the friendship status between the user and the bot changed during the login.
  /// 
  /// This value is non-nil only if the `BotPrompt` is specified as part of the option when the
  /// user logs in. For more information, see "Linking a bot with your LINE Login channel" at
  /// https://developers.line.me/en/docs/line-login/web/link-a-bot/.
  bool get isFriendshipStatusChanged => _data['friendshipStatusChanged'];
}