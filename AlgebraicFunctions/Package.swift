// swift-tools-version: 5.9
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "AlgebraicFunctions",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "AlgebraicFunctions",
            targets: ["AlgebraicFunctions"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-06-05-a"
        ),
    ],
    targets: [
        .macro(
            name: "AlgebraicFunctionsPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "AlgebraicFunctions"
        ),
        .testTarget(
            name: "AlgebraicFunctionsTests",
            dependencies: ["AlgebraicFunctions"]
        ),
    ]
)
