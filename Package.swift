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
    dependencies: [],
    targets: [
        .target(
            name: "SwiftTrader",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftTraderTests",
            dependencies: ["SwiftTrader"]
        )
    ]
)
