// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDomain",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppDomain",
            targets: ["AppDomain"]
        ),
    ],
    dependencies: [
        .package(path: "../AppFoundation")
    ],
    targets: [
        .target(
            name: "AppDomain",
            dependencies: [
                .product(name: "AppFoundation", package: "AppFoundation")
            ]
        ),
        .testTarget(
            name: "AppDomainTests",
            dependencies: ["AppDomain"]
        ),
    ]
)
