// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaContentful",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "MediaContentful",
            type: .dynamic,
            targets: ["MediaContentful"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/contentful/contentful.swift", from: "5.5.7"),
        .package(path: "../MediaUI"),
    ],
    targets: [
        .target(
            name: "MediaContentful",
            dependencies: [
                .product(name: "Contentful", package: "contentful.swift"),
                .product(name: "MediaUI", package: "MediaUI")
            ],
            path: "."
        )
    ]
)
