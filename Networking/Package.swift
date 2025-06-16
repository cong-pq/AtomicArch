// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "Networking",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Networking",
      targets: ["Networking"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Networking",
      dependencies: [],
      path: "Sources/Networking"
    ),
    .testTarget(
      name: "NetworkingTests",
      dependencies: ["Networking"],
      path: "Tests/NetworkingTests"
    )
  ]
)
