#import "FlutterLineSdkPlugin.h"

#if __has_include(<flutter_line_sdk/flutter_line_sdk-Swift.h>)
#import <flutter_line_sdk/flutter_line_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_line_sdk-Swift.h"
#endif

@implementation FlutterLineSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLineSdkPlugin registerWithRegistrar:registrar];
}
@end
