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
        .package(
            url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
            from: "0.8.3"
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
            name: "AlgebraicFunctions",
            dependencies: [
                "AlgebraicFunctionsPlugin",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "AlgebraicFunctionsTests",
            dependencies: [
                "AlgebraicFunctions",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "PowerAssert", package: "swift-power-assert"),
            ]
        ),
    ]
)
