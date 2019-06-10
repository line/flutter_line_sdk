# flutter_line_sdk

A Flutter plugin for allowing users to use the native LINE SDKs with Dart in Flutter apps.

It provides a quick way to integrate LINE Login features to your app. Once installed, you can navigate your users to use 
LINE app or a web page to login with their LINE account. A quick example usage as below:

```dart
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void login() async {
    try {
        final result = await LineSDK.instance.login();
        setState(() {
            _userProfile = result.userProfile;
            // user id -> result.userProfile.userId
            // user name -> result.userProfile.displayName
            // user avatar -> result.userProfile.pictureUrl
            // etc...
        });
    } on PlatformException catch (e) {
        // Error handling.
        print(e);
    }
}
```

For more examples, see the [example app](https://github.com/line/flutter_line_sdk/tree/master/example) and the related [API definitions](#).

## Prerequisites

- iOS 10.0 or later as the deployment target.
- Android `minSdkVersion` set to 17 or higher (Android 4.2 or later).

To use the LINE SDK with your Flutter app, you need to have a valid LINE Channel bounded to your app. 
If you do not have one yet, please follow the [Getting started with LINE Login](https://developers.line.biz/en/docs/line-login/getting-started/)
to create your channel.

You also need some additional setup when you want to use the channel on a mobile platform.
Once you have created a channel, go to the "App settings" page of the console and complete the following fields.

For iOS:

- iOS bundle ID: Bundle identifier of your app found in the "General" tab in your "Runner" Xcode project settings. Must be lowercase. For example, `com.example.app`. You can specify multiple bundle identifiers by entering each one on a new line.
- iOS scheme: Set to `line3rdp.` followed by the bundle identifier. For example, if your bundle identifier is `com.example.app`, set the iOS scheme to `line3rdp.com.example.app`. Only one iOS scheme can be specified.
- iOS universal link: Optional. Set to the universal link configured for your app. For more information on how to handle the login process using a universal link, see [Universal Links support](https://developers.line.biz/en/docs/ios-sdk/swift/setting-up-project/#universal-link-support).

For Android:

- Android package name: Required. Application's package name used to launch the Google Play store.
- Android package signature: Optional. You can set multiple signatures by entering each one on a new line.
- Android scheme: Optional. Custom URL scheme used to launch your app.

## Installation

### Adding flutter_line_sdk package

Please just follow the common way to add this package to your Flutter app. You can find information on this topic in the [Using packages](https://flutter.dev/docs/development/packages-and-plugins/using-packages) page of Flutter documentation.

More specifically, you need to follow these steps:

1. Open the `pubspec.yaml` file located inside your app folder, and add `flutter_line_sdk:` under the `dependencies` section.
2. Install it. From a terminal, run `flutter pub get`.

Now, the dart part of `flutter_line_sdk` should be installed. Following, you need to setup LINE SDK for iOS and Android project respectively.

### Setup LINE SDK

#### iOS

Open the `ios/Runner/Info.plist` file in your app project with a text editor, insert the following snippet just before the last `</dict>` tag:

```diff
+  <key>CFBundleURLTypes</key>
+  <array>
+    <dict>
+      <key>CFBundleTypeRole</key>
+      <string>Editor</string>
+      <key>CFBundleURLSchemes</key>
+      <array>
+        <!-- Specify URL scheme to use when returning from LINE to your app. -->
+        <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
+      </array>
+    </dict>
+  </array>
+  <key>LSApplicationQueriesSchemes</key>
+  <array>
+    <!-- Specify URL scheme to use when launching LINE from your app. -->
+    <string>lineauth2</string>
+  </array>
</dict>
</plist>
```

Since LINE SDK now requires iOS 10.0 or above, and it uses Cocoa Framework to provide underlying native features, you need to add these lines in the `Runner` target in the `ios/Podfile`:

```diff
target 'Runner' do
+  use_frameworks!
+  platform :ios, '10.0'
```

#### Android

### Importing and using

Importing `flutter_line_sdk` to any place you want to use it in your project:

```dart
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
```

You need to setup your channel information first. A recommended place is in the `main` function:

```diff
- void main() => runApp(MyApp());
+ void main() async {
+   await LineSDK.instance.setup("your_channel_id");
+   runApp(App());
+ }
```

Or you can find any other place you'd like to call it. But remember it is required to be called once and only once before you use any other methods in LINE SDK.

To help you get started with this package quickly, we list some basic usage examples below. `flutter_line_sdk` is fully and well documented and you can find the details in our beautiful [dart style doc site](#).

#### Login

Now you are ready to let your user login with LINE. To get the login result, assign the `Future<LoginResult>` value to a variable.
Keep in mind that wrap the invocation in a `try...on` statement and handle the error gracefully:

```dart
void _signIn() async {
  try {
    final result = await LineSDK.instance.login();
    // user id -> result.userProfile.userId
    // user name -> result.userProfile.displayName
    // user avatar -> result.userProfile.pictureUrl
  } on PlatformException catch (e) {
    _showDialog(context, e.toString());
  }
}
```

By default, `login` will use `["profile"]` as its scope. If you need other scopes, pass them in a list to `login`. See the [Scopes](https://developers.line.biz/en/docs/line-login/web/integrate-line-login/#scopes) documentation for more.

```dart
final result = await LineSDK.instance.login(
    scopes: ["profile", "openid", "email"]);
```

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

### Refresh current access token

```dart
try {
    final result = await LineSDK.instance.refreshToken();
    // acceess token -> result.value
    // expires duration -> result.expiresIn
} on PlatformException catch (e) {
    print(e.message);
}
```

## Contributing

If you believe you have discovered a vulnerability or have an issue related to security, please **DO NOT** open a public issue. Instead, send us a mail to [dl_oss_dev@linecorp.com](mailto:dl_oss_dev@linecorp.com).

For contributing to this project, please see [CONTRIBUTING.md](https://github.com/line/line-sdk-ios-swift/blob/master/CONTRIBUTING.md).