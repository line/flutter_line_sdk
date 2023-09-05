//
//  user_profile.dart
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

/// The user profile used in LineSDK.
class UserProfile {
  UserProfile._(this._data);

  final Map<String, dynamic> _data;

  /// Raw data of the response in a `Map` representation.
  Map<String, dynamic> get data => _data;

  /// The display name of the current authorized user.
  String get displayName => _data['displayName'];

  /// The user ID of the current authorized user.
  String get userId => _data['userId'];

  /// The status message of the current authorized user.
  ///
  /// Empty or `null` if the user hasn't set a status message.
  String? get statusMessage => _data['statusMessage'];

  /// URL of current authorized user's profile image.
  ///
  /// Empty or `null` if the user hasn't set a profile image.
  String? get pictureUrl => _data['pictureUrl'];

  /// URL of current authorized user's large profile image.
  ///
  /// `null` if the user hasn't set a profile image.
  String? get pictureUrlLarge {
    final url = pictureUrl;
    if (url != null && url != '') {
      return url + '/large';
    }
    return null;
  }

  /// URL of current authorized user's small profile image.
  ///
  /// `null` if the user hasn't set a profile image.
  String? get pictureUrlSmall {
    final url = pictureUrl;
    if (url != null && url != '') {
      return url + '/small';
    }
    return null;
  }
}
