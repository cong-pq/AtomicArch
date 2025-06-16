// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AtomicCore",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "AtomicCore",
      targets: ["AtomicCore"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "AtomicCore",
      dependencies: []
    ),
    .testTarget(
      name: "AtomicCoreTests",
      dependencies: ["AtomicCore"]
    )
  ]
)
