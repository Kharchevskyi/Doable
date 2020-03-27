// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Signing",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Signing",
            targets: ["Signing"]
        )
    ],
    dependencies: [
         .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "6.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Signing",
            dependencies: ["FacebookCore", "FacebookLogin"]),
        .testTarget(
            name: "SigningTests",
            dependencies: ["Signing"]),
    ]
)
