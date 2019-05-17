import Flutter
import UIKit

import LineSDK

public class SwiftFlutterLineSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.linecorp/flutter_line_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLineSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setup":
      let args = call.arguments as! [String: Any]
      let channelId = args["channelId"] as! String
      let universalLinkURL = (args["universalLink"] as? String)
        .map { URL(string: $0) } ?? nil
      LoginManager.shared.setup(channelID: channelId, universalLinkURL: universalLinkURL)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
  {
    return LoginManager.shared.application(application, open: url, options: options)
  }

  public func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]) -> Void) -> Bool
  {
    return LoginManager.shared.application(application, open: userActivity.webpageURL)
  }
}
