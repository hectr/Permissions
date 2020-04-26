// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Permissions",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "Permissions",
            targets: ["Permissions"]
        ),
    ],
    dependencies: [
        .package(name: "Idioms", url: "https://github.com/hectr/swift-idioms.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "Permissions",
            dependencies: ["Idioms"]
        ),
        .testTarget(
            name: "PermissionsTests",
            dependencies: ["Permissions"]
        ),
    ]
)
