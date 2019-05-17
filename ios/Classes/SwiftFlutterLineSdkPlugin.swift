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
    case "login":
      let args = call.arguments as! [String: Any]
      let scopes = (args["scopes"] as? [String])?.map { LoginPermission(rawValue: $0) } ?? [.profile]
      let onlyWebLogin = (args["onlyWebLogin"] as? Bool) ?? false

      var options: LoginManagerOptions = []
      if onlyWebLogin {
        options = .onlyWebLogin
      }

      if let botPrompt = args["botPrompt"] as? String {
        switch botPrompt {
        case "aggressive": options.insert(.botPromptAggressive)
        case "normal": options.insert(.botPromptNormal)
        default: break
        }
      }

      LoginManager.shared.login(
        permissions: Set(scopes),
        in: nil,
        options: options) { r in
          switch r {
          case .success(let value):
            let s = try! JSONEncoder().encode(value)
            result(String(data: s, encoding: .utf8))
          case .failure(let error):
            result(error.flutterError)
          }
      }
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

extension LineSDKError {
  var flutterError: FlutterError {
    return FlutterError(code: String(errorCode), message: errorDescription, details: errorUserInfo)
  }


}
