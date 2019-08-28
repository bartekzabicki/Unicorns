// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Unicorns",
    platforms: [.iOS(.v10), .macOS(.v10_13)],
    products: [
        .library(
            name: "Unicorns",
            targets: ["Unicorns"]),
    ],
    targets: [
        .target(
            name: "Unicorns",
            dependencies: [],
            path: ".",
            sources: ["Unicorns/Classes"])
    ]
)
