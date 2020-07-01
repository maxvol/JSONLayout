// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "JSONLayout",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        .library(
            name: "JSONLayout",
            targets: ["JSONLayout"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "JSONLayout",
            dependencies: [],
            path: "Sources"),
//        .testTarget(
//            name: "JSONLayoutTests",
//            dependencies: ["JSONLayout"],
//            path: "Tests"
//        )
    ]
)
