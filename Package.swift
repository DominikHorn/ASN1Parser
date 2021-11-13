// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASN1Parser",
    products: [
        .library(
            name: "ASN1Parser",
            targets: ["ASN1Parser"]),
    ],
    dependencies: [
      .package(url: "https://github.com/attaswift/BigInt.git", .upToNextMajor(from: "5.3.0"))
    ],
    targets: [
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
