// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodableSQLiteKit",
    platforms: [
     .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0"),
        
    ],
    targets: [
        .target(
            name: "CodableSQLiteKit",
            dependencies: [.product(name: "SQLiteKit", package: "sqlite-kit")]),
        .testTarget(
            name: "CodableSQLiteKitTests",
            dependencies: ["CodableSQLiteKit"]),
    ]
)
