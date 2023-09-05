//
//  stored_access_token.dart
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

/// The access token stored on the user's device.
class StoredAccessToken {
  StoredAccessToken._(this._data);

  final Map<String, dynamic> _data;

  Map<String, dynamic> get data => _data;

  /// The access token, as a string.
  String get value => _data['access_token'];

  /// Expiration time of the token, in seconds, **at time of creation**.
  ///
  /// This value is never updated. To get the current [expiresIn] time for a token, call
  /// `LineSDK.verifyAccessToken()`.
  num get expiresIn => _data['expires_in'];
}
