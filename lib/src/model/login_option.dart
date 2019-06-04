//
//  login_option.dart
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

/// Options can be used for logging in to the LINE Platform.
class LoginOption {
  /// Uses the web authentication flow instead of the LINE app-to-app authentication flow.
  /// 
  /// By default, LINE SDK will check and prefer to use LINE app to login. 
  /// Set this to `true` if you want to skip LINE app but use the web authentication flow.
  bool onlyWebLogin;

  /// Strategy used to show "adding bot as friend" option on the consent screen.
  /// 
  /// This has two possible value for now:
  /// 
  /// - "normal": Includes an option to add a bot as friend on the consent screen.
  /// - "aggressive": Opens a new screen to add a bot as a friend after the user agrees to 
  /// the permissions on the consent screen.
  String botPrompt;

  LoginOption(this.onlyWebLogin, this.botPrompt);
}