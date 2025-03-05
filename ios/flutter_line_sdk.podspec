Pod::Spec.new do |s|
  s.name             = 'flutter_line_sdk'
  s.version          = '2.5.1'
  s.summary          = 'A Flutter plugin for using the LINE SDKs with Dart in Flutter apps.'
  s.description      = <<-DESC
A Flutter plugin using the LINE SDKs with Dart in Flutter apps. It provides the channel to use the native LINE SDK for
Swift.
                       DESC
  s.homepage         = 'https://developers.line.biz'
  s.license          = { :type => 'Apache', :file => '../LICENSE' }
  s.author           = { 'LINE' => 'dl_linesdk_cocoapods@linecorp.com' }
  s.source           = { :http => 'https://github.com/line/flutter_line_sdk' }
  s.source_files     = 'flutter_line_sdk/Sources/flutter_line_sdk/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'LineSDKSwift', '~> 5.3'

  s.swift_version         = "4.2"
  s.swift_versions        = ['4.2', '5.0']

  s.ios.deployment_target = '13.0'
end
