// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TiationShell",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "TiationShell",
            targets: ["TiationShell"]),
    ],
    dependencies: [
        // SSH library for Swift - using latest available version
        .package(url: "https://github.com/Frugghi/SwiftSH.git", .upToNextMajor(from: "1.6.0")),
        // Keychain wrapper for secure storage
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        // File provider for iOS Files app integration
        .package(url: "https://github.com/WeTransfer/WeScan.git", from: "1.7.0")
    ],
    targets: [
        .target(
            name: "TiationShell",
            dependencies: [
                "SwiftSH",
                "KeychainAccess"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "TiationShellTests",
            dependencies: ["TiationShell"],
            path: "Tests"
        ),
    ]
)
