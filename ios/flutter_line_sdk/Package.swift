// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_line_sdk",
    platforms: [
        .iOS("15.0"),
    ],
    products: [
        .library(name: "flutter-line-sdk", targets: ["flutter_line_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/line/line-sdk-ios-swift.git", from: "5.17.0"),
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_line_sdk",
            dependencies: [
                .product(name: "LineSDK", package: "line-sdk-ios-swift"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: []
        )
    ]
)
