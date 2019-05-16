#import "FlutterLineSdkPlugin.h"
#import <flutter_line_sdk/flutter_line_sdk-Swift.h>

@implementation FlutterLineSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLineSdkPlugin registerWithRegistrar:registrar];
}
@end
