// swift-tools-version:5.5

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
		.package(url: "https://github.com/ValentinWalter/Middleman", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Honey",
            dependencies: [
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
