// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ManageUpgrades",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "ManageUpgrades",
            targets: ["ManageUpgrades"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ManageUpgrades",
            dependencies: [],
            path: "ios/Classes"
        ),
        .testTarget(
            name: "ManageUpgradesTests",
            dependencies: ["ManageUpgrades"],
            path: "Tests"
        ),
    ]
)
