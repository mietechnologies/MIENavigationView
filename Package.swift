// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MIENavigationView",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MIENavigationView",
            targets: ["MIENavigationView"]
        ),
    ],
    targets: [
        .target(name: "MIENavigationView"),
        .testTarget(
            name: "MIENavigationViewTests",
            dependencies: ["MIENavigationView"]
        ),
    ]
)
