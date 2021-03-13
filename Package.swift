// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppLog",
    products: [
        .library(
            name: "AppLog",
            targets: ["AppLog"]
        ),
    ],
    dependencies: [
        // None
    ],
    targets: [
        .target(
            name: "AppLog",
            dependencies: []
        ),
        .testTarget(
            name: "AppLogTests",
            dependencies: ["AppLog"]
        ),
    ]
)
