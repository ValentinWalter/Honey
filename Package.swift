// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Honey",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Honey",
            targets: ["Honey"]
        ),
        .executable(
            name: "honey-cli",
            targets: ["HoneyCLI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.6"),
        .package(url: "https://github.com/ValentinWalter/StringCase", .branch("master")),
        .package(url: "https://github.com/ValentinWalter/Middleman", .branch("pre-release")),
    ],
    targets: [
        .target(
            name: "Honey",
            dependencies: [
                "StringCase",
                "Middleman",
            ]
        ),
        .executableTarget(
            name: "HoneyCLI",
            dependencies: [
                .target(name: "Honey"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "HoneyTests",
            dependencies: ["Honey"]
        ),
    ]
)
