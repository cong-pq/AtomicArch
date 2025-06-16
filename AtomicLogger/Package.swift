// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = .init(
  name: "AtomicLogger",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "AtomicLogger",
      targets: ["AtomicLogger"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0")
  ],
  targets: [
    .target(
      name: "AtomicLogger",
      dependencies: [
        .product(name: "Logging", package: "swift-log")
      ]
    )
  ]
)
