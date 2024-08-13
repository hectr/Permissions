// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Permissions",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v14),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v8),
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
