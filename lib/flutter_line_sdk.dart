//
//  flutter_line_sdk.dart
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

/// A Flutter plugin for allowing users to use the native LINE SDKs with Dart in Flutter apps.
/// 
/// This package is a Dart/Flutter compatible wrapper for using the native LINE SDK Swift and 
/// LINE SDK Android in your flutter app. To use this plugin and LINE related APIs, you need to 
/// register a channel on [LINE Developers Site](https://developers.line.biz/en/) first and setup 
/// everything in the LINE Developers console. 
/// 
/// For more, read the [Getting started with LINE Login](https://developers.line.biz/en/docs/line-login/getting-started/) 
/// guide.
/// 
/// As an overview, after you install this flutter_line_sdk package, you still need to config 
/// your Xcode Runner project as well as the Android build.gradle file with your channel i
/// nformation. Please read the "Linking your app to your channel" section for both 
/// [iOS](https://developers.line.biz/en/docs/ios-sdk/swift/setting-up-project/) and 
/// [Android](https://developers.line.biz/en/docs/android-sdk/integrate-line-login/) to setup 
/// your project.
/// 
/// After that, you can use an `import` directive to include flutter_line_sdk to your project and 
/// call `await LineSDK.instance.setup($channel_id);` to setup the plugin. For the most basic use case, you can 
/// invoke the `login` method to make your users login with their LINE accounts.
/// 
library flutter_line_sdk;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

part 'src/line_sdk.dart';
part 'src/model/access_token.dart';
part 'src/model/access_token_verify_result.dart';
part 'src/model/login_option.dart';
part 'src/model/login_result.dart';
part 'src/model/stored_access_token.dart';
part 'src/model/user_profile.dart';
part 'src/model/bot_friendship_status.dart';