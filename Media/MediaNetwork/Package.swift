// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaNetwork",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "MediaNetwork",
            targets: ["MediaNetwork"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MediaNetwork",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["MediaNetwork"]
        )
    ]
)
