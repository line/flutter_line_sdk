//
//  access_token.dart
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

/// An access token used to access the LINE Platform.
///
/// Most API calls to the LINE Platform require an access token as evidence of successful
/// authorization. A valid access token is issued after the user grants your app the
/// permissions that your app requests. An access token is bound to permissions (scopes)
/// that define which API endpoints you can access. Choose the permissions for your
/// channel in the LINE Developers site and set them in the login method used in your app.
///
/// An access token expires after a certain period. [expiresIn] specifies the amount of time
/// until the token expires, counting from the moment of issue.
///
/// By default, the LINE SDK stores access tokens in a secure place on the device running
/// your app and obtains authorization when you access the LINE Platform through the
/// framework request methods.
///
/// Don't try to create an access token yourself. You can get the stored access token with
/// [LineSDK.currentAccessToken].
class AccessToken {
  AccessToken._(this._data);

  final Map<String, dynamic> _data;

  /// Raw data of the response in a `Map` representation.
  Map<String, dynamic> get data => _data;

  /// The value of the access token.
  String get value => _data['access_token'];

  /// Number of seconds until the access token expires,
  /// counting from when the server issued the token.
  num get expiresIn => _data['expires_in'];

  /// The raw string value of the ID token bound to the access token. It is a Base64 URL encoded string
  /// which follows specification of JSON Web Token (JWT). If you need to access a field value in the
  /// ID Token, use the `idToken` getter.
  ///
  /// The value exists only if the access token is obtained with the `openID`
  /// permission. Otherwise, `null` is returned.
  String? get idTokenRaw => _data['id_token'];

  Map<String, dynamic>? _idToken;

  /// The `Map<String, dynamic>` representation of the received ID Token.
  /// This getter converts the received `idTokenRaw` to a dictionary format if it exists.
  ///
  /// If you are not applying an ID Token when login, `null` is returned.
  Map<String, dynamic>? get idToken {
    // Lazy variable.
    if (_idToken != null) {
      return _idToken;
    }
    if (idTokenRaw == null) {
      return null;
    }

    final parts = idTokenRaw!.split('.');
    // Malformed JWT format.
    if (parts.length != 3) {
      return null;
    }

    // dart:convert is a bit pedantic and it requires a normalized format of base 64,
    // even encoded by base 64 url.
    // https://github.com/dart-lang/sdk/issues/39510
    final normalizedPayload = base64.normalize(parts[1]);
    final jsonPayload = utf8.decode(base64Url.decode(normalizedPayload));
    _idToken = jsonDecode(jsonPayload);
    return _idToken;
  }

  /// The valid scopes bound to this access token.
  List<String> get scopes => _data['scope'].split(' ');

  /// The expected authorization type when this token is used in a request
  /// header. Fixed to `Bearer` for now.
  String get tokenType => _data['token_type'];

  /// The email address set by the user. This value only exists when `idToken` is
  /// valid and the user has set the email address in LINE and agreed to share it
  /// with you. Both "openid" and "email" scopes are required to get the user email.
  ///
  /// If you are not applying an ID Token when login, or the user does not set
  /// the email for the LINE account, or the user refuses to grant your access,
  /// `null` is returned.
  String? get email => idToken?['email'];
}
