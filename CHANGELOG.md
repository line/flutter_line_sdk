## 2.3.6

### Fixed

* Upgrade the wrapped Android LINE SDK version. Algin its `minSdk` and `compileSdk` to the native SDK. [#87](https://github.com/line/flutter_line_sdk/pull/87/files)

## 2.3.5

### Fixed

* Update license holder name in all source code files. Now LY Corporation is the license holder of LINE SDK Swift. The license content and terms itself is not changed so you can still use the SDK under the same condition as before. [#86](https://github.com/line/flutter_line_sdk/pull/86)
* Increase the minimum deploy version to iOS 13.0 and Android API Level 24 (Android 7.0) to match modern development requirements.

## 2.3.4

### Fixed

* Some terminology that is used in API references for legal purposes.

## 2.3.3

### Fixed

* The deprecated `jcenter` repository is removed from the Android part. Now this project uses the latest native LINE SDK on `mavenCentral`. [#80](https://github.com/line/flutter_line_sdk/pull/80)
* Loosen the environment requirement of `dart` SDK to contain dart 3.x. [#82](https://github.com/line/flutter_line_sdk/pull/82)

## 2.3.2

### Fixed

* Upgrade Kotlin version and compile SDK version for Android native part. [#73](https://github.com/line/flutter_line_sdk/pull/73)

## 2.3.1

### Fixed

* Algin the deploy target of iOS with LINE SDK Swift to iOS 11.0. This allows the LINE Flutter SDK continue to compile with the latest LINE SDK. [#65](https://github.com/line/flutter_line_sdk/issues/65)

## 2.3.0

### Added

* Add support for building as static library in the hosting project. By default Flutter uses plugins as framework on iOS, but you are now also free to remove `use_framework!` in Flutter's Podfile and LINE SDK won't compliant about it anymore. [#62](https://github.com/line/flutter_line_sdk/pull/62)

### Fixed

* An issue in the example app that crashes when the user is not setting a valid status message. [#63](https://github.com/line/flutter_line_sdk/pull/63)

## 2.2.0

### Added

* Now you can get the user email address through the `email` getter in `AccessToken` once the user grant you the permission. [#58](https://github.com/line/flutter_line_sdk/pull/58)

### Fixed

* Modernize project settings and upgrade Dark SDK version.

## 2.1.0

### Added

* A new `idTokenNonce` in `LoginOption` to allow a customize nonce set in the ID token. You can use it to implement the [Secure Login](https://developers.line.biz/zh-hant/docs/line-login/secure-login-process/#using-openid-to-register-new-users) in guide. [#50](https://github.com/line/flutter_line_sdk/pull/50)

## 2.0.0

### Added

* Support for Dart null safety. [#39](https://github.com/line/flutter_line_sdk/pull/39)

## 1.3.0

### Added

* A new `idToken` field in `AccessToken` to help decoding and getting the ID Token in a dictionary format. [#33](https://github.com/line/flutter_line_sdk/pull/33)
* Fully support for Flutter Add to App feature by adapting the new Flutter v2 plugin model. [#34](https://github.com/line/flutter_line_sdk/pull/34)

### Fixed

* Now `idTokenRaw` on Android returns correct raw token string instead of a decoded JSON string, which aligns the behavior as on iOS. [#31](https://github.com/line/flutter_line_sdk/issues/31)
* Upgrade the `minSdkVersion` for Android platform to 21, which matches the LINE client app on the same platform.

## 1.2.11

### Fixed

* Align `minSdkVersion` of Android part to the same version (API Level 18) as the native LINE SDK Android.
* A issue which causes example app crashing in Android versions earlier than 5.0 (API Level 21).

## 1.2.10

### Fixed

* The `pictureUrlSmall` of user profile now returns the correct smaller version of profile image now. [#25](https://github.com/line/flutter_line_sdk/pull/25)

## 1.2.9

### Fixed

* Now customized scope string are supported for Android. [#23](https://github.com/line/flutter_line_sdk/pull/23)

## 1.2.8

### Fixed

* A regression that `getCurrentAccessToken` returns error instead of a `null` value on Android. [#22](https://github.com/line/flutter_line_sdk/pull/22)

## 1.2.7

### Fixed

* An issue on Android that handler be called twice in some cases. [#18](https://github.com/line/flutter_line_sdk/issues/18)
* The `AccessToken.expiresIn` now returns value of seconds on Android too. Behaviors on both iOS and Android align to the documentation. [#20](https://github.com/line/flutter_line_sdk/pull/20)

## 1.2.6

### Fixed

* Hot restarting will no longer cause a connection lost on iOS simulator and device. [#17](https://github.com/line/flutter_line_sdk/pull/17)

## 1.2.5

### Fixed

* Remove version specified annotation. Now Android SDK can be built without problem. [#15](https://github.com/line/flutter_line_sdk/pull/15)

## 1.2.4

### Fixed

* A problem that some result in model types are obfuscated when building with Release configuration on Android. [#12](https://github.com/line/flutter_line_sdk/pull/12)

## 1.2.3

### Fixed

* An issue that some classes are stripped unexpectedly when building with release configuration. [#10](https://github.com/line/flutter_line_sdk/issues/10)

## 1.2.2

### Fixed

* An issue that example app crashes when using Flutter SDK 1.12.13. [#38464@flutter](https://github.com/flutter/flutter/pull/38464)

## 1.2.1

### Fixed

* Now `currentAccessToken` returns `null` instead of throwing an error when there is no access token stored locally. This behavior now matches what it is done on iOS. [#9](https://github.com/line/flutter_line_sdk/pull/9)

## 1.2.0

### Added

* A parameter for Android to specify the activity request code when login. [#4](https://github.com/line/flutter_line_sdk/issues/4)

## 1.1.0

### Added

* Add `idTokenNonce` to LoginResult. This value can be used against the ID token verification API as a parameter.

## 1.0.3

### Fixed

* Improve reference rendering for async APIs.

## 1.0.2

### Fixed

* Explicitly declare the main dispatcher to run coroutine on Android, which is compatible with changes in the [latest flutter](https://github.com/flutter/flutter/issues/34993). [#2](https://github.com/line/flutter_line_sdk/issues/2)

## 1.0.1

### Fixed

* Internal code formatting and better structure.
* Improve API reference.

## 1.0.0

* Initial release of flutter plugin for LINE SDK.
