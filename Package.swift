// swift-tools-version:5.10

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
    dependencies: [],
    targets: [
        .target(
            name: "Permissions",
            dependencies: []
        ),
        .testTarget(
            name: "PermissionsTests",
            dependencies: ["Permissions"]
        ),
    ]
)
