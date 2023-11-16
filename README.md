# flutter_line_sdk

[![build](https://github.com/line/flutter_line_sdk/actions/workflows/build.yml/badge.svg)](https://github.com/line/flutter_line_sdk/actions/workflows/build.yml)

A [Flutter] plugin that lets developers access LINE's native SDKs in Flutter apps with [Dart].

The plugin helps you integrate LINE Login features in your app. You can redirect users to LINE or a web page where they log in with their LINE credentials. Example:

```dart
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void login() async {
    try {
        final result = await LineSDK.instance.login();
        setState(() {
            _userProfile = result.userProfile;
            // user id -> result.userProfile?.userId
            // user name -> result.userProfile?.displayName
            // user avatar -> result.userProfile?.pictureUrl
            // etc...
        });
    } on PlatformException catch (e) {
        // Error handling.
        print(e);
    }
}
```

For more examples, see the [example app](https://github.com/line/flutter_line_sdk/tree/master/example) and [API definitions].

## Prerequisites

From version 2.0, `flutter_line_sdk` supports [null safety](https://dart.dev/null-safety). If you are still seeking a legacy version without null safety, check [version 1.3.0](https://github.com/line/flutter_line_sdk/releases/tag/1.3.0).

- iOS 13.0 or later as the deployment target
- Android `minSdkVersion` set to 24 or higher (Android 7.0 or later)
- [LINE Login channel linked to your app](https://developers.line.biz/en/docs/line-login/getting-started/)

To access your LINE Login channel from a mobile platform, you need some extra configuration. In the [LINE Developers console][console], go to your LINE Login channel settings, and enter the below information on the **App settings** tab.

### iOS app settings

| Setting | Description |
|-------|---------|
| iOS bundle ID | Required. Bundle identifier of your app. In Xcode, find it in your **Runner** project settings, on the **General** tab. Must be lowercase, like `com.example.app`. You can specify multiple bundle identifiers by typing each one on a new line. |
| iOS universal link  | Optional. Set to the universal link configured for your app. For more information on how to handle the login process using a universal link, see [Universal Links support](https://developers.line.biz/en/docs/ios-sdk/swift/setting-up-project/#universal-link-support). |

### Android app settings

| Setting | Description |
|-------|---------|
| Android package name | Required. Application's package name used to launch the Google Play store. |
| Android package signature | Optional. You can set multiple signatures by typing each one on a new line. |
| Android scheme | Optional. Custom URL scheme used to launch your app. |

## Installation

### Adding flutter_line_sdk package

Use the standard way of adding this package to your Flutter app, as described in the [Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins/using-packages). The process consists of these steps:

1. Open the `pubspec.yaml` file in your app folder and, under `dependencies`, add `flutter_line_sdk:`.
2. Install it by running this in a terminal: `flutter pub get`

Now, the Dart part of `flutter_line_sdk` should be installed. Next, you need to set up LINE SDK for iOS and Android projects, respectively.

### Set up LINE SDK

#### iOS

Open the file `ios/Runner/Info.plist` in a text editor and insert this snippet just before the last `</dict>` tag:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Specify URL scheme to use when returning from LINE to your app. -->
      <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <!-- Specify URL scheme to use when launching LINE from your app. -->
  <string>lineauth2</string>
</array>
```

Because LINE SDK now requires iOS 13.0 or above to provide underlying native features, you must add this line in the `Runner` target in `ios/Podfile`:

```diff
target 'Runner' do
+ platform :ios, '13.0'

  use_frameworks!
  use_modular_headers!
  ...
```

#### Android

To ensure compatibility with the latest features, you need to update the `minSdk` version in your app's `build.gradle` file to `24` or higher. 

Here's how you can do it:

1. Open your app's `build.gradle` file.
2. Locate the `android` block, and within it, find the `defaultConfig` block.
3. In the `defaultConfig` block, replace the current `minSdk` value with `24`.

Here's a diff to show what your changes might look like:

```diff
android {
    defaultConfig {
-        minSdk flutter.minSdkVersion
+        minSdk 24
    }
}
```

### Importing and using

#### Setup

Import `flutter_line_sdk` to any place you want to use it in your project:

```dart
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
```

To use the package, you need to set up your channel ID. You can do this by calling the `setup` method, for example in the `main` function:

```diff
- void main() => runApp(MyApp());
+ void main() {
+   WidgetsFlutterBinding.ensureInitialized();
+   LineSDK.instance.setup("${your_channel_id}").then((_) {
+     print("LineSDK Prepared");
+   });
+   runApp(App());
+ }
```

This is merely an example. You can call `setup` any time you want, provided you call it exactly once, before calling any other LINE SDK methods.

To help you get started with this package, we list several basic usage examples below. All available `flutter_line_sdk` methods are documented on the [Dart Packages][API Definitions] site.

#### Login

Now you are ready to let your user log in with LINE.

Get the login result by assigning the value of `Future<LoginResult>` to a variable.
To handle errors gracefully, wrap the invocation in a `try...on` statement:

```dart
void _signIn() async {
  try {
    final result = await LineSDK.instance.login();
    // user id -> result.userProfile?.userId
    // user name -> result.userProfile?.displayName
    // user avatar -> result.userProfile?.pictureUrl
  } on PlatformException catch (e) {
    _showDialog(context, e.toString());
  }
}
```

By default, `login` uses `["profile"]` as its scope. In this case, when login is done, you have a `userProfile` value in login `result`. 
If you need other scopes, pass them in a list to `login`. See the [Scopes](https://developers.line.biz/en/docs/line-login/web/integrate-line-login/#scopes) documentation for more.

```dart
final result = await LineSDK.instance.login(
    scopes: ["profile", "openid", "email"]
);
// user email, if user set it in LINE and granted your request.
final userEmail = result.accessToken.email;
```

> Although it might be useless, if you do not contain a `"profile"` scope, `userProfile` will be a null value.

#### Logout

```dart
try {
  await LineSDK.instance.logout();
} on PlatformException catch (e) {
  print(e.message);
}
```

#### Get user profile

```dart
try {
  final result = await LineSDK.instance.getProfile();
  // user id -> result.userId
  // user name -> result.displayName
  // user avatar -> result.pictureUrl
} on PlatformException catch (e) {
  print(e.message);
}
```

#### Get current stored access token

```dart
try {
  final result = await LineSDK.instance.currentAccessToken;
  // access token -> result?.value
} on PlatformException catch (e) {
  print(e.message);
}
```

> If the user isn't logged in, it returns a `null`. A valid `result` of this method doesn't necessarily mean the access 
> token itself is valid. It may have expired or been revoked by the user from another device or LINE client.

#### Verify access token with LINE server

```dart
try {
  final result = await LineSDK.instance.verifyAccessToken();
  // result.data is accessible if the token is valid.
} on PlatformException catch (e) {
  print(e.message);
  // token is not valid, or any other error.
}
```

#### Refresh current access token

```dart
try {
  final result = await LineSDK.instance.refreshToken();
  // access token -> result.value
  // expires duration -> result.expiresIn
} on PlatformException catch (e) {
  print(e.message);
}
```

Normally, you don't need to refresh access tokens manually, because any API call in LINE SDK will try to refresh the access token automatically when necessary. 
**We do not recommend refreshing access tokens yourself.** 
It's generally easier, more secure, and more future-proof to let the LINE SDK manage access tokens automatically.

### Error handling

All APIs can throw a `PlatformException` with error `code` and a `message`. Use this information to identify when an error happens inside the native SDK. 

Error codes and messages will vary between iOS and Android. Be sure to read the error definition on [iOS](https://developers.line.biz/en/reference/ios-sdk-swift/Enums/LineSDKError.html) and [Android](https://developers.line.biz/en/reference/android-sdk/reference/com/linecorp/linesdk/LineApiError.html) to provide better error recovery and user experience on different platforms.

## Contributing

If you believe you found a vulnerability or you have an issue related to security, please **DO NOT** open a public issue. Instead, send us an email at [dl_oss_dev@linecorp.com](mailto:dl_oss_dev@linecorp.com).

Before contributing to this project, please read [CONTRIBUTING.md].

<!-- Links and references -->
[Flutter]: https://flutter.dev/
[Dart]: https://dart.dev/
[API definitions]: https://pub.dev/documentation/flutter_line_sdk/latest/flutter_line_sdk/flutter_line_sdk-library.html
[console]: https://developers.line.biz/console/
[Cocoa Touch]: https://en.wikipedia.org/wiki/Cocoa_Touch
[CONTRIBUTING.md]: https://github.com/line/flutter_line_sdk/blob/master/CONTRIBUTING.md
