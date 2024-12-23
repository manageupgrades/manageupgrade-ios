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
            path: "Sources/ManageUpgrades",
            exclude: ["ManageUpgradesPlugin.h", "ManageUpgradesPlugin.m"],
            sources: ["ManageUpgrades.swift"],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "ManageUpgradesTests",
            dependencies: ["ManageUpgrades"],
            path: "Tests/ManageUpgradesTests"
        )
    ]
)
