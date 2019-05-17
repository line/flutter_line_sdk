import Flutter
import UIKit

import LineSDK

public class SwiftFlutterLineSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.linecorp/flutter_line_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLineSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("LINE SDK Version " + LineSDK.Constant.SDKVersion)
  }
}
