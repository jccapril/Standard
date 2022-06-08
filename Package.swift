// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Standard",
    products: [
        .library(name: "Standard", targets: ["Standard"]),
    ],
    targets: [
        .target(name: "Standard", path: "Sources"),
        .testTarget(name: "StandardTests", dependencies: ["Standard"]),
    ]
)
