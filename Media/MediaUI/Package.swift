// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "MediaUI",
            type: .dynamic,
            targets: ["MediaUI"]
        )
    ],
    targets: [
        .target(
            name: "MediaUI",
            path: "."
        )
    ]
)
