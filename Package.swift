// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kinopub-sdk",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_12),
        .macCatalyst(SupportedPlatform.MacCatalystVersion.v13),
        .iOS(SupportedPlatform.IOSVersion.v9),
        .tvOS(SupportedPlatform.TVOSVersion.v9),
        .watchOS(SupportedPlatform.WatchOSVersion.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "kinopub-sdk",
            targets: ["kinopub-sdk"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SMStorage", url: "https://github.com/siginur/SMStorage.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "kinopub-sdk",
            dependencies: ["SMStorage"]),
        .testTarget(
            name: "kinopub-sdkTests",
            dependencies: ["kinopub-sdk"]),
    ]
)
