// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "RAMAnimatedTabBarController",
    // platforms: [.iOS("9.0")],
    products: [
        .library(name: "RAMAnimatedTabBarController", targets: ["RAMAnimatedTabBarController"])
    ],
    targets: [
        .target(
            name: "RAMAnimatedTabBarController",
            path: "RAMAnimatedTabBarController"
        )
    ]
)
