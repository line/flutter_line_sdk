// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_line_sdk",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "flutter-line-sdk", targets: ["flutter_line_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/line/line-sdk-ios-swift.git", from: "5.3.0")
    ],
    targets: [
        .target(
            name: "flutter_line_sdk",
            dependencies: [
                .product(name: "LineSDK", package: "line-sdk-ios-swift")
            ],
            resources: []
        )
    ]
)
