// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftTrader",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftTrader",
            targets: ["SwiftTrader"]
        )
    ],
    dependencies: [
        // [Server-side Support] SwiftCrypto is a Linux-compatible port of Apple's CryptoKit library.
        .package(url: "https://github.com/apple/swift-crypto.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "SwiftTrader",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto")
            ]
        ),
        .testTarget(
            name: "SwiftTraderTests",
            dependencies: ["SwiftTrader"]
        )
    ]
)
