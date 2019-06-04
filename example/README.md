# flutter_line_sdk Example

Demonstrates how to use the flutter_line_sdk plugin.

## Getting Started

To have a quick look at the example app, just execute `flutter run` under this "example" folder to build it with a simulator target.

By default, this example project is using a public sample channel of LINE SDK. If you want to confirm it on a real device or your own channel, you need:

1. Register and own a channel from [LINE Developers Site](https://developers.line.biz/en/) and setup everything in the LINE Developers console. For more, read the [Getting started with LINE Login](https://developers.line.biz/en/docs/line-login/getting-started/) guide.

2. Modify the channel ID in "lib/main.dart" to the ID you want to use.

3. Modify the iOS Runner project build settings in Xcode to set your app's `PRODUCT_BUNDLE_IDENTIFIER`, making it match the setting of your channel.

4. Modify the Android project build settings "android/app/build.gradle" to set your app's `applicationId`, making it match the setting of your channel.

Now you should be able to try to run the example app with your own channel and devices.
