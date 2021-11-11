// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASN1Parser",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ASN1Parser",
            targets: ["ASN1Parser"]),
    ],
    dependencies: [
      .package(url: "https://github.com/attaswift/BigInt.git", .upToNextMajor(from: "5.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ASN1Parser",
            dependencies: [
              .product(name: "BigInt", package: "BigInt")
            ]),
        .testTarget(
            name: "ASN1ParserTests",
            dependencies: [
              "ASN1Parser",
              .product(name: "BigInt", package: "BigInt")
            ]),
    ]
)
