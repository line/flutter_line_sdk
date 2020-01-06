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
