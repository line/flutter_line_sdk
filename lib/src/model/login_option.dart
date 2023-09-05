//
//  login_option.dart
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

/// Options related to LINE login process.
class LoginOption {
  /// Default request code that LINE login activity (in Android Platform) will be called with.
  static const int DEFAULT_ACTIVITY_RESULT_REQUEST_CODE = 8192;

  /// Enable to use web authentication flow instead of LINE app-to-app authentication flow.
  ///
  /// By default, LINE SDK will try to use the LINE app to log in. Set the value to `true` to use
  /// the web authentication flow instead.
  bool onlyWebLogin;

  /// Strategy to use for displaying "add the LINE Official Account as friend" option on consent screen:
  ///
  /// - `normal`: A button for adding the LINE Official Account as a friend is displayed on the consent screen.
  /// - `aggressive`: After the user grants the requested permissions on the consent screen, a new
  /// screen opens asking the user to add the LINE Official Account as a friend.
  String botPrompt;

  /// Request code that LINE login activity will be called with.
  int requestCode;

  /// Sets the nonce value for ID token verification. This value is used when requesting user authorization
  /// with `.openID` permission to prevent replay attacks to your backend server. If not set, LINE SDK will
  /// generate a random value as the token nonce. Whether set or not, LINE SDK verifies against the nonce value
  /// in received ID token locally.
  String? idTokenNonce;

  LoginOption(this.onlyWebLogin, this.botPrompt,
      {this.requestCode = DEFAULT_ACTIVITY_RESULT_REQUEST_CODE});
}
