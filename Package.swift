// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChessEngine",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChessEngine",
            targets: ["ChessEngine"]),
    ], dependencies: [
        .package(url: "https://github.com/tomieq/Logger", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/tomieq/SwiftExtensions", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ChessEngine",
            dependencies: [
                .product(name: "Logger", package: "Logger"),
                .product(name: "SwiftExtensions", package: "SwiftExtensions")
            ]),
        .testTarget(
            name: "ChessEngineTests",
            dependencies: ["ChessEngine"]
        ),
    ]
)
