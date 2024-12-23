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
            type: .dynamic,
            targets: ["ManageUpgrades"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ManageUpgrades",
            dependencies: [],
            path: "Sources/ManageUpgrades",
            sources: ["ManageUpgrades.swift"]
        ),
        .testTarget(
            name: "ManageUpgradesTests",
            dependencies: ["ManageUpgrades"],
            path: "Tests/ManageUpgradesTests"
        )
    ]
)
